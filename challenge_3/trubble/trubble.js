import rateLimit from 'express-rate-limit'
import express from 'express'
import dotenv from 'dotenv'
import * as winston from 'winston';
import * as fs from 'fs';
import * as path from 'path';
import Pokedex from 'pokedex-promise-v2';

// Load configuration variables from .env file
const env = process.env.NODE_ENV || 'development'
if (env === 'development') {
    dotenv.config({ path: 'dev.env' });
} else {
    dotenv.config();
}

// setup the port

const port = process.env.PORT || 3000

// Create log directory if it doesn't exist
const logDirectory = './logs';
if (!fs.existsSync(logDirectory)) {
    fs.mkdirSync(logDirectory);
}

// Create Winston logger
const logger = winston.createLogger({
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.Console({
            colorize: true
        }),
        new winston.transports.File({
            filename: `${logDirectory}/app.log`,
            level: 'info'
        })
    ],
    exceptionHandlers: [
        new winston.transports.File({
            filename: `${logDirectory}/exceptions.log`
        })
    ],
    exitOnError: false
});


const app = express();

// Set up rate limiter
const limiter = rateLimit({
    windowMs: 1000, // 1 second
    max: 10, // limit each IP to 10 requests per windowMs
    handler: function (req, res, /*next*/) {
        // Log an error when rate limit exceeded
        logger.error('Rate limit exceeded for IP ' + req.ip);
        res.status(429).send('Too many requests');
    }
});

// Apply the rate limiter to all requests
app.use(limiter);

// Validate IMPORTANT_VALUE configuration variable
if (!process.env.IMPORTANT_VALUE) {
    logger.error('Config Error. The key IMPORTANT_VALUE is not set to true');
    logger.end();
    // give for logger to log
    setTimeout(function () {
        process.exit(1);
    }, 1000)
}

// Define route for homepage
app.get('/', (req, res) => {
    const P = new Pokedex();
    P.getPokemonsList()
        .then((response) => {
            const randomElement = response.results[Math.floor(Math.random() * response.results.length)];
            logger.info('Searching...')
            res.send(`Wild ${randomElement.name.toUpperCase()} appeared!`);
            logger.info(`${randomElement.name.toUpperCase()} seen`)
        })
        .catch((error) => {
            logger.error('There was an ERROR: ', error);
        });
});

// Start server
app.listen(port, () => {
    logger.info(`Running in Environment ${env}`);
    logger.info(`Server listening on port ${port}`);
});
