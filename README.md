Posso fare volendo delle prove con un container solo, anche se Docker-compose si usa per "unire" più container. 
Ovviamente è inutile usare Docker-compose se devo usare un unico container, ma è giusto per far delle prove 

Qui c'è un esempio di FE+BE che posso copiare per esercizio: https://www.youtube.com/watch?v=HG6yIjZapSA

MIN 34:31 https://www.youtube.com/watch?v=bw6Iq-hIcqo

Voglio collegare il mio webserver `apache+php` (gli ho già fatto installare le librerie) ad un DB `mysql`.

Serve un altro container `docker pull mysql`

Devo creare due container collegati fra loro: uno basato sul mio `my-php-apache-mysqli` e uno su `mysqli`.

Devo anche settarli: mapping porte e cartelle. In questo caso metto tutto nel `docker-compose.yml`. Fatto questo, lancio:
```bash
cd apache-mysql/
docker-compose up
```

# Esercizio - composefile - WS e DB

```bash
mkdir composefile
$null > composefile/docker-compose.yml
```
I `services` sono i container che voglio eseguire: WS e DB

```bash
cd composefile/
docker-compose config # mi valida il file se non ci sono errori
docker-compose up -d # detach mode, come per i container: resta in esecuzione
docker ps # sono DUE i container in esecuzione
docker-compose stop
```



