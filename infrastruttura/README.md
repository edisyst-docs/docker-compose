# Problema
Creare con un Docker container una `infrastruttura costituita da 3 macchine`: 
una (master) che unicamente col servizio `Ansible` trasmetterà dei semplici `comandi tramite shell bash` alle altre 2 macchine (slave). 
Configurare una rete tra queste 3 macchine affinchè la macchina master possa comunicare con le 2 slave

# Soluzione docker-compose
Per creare questa infrastruttura con Docker, possiamo utilizzare un singolo container per la macchina master e due container separati per le macchine slave. Utilizzeremo docker-compose per gestire la configurazione della rete e dei container.

Ecco come puoi farlo:

### 1. Creare il file docker-compose.yml
```yaml
version: '3'
services:
  master:
    build: ./master
    networks:
      - mynet
  slave1:
    build: ./slave
    networks:
      - mynet
  slave2:
    build: ./slave
    networks:
      - mynet

networks:
  mynet:
    driver: bridge
```

### 2. Creare la directory per il master e per le slave
- Crea due directory separate chiamate `master` e `slave`.
- All'interno di ciascuna di queste directory, crea un Dockerfile per costruire i rispettivi container.

### 3. Scrivi i Dockerfile:
- Dockerfile per il master (`master/Dockerfile`):
```dockerfile
FROM alpine:latest

RUN apk update && apk add ansible

# Modifico la root folder del container, da cui partiranno i comandi che seguono
# Se `WORKDIR` lo metto prima di `COPY`, possò fare una roba del tipo `COPY . .`
WORKDIR /ansible

# Copia i file di configurazione di Ansible
COPY ansible.cfg hosts playbook.yml ./

CMD ["ansible-playbook", "playbook.yml"]
```

- Dockerfile per le slave (`slave/Dockerfile`):
```dockerfile
FROM alpine:latest

# Configura la macchina slave

CMD ["bash"]
```

### 4. Crea i file di configurazione di Ansible:
`ansible.cfg`: Configura Ansible per eseguire i comandi in modalità locale.
```ini
[defaults]
inventory = ./hosts
```

`hosts`: Definisci gli host su cui eseguire i comandi.
```ini
[slaves]
slave1
slave2
```

`playbook.yml`: Definisci i comandi da eseguire sulle macchine slave.
```yaml
---
- hosts: slaves
  tasks:
    - name: Esegui un comando su tutte le macchine slave
      command: echo "Hello from {{ inventory_hostname }}"
```

Esegui `docker-compose up`:
- Assicurati di essere nella stessa directory del file `docker-compose.yml`.
- Esegui docker-compose up --build per avviare i container. Questo comando costruirà i container basati sui Dockerfile e li avvierà.

Ora dovresti avere un'infrastruttura Docker costituita da tre macchine: una master che esegue Ansible e due slave. 
Ansible trasmetterà i comandi bash alle macchine slave attraverso una rete interna Docker. 
Assicurati di avere Ansible installato nel tuo ambiente host per eseguire questo setup.
