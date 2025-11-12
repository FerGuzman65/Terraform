# ☁️ AWS Photo Upload App with Terraform

This project creates a simple **web application** where a user can upload photos that are automatically stored in an **Amazon S3 bucket**.  
All resources are deployed using **Terraform** and AWS **IAM roles** for secure access.

---

## 🧱 Project Structure

aws-photo-upload/
│
├── main.tf # Main Terraform configuration (resources)
├── variables.tf # Input variables (region, instance type, etc.)
├── outputs.tf # Outputs (bucket name, instance IP, app URL)
├── setup.sh # Script to deploy Flask app on EC2
├── README.md # Project documentation
└── .gitignore # Ignore local and sensitive files

yaml
Copiar código

---

## 🚀 How It Works

1. Terraform creates:
   - An **S3 bucket** to store uploaded photos.
   - An **IAM role and policy** for EC2 to upload to S3.
   - A **security group** that allows HTTP (80) and SSH (22).
   - An **EC2 instance** that runs a simple Flask web app.

2. The user accesses the EC2 public IP to open the web app.

3. The app uploads any selected image directly to S3.

---

## 🧩 Setup Instructions

### 1️⃣ Prerequisites
- AWS account with programmatic access.
- Terraform installed (≥ 1.6.0).
- Visual Studio Code or any IDE.
- AWS credentials configured (`aws configure`).

---

### 2️⃣ Initialize and Deploy

Open your terminal inside the project folder and run:

```bash
terraform init
terraform plan
terraform apply
Confirm with yes.

After a few minutes, Terraform will display something like:

makefile
Copiar código
Outputs:
app_url = "http://3.94.XX.XX"
bucket_name = "photo-upload-ferguzman"
instance_public_ip = "3.94.XX.XX"
3️⃣ Test the Web App
Open your browser and go to the app_url.

Use the upload form to choose an image.

Check your S3 bucket in the AWS Console → the image will appear there.

4️⃣ Clean Up Resources
To delete all resources created by Terraform:

bash
Copiar código
terraform destroy
Confirm with yes.

🧠 Learning Objectives
Understand how an IAM Role allows EC2 to upload to S3.

Learn how Terraform state tracks and manages resources.

Practice the full Infrastructure as Code (IaC) workflow.

👩‍💻 Author
Fer Guzmán
Universidad Autónoma de Guadalajara
Course: Cloud Computing
Instructor: Prof. Edgar Omar Lara
Date: November 2025