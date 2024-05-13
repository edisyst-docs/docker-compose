# Problema
Creare con un Docker container una `infrastruttura costituita da 3 macchine`: 
una (master) che unicamente col servizio `Ansible` trasmetterà dei semplici `comandi tramite shell bash` alle altre 2 macchine (slave). 
Configurare una rete tra queste 3 macchine affinchè la macchina master possa comunicare con le 2 slave

# Soluzione docker-compose
- Creare il file docker-compose.yml:
- Creare la directory per il master e per le slave:
  - Crea due directory separate chiamate master e slave.
  - All'interno di ciascuna di queste directory, crea un Dockerfile per costruire i rispettivi container.
- Scrivi i Dockerfile:
  - Dockerfile per il master (master/Dockerfile):
  - Dockerfile per le slave (slave/Dockerfile):
- Crea i file di configurazione di Ansible:
  - ansible.cfg: Configura Ansible per eseguire i comandi in modalità locale.
  - hosts: Definisci gli host su cui eseguire i comandi.
  - playbook.yml: Definisci i comandi da eseguire sulle macchine slave.
- Esegui docker-compose up:
  - Assicurati di essere nella stessa directory del file docker-compose.yml.
  - Esegui docker-compose up --build per avviare i container. Questo comando costruirà i container basati sui Dockerfile e li avvierà.

Ora dovresti avere un'infrastruttura Docker costituita da tre macchine: una master che esegue Ansible e due slave. 
Ansible trasmetterà i comandi bash alle macchine slave attraverso una rete interna Docker. 
Assicurati di avere Ansible installato nel tuo ambiente host per eseguire questo setup.
