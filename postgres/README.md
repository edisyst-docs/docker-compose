# PostgreSQL 15 + pgAdmin 4
Il `docker-compose.yml` crea due container:
- `postgres_db`: PostgreSQL 15 con DB ecommerce
- `pgadmin`: interfaccia web accessibile su http://localhost:8080

# 1. Avvia il container PostgreSQL
Avvia con `docker compose up -d`
```bash
docker compose up -d
```

# 2. Accedi a pgAdmin per creare il server
Accedi a http://localhost:8080,
- Email: admin@admin.com
- Password: admin

In File > Preferenze > Interfaccia utente > Tema posso mettere il tema scuro.

# 3. Aggiungi un nuovo server:
- Vai su pgAdmin > Register > Server
- Nel tab `General`:
  - Name: Postgres (puoi scegliere tu)
- Nel tab `Connection`:
  - Host name/address: db  (non localhost, non IP)
  - Port: 5432
  - Maintenance database: ecommerce
  - Username: postgres
  - Password: secret
  - ✅ Spunta "Save Password"
- Clicca su `Save`.

Importa il database `ecommerce_dump.sql`:
- Vai su pgAdmin > Tools > Query Tool
- Copia il contenuto di `ecommerce_dump.sql` e incollalo
- Premi F5 o click su Execute ▶️
- Le tabelle create si trovano in `Databases > ecommerce > Schemas > public > Tables`

# 4. Esercitati con le query
- nel file `query_esercizi_postgres.sql` ci sono un po' di esempi di query
- Vai su pgAdmin > Tools > Query Tool
- posso eseguirle singolarmente
- posso incollare tutto il suo contenuto nel Query Tool di pdAdmine premere F5

Posso lanciare da docker tutte le query del file con:
```bash
docker exec -i postgres_db psql -U postgres -d ecommerce < ./query_esercizi_postgres.sql
```

