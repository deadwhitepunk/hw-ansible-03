# Домашнее задание к занятию 3 «Использование Ansible»

## Желонкин Дмитрий

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
```yaml
- name: Install Lighthouse
  hosts: lighthouse
  become: true

  tasks:
    - name: Update apt cache
      ansible.builtin.apt:
        update_cache: true

    - name: Install required packages (git, nginx)
      ansible.builtin.package:
        name:
          - git
          - nginx
        state: present

    - name: Clone lighthouse repository
      ansible.builtin.git:
        repo: "{{ lighthouse_repo }}"
        dest: "{{ lighthouse_dest }}"
        depth: 1
        version: master
      register: git_clone

    - name: Set correct permissions for lighthouse directory
      ansible.builtin.file:
        path: "{{ lighthouse_dest }}"
        owner: "{{ nginx_user }}"
        group: "{{ nginx_user }}"
        recurse: true
        state: directory

    - name: Create Nginx configuration for lighthouse
      ansible.builtin.template:
        src: templates/lighthouse_nginx.conf.j2
        dest: "/etc/nginx/sites-available/lighthouse"
        mode: "0644"
      notify: Reload nginx

    - name: Enable lighthouse site
      ansible.builtin.file:
        src: "/etc/nginx/sites-available/lighthouse"
        dest: "/etc/nginx/sites-enabled/lighthouse"
        state: link
      notify: Reload nginx

    - name: Remove default nginx site if exists
      ansible.builtin.file:
        path: "/etc/nginx/sites-enabled/default"
        state: absent
      notify: Reload nginx
      ignore_errors: "{{ ansible_check_mode }}"

    - name: Ensure nginx is running and enabled
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Reload nginx
      ansible.builtin.service:
        name: nginx
        state: reloaded
```
4. Подготовьте свой inventory-файл `prod.yml`.
```yaml
---
all:
  vars:
    ansible_user: user
    ansible_ssh_private_key_file: ~/.ssh/id_ed25519
    ansible_python_interpreter: /usr/bin/python3

clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 94.131.84.96
vector:
  hosts:
    vector-01:
      ansible_host: 94.131.95.72
lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 94.131.91.120
```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
![lint](https://github.com/deadwhitepunk/hw-ansible-03/blob/main/img/ansible-lint.png)
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

Плэйбук завершился ошибкой, так как он не производит установку, а handler пытается запустить сервис который не установлен

![check](https://github.com/deadwhitepunk/hw-ansible-03/blob/main/img/ansible_check.png)
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
![1.11](https://github.com/deadwhitepunk/hw-ansible-03/blob/main/img/diff1.png)
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
![1.11](https://github.com/deadwhitepunk/hw-ansible-03/blob/main/img/diff2.png)
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
[Ссылка на README playbook](https://github.com/deadwhitepunk/hw-ansible-03/blob/main/playbook/README.md)
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

[Ссылка на TERRAFORM](https://github.com/deadwhitepunk/hw-ansible-03/blob/main/terraform)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---