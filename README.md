# 🗳️ 2-Tier Voting App — AWS Deployment 🚀

A cloud-hosted **Voting Application** deployed on **AWS** using a **2-Tier Architecture**:

* 🎨 **Frontend** → Static Website on **Amazon S3**
* ⚙️ **Backend API** → Python Flask on **Amazon EC2** (private subnet)
* 🗄️ **Database** → **Amazon RDS** PostgreSQL (private subnet)
* 🔀 **Load Balancing** → Application Load Balancer (**ALB**)
* 🌐 **Networking** → Custom **VPC** with public & private subnets

---

## 📌 Architecture Overview

```
User → S3 Website (Frontend) → ALB → EC2 (Backend) → RDS (Postgres)
```

### 🖼️ Architecture Diagram

!\[AWS 2-Tier Architecture]\(*I'll update it soon* )

---

## ⚙️ Technologies Used

* **Amazon S3** → Static website hosting for frontend
* **Amazon EC2** → Flask backend API server
* **Amazon RDS** → PostgreSQL database
* **AWS VPC** → Custom network with public/private subnets
* **Application Load Balancer (ALB)** → Distributes traffic to backend
* **Python (Flask, Gunicorn)** → Backend framework & WSGI server
* **Flask-CORS** → Handles cross-origin requests between frontend & backend

---

## 🔧 1️⃣ Backend EC2 Setup

### Step 1: Launch EC2

* **AMI:** Ubuntu 22.04
* **Subnet:** Private (inside VPC)
* **Security Group:** Allow port **5000** from ALB only
* **IAM Role:** Access to SSM, CloudWatch, and S3 (optional for code pull)

---

### Step 2: User Data Script

```bash
# Switch to Ubuntu user
sudo su - ubuntu

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

# 6️⃣ Clone app repo (replace with your repo URL)
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
Environment="DB_HOST=(your-rds-endpoint)"  # RDS endpoint
Environment="DB_NAME=postgres"   # DB name
Environment="DB_USER=saksham"    # DB username
Environment="DB_PASS=sakshamsingh"  # DB password
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
```

---

## 🌍 2️⃣ S3 Frontend Hosting

### Step 1: Create S3 Bucket

* Name: `my-voting-frontend-2tierapp`
* Region: Same as backend
* Disable **Block All Public Access**

---

### Step 2: Upload Files

📂 Upload:

```
### for example:

frontend/index.html
frontend/result.html          ()
frontend/css/style.css
```

---

### Step 3: Enable Static Website Hosting

* Index document: `index.html`
* Note the **S3 Website URL**

---

### Step 4: Set Public Read Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::(your-bucket-name)*"
    }
  ]
}
```

---

### Step 5: Update API Endpoint

✏️ Edit **`index.html`** and replace the API URL with your **ALB DNS name**.

---

## 🧪 3️⃣ Testing

✅ Visit **S3 Website URL** → Loads frontend
✅ Submit vote → Goes through **ALB → EC2 → RDS**
✅ Check backend logs in **CloudWatch** (optional)

---

## 🧹 4️⃣ Cleanup (Avoid Charges)

* 🗑️ Delete **S3 bucket**
* 🗑️ Delete **RDS instance**
* 🗑️ Delete **EC2 instance**
* 🗑️ Delete **ALB**
* 🗑️ Delete **VPC resources**

---

## 📄 License

This project is for **learning/demo purposes only** — not production-ready without security hardening.
