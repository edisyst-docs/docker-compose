In questo dopker-compose.yml c'è questa istruzione che si usa spesso quando si collegano webserver e DB
```yaml
depends_on:
- "db" # dipendenza, il container verrà avviato solo dopo aver avviato il "db"
```