#!/bin/bash

# 1️⃣ Update packages
sudo apt update -y

# 2️⃣ Install Git & Python
sudo apt install -y git python3 python3-venv

# 3️⃣ Create and activate Python virtual environment
cd /home/ubuntu
python3 -m venv venv
source venv/bin/activate

# 4️⃣ Upgrade pip and install dependencies
pip install --upgrade pip
pip install gunicorn flask flask-cors psycopg2-binary

# 5️⃣ Deactivate venv (systemd will reactivate it)
deactivate

# 6️⃣ Clone app repo
cd /home/ubuntu
if [ ! -d "app" ]; then
    git clone https://github.com/apexsaksham/2-tier-app.git app
else
    cd app && git pull
fi

# 7️⃣ Assign correct permissions
sudo chown -R ubuntu:ubuntu /home/ubuntu/app

# 8️⃣ Create systemd service for backend
sudo tee /etc/systemd/system/voting.service > /dev/null <<'EOF'
[Unit]
Description=Voting Flask App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/app/backend
Environment="${db_host}"
Environment="DB_NAME=postgres"
Environment="DB_USER=saksham"
Environment="DB_PASS=sakshamsingh"
ExecStart=/home/ubuntu/venv/bin/python -m gunicorn --bind 0.0.0.0:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 9️⃣ Start backend service
sudo systemctl daemon-reload
sudo systemctl enable voting
sudo systemctl start voting

# 🔍 Check status
sudo systemctl status voting
