# SubTrackIt
Welcome to SubTrackIt, a subscription tracker that prevents accidental renewals!

## Requirements
The following are required for the application to run:
* **The latest version of Xcode**  
* **XAMPP**  
Put the php server inside XAMPP > htdocs
* **Composer & Slim 4**  
The server uses Slim 4, a PHP micro framework, to provide a REST API. Composer is required for Slim 4 installation. Please follow the installation guide: https://www.slimframework.com/docs/v4/start/installation.html

## To run the app
### 1. Start the database  
Open up XAMPP, and start the Apache Web Server.
### 2. Start the server  
Open up your terminal, head into the v1 folder inside the php server, and start the server by executing `php -S [127.0.0.1:8080]`.
### 3. Start the app  
Open up Xcode, and run the application using a simulator. During development, iPhone 15 pro has been my default simulator.
