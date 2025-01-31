**Task 1 - SimpleTimeService Deployment App Guide**
======================================

This document provides step-by-step instructions to **clone**, **build**, **push**, and **run** the SimpleTimeService Docker container. It also includes the GitHub Actions workflow for automated Docker builds and publish.
* * * * *

 Prerequisites
--------------------

Before proceeding, ensure you have the following tools installed:

Mandatory - <br> 
**Git** - [Installation link](http://git-scm.com/downloads)<br>
**Docker** - [Installation link linux](https://docs.docker.com/engine/install/)  , [Installation link windows](https://docs.docker.com/desktop/setup/install/windows-install/)<br>
Optional - **GitHub Account**, **Docker Hub Account** (for automation)


* * * * *

**Cloning the Repository**
-----------------------------

Clone the project from GitHub Repository in your working directory:

```
git clone https://github.com/NaveenKumar-Y/particle41_assessment.git
cd app
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

### **Step 2: Run the Container (Detached Mode)**

```
docker run naveenykumar/simpletimeservice:latest
```

-  Click on the service endpoints in the output of Docker run command or  service will be available at **`http://<your-ip>:18630`** or **`http://localhost:18630`**. 
<br>
<br>
*Preview:*

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

Create a [.github/workflows/build_publish_docker.yml](.github/workflows/build_publish_docker.yml) file or use the exisiting file in the repository and add the following workflow:


```
name: Build and Push Docker Image

on:
  push:
    branches:
      - main 

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
docker naveenykumar/simpletimeservice
```

Now, the service will be running and accessible at:\
👉 **`http://<server-ip>:18630`**

* * * * *