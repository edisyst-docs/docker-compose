-- Crea il database
CREATE DATABASE ecommerce;

-- Connetti al database
\c ecommerce;

-- Tipi custom
CREATE TYPE stato_ordine AS ENUM ('in_attesa', 'spedito', 'annullato');

-- Clienti con dati JSON e array
CREATE TABLE clienti (
                         id SERIAL PRIMARY KEY,
                         nome TEXT NOT NULL,
                         email TEXT UNIQUE NOT NULL,
                         preferenze JSONB,
                         tag TEXT[]
);

CREATE INDEX idx_clienti_lingua ON clienti ((preferenze->>'lingua'));

-- Prodotti con full-text search
CREATE TABLE prodotti (
                          id SERIAL PRIMARY KEY,
                          nome TEXT NOT NULL,
                          descrizione TEXT,
                          prezzo NUMERIC(10,2) CHECK (prezzo >= 0)
);

CREATE INDEX idx_fts_prodotti ON prodotti USING gin(to_tsvector('italian', descrizione));

-- Ordini
CREATE TABLE ordini (
                        id SERIAL PRIMARY KEY,
                        id_cliente INT REFERENCES clienti(id),
                        data_ordine TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        stato stato_ordine DEFAULT 'in_attesa'
);

-- Dettagli ordine
CREATE TABLE ordini_prodotti (
                                 id SERIAL PRIMARY KEY,
                                 id_ordine INT REFERENCES ordini(id),
                                 id_prodotto INT REFERENCES prodotti(id),
                                 quantita INT CHECK (quantita > 0)
);

-- INSERT demo clienti
INSERT INTO clienti (nome, email, preferenze, tag) VALUES
                                                       ('Mario Rossi', 'mario@esempio.com', '{"lingua": "it", "newsletter": true}', ARRAY['premium', 'ritiro_in_sede']),
                                                       ('Lucia Verdi', 'lucia@esempio.com', '{"lingua": "en", "newsletter": false}', ARRAY['nuovo']),
                                                       ('Giovanni Bianchi', 'giovanni@esempio.com', '{"lingua": "it", "newsletter": true}', ARRAY['ritiro_in_sede']);

-- INSERT demo prodotti
INSERT INTO prodotti (nome, descrizione, prezzo) VALUES
                                                     ('Proteine Whey', 'Integratore di proteine del siero del latte in polvere', 29.99),
                                                     ('Creatina Monoidrato', 'Creatina per migliorare forza e resistenza muscolare', 19.90),
                                                     ('Pre-Workout', 'Stimolante pre-allenamento con caffeina e beta-alanina', 24.50);

-- INSERT demo ordini
INSERT INTO ordini (id_cliente, stato) VALUES
                                           (1, 'in_attesa'),
                                           (2, 'spedito');

-- INSERT demo ordini_prodotti
INSERT INTO ordini_prodotti (id_ordine, id_prodotto, quantita) VALUES
                                                                   (1, 1, 2),  -- Mario ha ordinato 2 Whey
                                                                   (1, 2, 1),  -- Mario ha ordinato 1 Creatina
                                                                   (2, 3, 1);  -- Lucia ha ordinato 1 Pre-Workout
