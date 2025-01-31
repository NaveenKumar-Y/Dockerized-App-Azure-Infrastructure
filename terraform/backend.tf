terraform { 
  cloud { 
    
    organization = "Naveen_org" 

    workspaces { 
      name = "azure-app-dev-eastus2" 
    } 
  } 
}