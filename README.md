# Docker Image for Adobe Campaign Classic
Purpose of this project is to allow Adobe Campaign developpers to work without requiring any infrastructure skills to install and configure Campaign. This repository contains Dockerfiles and sample scripts to build your own Docker images for Adobe Campaign Classic.

## Required files
This image will need you to download any required [Adobe Campaign Classic](https://www.adobe.com/marketing/campaign.html) commercial software before installation.
 - nlserver6-v7-[BUILD]-amd64_deb9.deb
 - setup-client-7.0.[BUILD].exe

Download Adobe Campaign Classic from [Adobe Software Portal](https://experience.adobe.com/#/downloads/content/software-distribution/en/campaign.html)

# Adobe Campaign Classic Standalone
## Architecture
This configuration includes all components on the same computer:
- application process (web),
- delivery process (mta),
- redirection process (tracking),
- workflow process and scheduled tasks (wfserver),
- bounce mail process (inMail),
- statistics process (stat).

Overall communication between the processes is carried out according to the following schema:

<img src="https://github.com/adobe/acc_docker/blob/master/images/standalone.png" width="600">

## Download Adobe Campaign Classic Client (for Windows)
[Download](http://localhost:8080/nl/jsp/setup-client-7.0.9346.exe)

## Campaign packages
Installed packages are: 
- Delivery
- CRM connectors
- Marketing campaigns (Campaign)
- Content Manager
- Integration with the Adobe Experience Cloud
- Adobe Experience Cloud Shared Audiences Integration
- Access to external data (Federated Data Access)
- AEM integration
- AMP for email
- Campaign Optimization
- Central/local Marketing (Distributed Marketing)
- Coupon management
- Deliverability monitoring (Email Deliverability)
- Offer engine (Interaction)
- Transactional message control (Message Center - Control)
- Mobile channel (SMS)
- Mobile App Channel
- Marketing resources (MRM)
- Marketing Analytics
- Direct Mail channel
- Telephone channel
- Response Manager
- Social networks (Social Marketing)
- Online surveys (Survey Manager)
- Web Analytics connectors 

To activate/deactivate default modules, enter into 'ACC_standalone/acc_install.sh' and edit package list (line 56)

## How to get this docker? 
Go to 'acc_standalone' directory and follow README instructions
