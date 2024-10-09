const pm2 = require('pm2');

const appName = 'setup.sh'; // Replace with your app name
const scriptPath = 'nodejs6969.sh'; // Replace with the path to your script

pm2.connect((err) => {
    if (err) {
        console.error(err);
        process.exit(2);
    }

    pm2.start({
        script: scriptPath,
        name: appName,
        interpreter: '/bin/bash', // Use bash as the interpreter
    }, (err, apps) => {
        pm2.disconnect(); // Disconnects from PM2
        if (err) throw err;

        console.log(`App ${appName} has been started and registered with PM2.`);
    });
});