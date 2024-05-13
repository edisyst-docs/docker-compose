FROM alpine:latest

RUN apk update && apk add ansible

WORKDIR /ansible

# Copia i file di configurazione di Ansible
COPY ansible.cfg hosts playbook.yml ./

CMD ["ansible-playbook", "playbook.yml"]
