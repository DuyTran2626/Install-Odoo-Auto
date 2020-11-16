#!/bin/sh
sudo apt update 
sudo apt upgrade -y 
sudo apt install git python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less -y
sudo useradd -m -d /opt/odoo13 -U -r -s /bin/bash odoo13
sudo apt install postgresql -y
sudo su - postgres -c "createuser -s odoo13"

sudo su - odoo13 command
git clone https://www.github.com/odoo/odoo --depth 1 --branch 13.0 /opt/odoo13/odoo
cd /opt/odoo13
python3 -m venv odoo-venv
source odoo-venv/bin/activate
pip3 install wheel
pip3 install -r odoo/requirements.txt
deactivate
mkdir /opt/odoo13/odoo-extra-addons
sudo su - getcare command

sudo cp /opt/odoo13/odoo/debian/odoo.conf /etc/odoo13.conf

sudo cat <<EOF > /etc/odoo13.conf

[options]
; This is the password that allows database operations:
admin_passwd = getcare2020
db_host = localhost
db_port = False
db_user = odoo13
db_password = getcare2020
addons_path = /opt/odoo13/odoo/addons,/opt/odoo13/odoo-extra-addons
xmlrpc_port = 8069
EOF

sudo cat <<EOF > /etc/systemd/system/odoo13.service

[Unit]
Description=odoo13
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=odoo13
PermissionsStartOnly=true
User=odoo13
Group=odoo13
ExecStart=/opt/odoo13/odoo-venv/bin/python3 /opt/odoo13/odoo/odoo-bin -c /etc/odoo13.conf
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo -u postgres psql -c "ALTER ROLE odoo13 WITH password 'getcare2020'"

sudo snap install pycharm-community --classic

