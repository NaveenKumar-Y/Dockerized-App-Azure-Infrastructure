**Dockerized App on Azure: Infrastructure Automation with Terraform**
===============================================

This repository contains the solution to the **Particle41 DevOps Team Challenge**, which provides a simple web service (`SimpleTimeService`) along with the necessary infrastructure to deploy it in a Azure cloud environment. It covers application development, containerization, and automated deployment using Terraform.

Table of Contents
-----------------

-   [Task 1 - SimpleTimeService Deployment App](#Task-1---SimpleTimeService-Deployment-App-Guide)
-   [Task 2 - Terraform and Cloud Deployment](#Task-2---AKS-Deployment-with-Load-Balancer-Guide)  
  
**Task 1 - SimpleTimeService Deployment App Guide**
======================================

This Section provides step-by-step instructions to **clone**, **build**, **push**, and **run** the SimpleTimeService Docker container. It also includes the GitHub Actions workflow for automated Docker builds and publish.
* * * * *

 Prerequisites
--------------------

Before proceeding, ensure you have the following tools installed:

Mandatory - <br> 
**Git** - [Installation link](http://git-scm.com/downloads)<br>
**Docker** - [Installation link linux](https://docs.docker.com/engine/install/)  , [Installation link windows](https://docs.docker.com/desktop/setup/install/windows-install/)<br>
Optional - [GitHub Account](https://github.com/signup), [Docker Hub Account](https://app.docker.com/signup) (for automation)


* * * * *

**Cloning the Repository**
-----------------------------

Clone the project from GitHub Repository in your working directory:

```
git clone https://github.com/NaveenKumar-Y/Dockerized-App-Azure-Infrastructure.git
cd Dockerized-App-Azure-Infrastructure/app
```

* * * * *

**Building & Running Locally (Manual Method)**
--------------------------------------------------

### **Step 1: Build or pull the Docker Image**


```
docker build -t naveenykumar/simpletimeservice:latest .
```
or <br>
```
docker pull naveenykumar/simpletimeservice:latest
```

### **Step 2: Run the Container**

```
docker run -p 18630:18630 naveenykumar/simpletimeservice:latest
```

-  Click on the service endpoints in the output of Docker run command or  service will be available at **`http://localhost:18630`** or **`http://127.0.0.1:18630`**
<br>
<br>
_Preview:_

   ![image](.github/images/app_server.PNG)

* * * * *

**Automating with GitHub Actions**(Optional)
-------------------------------------

### **Step 1: Configure Docker Hub Credentials**

1.  Create and go to your GitHub repository.
2.  Navigate to **Settings** → **Secrets and variables** → **Actions**.
3.  Click **New repository secret** and add:
    -   **`DOCKER_USERNAME`** → Your Docker Hub username
    -   **`DOCKER_PASSWORD`** → Your Docker Hub password or access token

### **Step 2: Add GitHub Actions Workflow**

 [.github/workflows/build_publish_docker.yml](.github/workflows/build_publish_docker.yml)  - use this exisiting file in the repository to trigger the Build process (make sure have some change in app/ folder):


```
name: Build and Push Docker Image

on:
  push:
    branches:
      - main
    paths:
      - 'app/**'

jobs:
  build-and-push:
    runs-on: ubuntu-latest  
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker Image
        working-directory: app/
        run: docker build -t naveenykumar/simpletimeservice:latest .

      - name: Push Docker Image
        run: docker push naveenykumar/simpletimeservice:latest

```
**NOTE** : Make sure to commit only `app/` to avoid triggering other workflows.

### **Step 3: Push Code to Trigger the Workflow**

Once this file is committed and pushed to the branch main in GitHub, GitHub Actions will:

1.  Build the Docker image.
2.  Push it to Docker Hub automatically.

Sample GitHub Action Run : [Link to Build Job run](https://github.com/NaveenKumar-Y/particle41_assessment/actions/runs/13066787923/job/36460429960)

* * * * *

**Pulling & Running the Container Anywhere**
-----------------------------------------------

After the image is published, anyone can deploy the container without building it manually.


```
docker pull naveenykumar/simpletimeservice:latest
docker run naveenykumar/simpletimeservice
```

Now, the service will be running and accessible at:\
👉 **`http://<server-ip>:18630`**

* * * * *
<br>
<br>
<br>

**Task 2 - AKS Deployment with Load Balancer Guide**
=================================

Overview
--------

This project sets up an **Azure Kubernetes Service (AKS) cluster** in Azure Cloud with **2 public and 2 private subnets**, deploys a containerized application to the private subnets, and exposes it through a **Load Balancer (LB) in the public subnets**.

Prerequisites
-------------

Before running the Terraform deployment, ensure you have the following installed:

-   **Azure Cloud Account**: [Getting Started](https://azure.microsoft.com/en-in/pricing/purchase-options/azure-account/)

-   **Terraform**: [Install Guide](https://developer.hashicorp.com/terraform/install) - version v1.10.5

-   **Azure CLI**: [Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) or use Azure Cloud Shell in Azure Cloud UI.

-   **Kubectl** (for interacting with the AKS cluster): [Install Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/) or use Azure Cloud Shell in Azure Cloud UI.
- Optional - [GitHub Account](https://github.com/signup), [Terraform Cloud Account](https://app.terraform.io/public/signup/account) - for automation


Authentication
--------------

Before running Terraform, authenticate to Azure using:

```
az login
az account set --subscription <your-subscription-id>
```
Create a subscription if not created already and fetch the **\<your-subscription-id\>** from the subscription UI. <br>



Deployment Steps (Local Machine)
----------------

### 1. Clone the Repository

```
git clone https://github.com/NaveenKumar-Y/Dockerized-App-Azure-Infrastructure.git
cd Dockerized-App-Azure-Infrastructure/terraform
```
If you already cloned the repo in [Task 1](#Task-1---SimpleTimeService-Deployment-App-Guide), just change directory to "[/terraform](/terraform/)"

### 2. Set Up Variables and credentials

Use default values or Optional - customize the [`terraform.tfvars`](/terraform/terraform.tfvars) file with your values(make sure to use valid inputs):

```
location            = "East US"
resource_group_name = "naveen-resource-group"
vnet_name           = "naveen-vnet"
...
```


###  3. Initialize Terraform

```
terraform init
```

### 4. Validate Configuration

```
terraform plan
```

This step ensures everything is configured correctly.

### 5. Apply Infrastructure Deployment

```
terraform apply -auto-approve
```

This command provisions:

-   **Azure VPC** with 2 public and 2 private subnets

-   **AKS Cluster** with nodes in private subnets

-   **Load Balancer** in public subnets to expose the service

-   **Deployment of the containerized application** <br>
  
The State of this deployment will be saved locally in .terraform directory.

### 6. Retrieve Load Balancer IP

Once the deployment is successful, retrieve the public LB IP or from the AKS cluster UI "**Services and ingresses**" tab:

```
kubectl get svc -n default
```
-   If `kubectl` commands fail, fetch credentials using:

    ```
    az aks get-credentials --resource-group naveen-resource-group --name naveen-aks-cluster
    ```

Look for the `**EXTERNAL-IP**` of the LoadBalancer service.

### 7. Test the Application

Open your browser or use `curl` to access the service:

```
curl http://<load-balancer-ip>:18630
```

You should see a JSON response with a timestamp and IP address.

Cleanup
-------

To destroy all resources, run:

```
terraform destroy -auto-approve
```

Troubleshooting
---------------

-   If Terraform Command fails, check if Environment Variable is set for $PATH in your system or reopen the terminal if already $PATH is set- [guide](https://jeffbrown.tech/install-terraform-windows/)
-   If "`az login`" doesn't work, use the SPN for authentication, follow the step `Step 2: Configure Workspace` in below automation section.

- If `terraform apply` fails for a **Deployment** or **Service** showing DNS issues, wait for AKS to fully initialize, check the AKS UI for namespace accessibility, and verify readiness using `kubectl cluster-info` before re-running `terraform apply`. This scenario is rare but can occur due to Azure resource provisioning delays or network slowness.
- if the Service endpoint is not accessible via a browser, check for firewall restrictions or use  `curl` to access the service from Azure Cloud Shell.



Automation via GitHub Actions & Terraform Cloud (TFC) (Optional)
----------------------------------------------------------------

### **Step 1: Configure Terraform Cloud**

1.  Create and go to your Terraform Account.
2.  Create project, workspace and `token`.
3.  In GitHub repository, navigate to **Settings** → **Secrets and variables** → **Actions**.
4.  Click **New repository secret** and add the `token`:
    -   **`TFC_TOKEN`** → TFC access token
   
### **Step 2: Configure Workspace**
- If you haven't already created a **Service Principal (SPN)** for Terraform, create one using:

  ```
  az ad sp create-for-rbac --name "Terraform-actions-SPN" --role="Contributor" --scopes="/subscriptions/<your-subscription-id>"
  ```
- Substitute Azure credential values of SPN (client_id, client_secret, subscription_id, tenant_id) as **TFC Secret Variables** in Terraform Cloud Workspace variables as sensitive.
- Uncommnent the following provider block in [`main.tf`](./terraform/main.tf) which uses TFC secrets to authenticate.

  ```
  provider "azurerm" {
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    features {
    }
  }
  ```
- Uncomment and update the [`backend.tf`](./terraform/backend.tf) file with your **workspace name**.


### **Step 3: Push Code to Trigger the Workflow**

- [build_terraform_azure_resources.yml](.github/workflows/build_terraform_azure_resources.yml)  - use this exisiting file in the repository to trigger the Build process (make sure have some change in terraform/ folder):
- Once the files are committed and pushed to the branch main in GitHub, GitHub Actions will run **terraform plan** and **terraform apply**.
- From this setup we don't have to hard code sensitive values in our code, and secure our state file, and automate our Deployment.
  

Sample GitHub Action Run : [Link to Build Job run](https://github.com/NaveenKumar-Y/Dockerized-App-Azure-Infrastructure/actions/runs/13088189096/job/36521824479)

Now, the service will be running and accessible at:\
👉 **`http://<EXTERNAL-IP>:18630`**

* * * * *