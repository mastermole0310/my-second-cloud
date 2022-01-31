#!/bin/bash
# Обновление сервера
yum update -y
# Установка docker
amazon-linux-extras install docker -y
# Запуск docker deamon
systemctl start docker
# Создание (добавление) группы docker 
groupadd docker
# Добавление пользователя ec2-user в группу docker
usermod -aG docker ec2-user
# Создание папки для маунта диска
mkdir /mnt/disk_new
# Форматирование диска в системе ext4
mkfs.ext4 /dev/xvdb
# Экспорт данных UUID диска (только цифры) в команду mount 
export DISK_ID=$(blkid /dev/xvdb | cut -c18-53)
# mount диска к созданной папке
mount UUID="$DISK_ID" /mnt/disk_new
# Скачивание и сохранение файл docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Задаем разрешения, чтобы сделать команду docker-compose исполняемой
chmod +x /usr/local/bin/docker-compose
# Добавляем символьную ссылку в /usr/bin.
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# Запускаем файл docker-compose.yml
docker-compose -f /tmp/docker-compose.yml up
