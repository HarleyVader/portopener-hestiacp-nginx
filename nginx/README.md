# Project Name

## Installation Documentation

### Prerequisites
- Python 3.x
- Node.js
- PM2 (Process Manager for Node.js)

### Installation Steps

1. **Clone the Repository**
    ```sh
    git clone https://github.com/HarleyVader/portopener-hestiacp-nginx
    cd portopener-hestiacp-nginx
    ```

2. **Install Node.js Dependencies**
    ```sh
    npm install
    ```

3. **Install PM2**
    ```sh
    npm install pm2 -g
    ```

4. **Set Up Python Environment**
    Ensure you have Python 3 installed. You can check this by running:
    ```sh
    python3 --version
    ```

5. **Run the Unified Setup Script**
    Execute the provided shell script to automate the setup process:
    ```sh
    ./setup.sh <user> <port> <location>
    ```

### Special Configurations

1. **Directory Structure**
    Ensure the following directory structure exists:
    ```
    /home/brandynette/web/bambisleep.chat/js-lmstudio-sdk/
    ```

2. **Permissions**
    Ensure the appropriate permissions are set for the directories and files:
    ```sh
    chown -R brandynette:brandynette /home/brandynette/web/bambisleep.chat/js-lmstudio-sdk
    chmod 777 /home/brandynette/web/bambisleep.chat/js-lmstudio-sdk/app.sock
    ```

3. **Environment Variables**
    Set any necessary environment variables for your application. You can create a `.env` file in the root of your project:
    ```sh
    touch .env
    ```

    Add your environment variables to the `.env` file:
    ```env
    NODE_ENV=production
    PORT=3000
    ```

This documentation should help you set up and configure your project correctly. If you encounter any issues, please refer to the specific error messages and adjust the steps accordingly.