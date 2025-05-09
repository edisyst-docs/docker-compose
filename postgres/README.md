Il file `docker-compose.yml` crea due container:
- postgres_db: PostgreSQL 15 con DB ecommerce
- pgadmin: interfaccia web accessibile su http://localhost:8080 con:

Email: admin@admin.com
Password: admin

Puoi lanciare tutto con `docker compose up -d`

Poi accedi a http://localhost:8080, aggiungi un nuovo server:
- Nome: Postgres
- Host: db
- Username: postgres
- Password: secret





# 1. Crea progetto Laravel
composer create-project laravel/laravel ecommerce-postgres

cd ecommerce-postgres

# 2. Configura .env per PostgreSQL
sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=pgsql/" .env
sed -i "s/DB_HOST=.*/DB_HOST=127.0.0.1/" .env
sed -i "s/DB_PORT=.*/DB_PORT=5432/" .env
sed -i "s/DB_DATABASE=.*/DB_DATABASE=ecommerce/" .env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=postgres/" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=secret/" .env

# 3. Installa Laravel UI e AdminLTE
composer require laravel/ui
php artisan ui bootstrap --auth
npm install
npm install admin-lte@^3.2 --save

# 4. Aggiungi AdminLTE a resources/js/bootstrap.js
echo "import 'admin-lte';" >> resources/js/bootstrap.js

# 5. Compila assets
npm run dev

# 6. Avvia il server di sviluppo
php artisan serve

# 7. Crea i model con migration disabilitata (esistono già nel DB)
php artisan make:model Cliente --no-migration
php artisan make:model Prodotto --no-migration
php artisan make:model Ordine --no-migration
php artisan make:model OrdiniProdotto --no-migration

# 8. Crea controller resource
php artisan make:controller ClienteController --resource
php artisan make:controller ProdottoController --resource
php artisan make:controller OrdineController --resource

# 9. Aggiungi le rotte in routes/web.php
echo "\nRoute::resource('clienti', ClienteController::class);" >> routes/web.php
echo "Route::resource('prodotti', ProdottoController::class);" >> routes/web.php
echo "Route::resource('ordini', OrdineController::class);" >> routes/web.php

# 10. Personalizza layout con AdminLTE
# Apri resources/views/layouts/app.blade.php e sostituisci struttura con AdminLTE
# Puoi copiare un layout base da: https://adminlte.io/themes/v3/starter.html

# 11. Crea viste Blade con tabelle per clienti, prodotti e ordini (index, show, ecc.)
# Esempio: resources/views/clienti/index.blade.php con una table Bootstrap + dati




<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Cliente extends Model
{
    protected $table = 'clienti';
    public $timestamps = false;

    protected $fillable = [
        'nome',
        'cognome',
        'email',
        'dati',
        'preferiti',
        'data_registrazione'
    ];

    protected $casts = [
        'dati' => 'array',          // jsonb
        'preferiti' => 'array',     // text[]
        'data_registrazione' => 'datetime',
    ];

    public function ordini()
    {
        return $this->hasMany(Ordine::class);
    }
}

class Prodotto extends Model
{
    protected $table = 'prodotti';
    public $timestamps = false;

    protected $fillable = [
        'nome',
        'descrizione',
        'prezzo',
        'disponibile',
        'dati_tecnici'
    ];

    protected $casts = [
        'prezzo' => 'decimal:2',
        'disponibile' => 'boolean',
        'dati_tecnici' => 'array',
    ];

    public function ordini()
    {
        return $this->belongsToMany(Ordine::class, 'ordini_prodotti')
                    ->withPivot('quantita')
                    ->withTimestamps();
    }
}

class Ordine extends Model
{
    protected $table = 'ordini';
    public $timestamps = false;

    protected $fillable = [
        'cliente_id',
        'data_ordine',
        'totale'
    ];

    protected $casts = [
        'data_ordine' => 'datetime',
        'totale' => 'decimal:2',
    ];

    public function cliente()
    {
        return $this->belongsTo(Cliente::class);
    }

    public function prodotti()
    {
        return $this->belongsToMany(Prodotto::class, 'ordini_prodotti')
                    ->withPivot('quantita')
                    ->withTimestamps();
    }
}

class OrdiniProdotto extends Model
{
    protected $table = 'ordini_prodotti';
    public $timestamps = false;

    protected $fillable = ['ordine_id', 'prodotto_id', 'quantita'];
}
