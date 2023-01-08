# Create Azure Infrastructure with re-usable Bicep Modules

This repository contains a sample how to effectively model Bicep Modules in a microservice environment to ensure re-usability and modularity. This sample is related to blog post published in my blog (see links below).

# Bicep Module hierachy

I have divided Bicep Modules to four hierarchy levels to enable powerful re-usability and modularity.

![image](https://user-images.githubusercontent.com/11143214/211165365-78dc5566-55f4-4d40-b442-2a4c1842b189.png)

- Main Bicep
  - Main Bicep orchestrates creation of the Azure infrastructure which contains multiple microservices.
- Core Infra
  - Core Infra level determines each microservice and what Productized Resource Collection or Pre-Configured Resource modules are used to create that specific microservice.
- Productized Resource Collections
  - Productized Resource Collection modules are always created for a specific use case. If your environment has multiple microservices which contains API+Database, it's beneficial to create Productized Resource Collection module for this purpose. 
- Pre-configured Resources
  - Pre-configured Resources (Bicep Modules) are prepared and configured according to company's security and compliance requirements. For example pre-configured App Service Module can force that FTP state is disabled and HTTP 2.0 & HTTPS are always enabled.
  
# Deployment
- Open main.parameters.json and modify parameters
- Deploy Azure infrastructure with the command: 
```
az deployment sub create --location westeurope --template-file main.bicep --parameters main.parameters.json
```

## Used technologies

- Bicep

## Read more

- Blog posts
  - [How to model Azure infrastructure creation in complex environment with Bicep Modules?](https://www.kallemarjokorpi.fi/blog/how-to-model-azure-infra-creation-with-bicep.html)

