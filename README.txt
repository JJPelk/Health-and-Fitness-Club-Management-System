# Health and Fitness Club Management System

## Overview
This Health and Fitness Club Management System is designed to cater to the needs of club members, trainers, and administrative staff. It provides functionalities for user registration, profile management, scheduling personal training sessions, registering for group fitness classes, and much more.

## Features
- **Member Functions:**
  - User Registration
  - Profile Management
  - Dashboard Display
  - Schedule Management for sessions and classes
- **Trainer Functions:**
  - Schedule Management
  - Member Profile Viewing
- **Administrative Staff Functions:**
  - Room Booking Management
  - Equipment Maintenance Monitoring
  - Class Schedule Updating
  - Billing and Payment Processing

## Installation

### Prerequisites
- Javascript
- Node.js
- npm

### Setup
1. Clone the repository to your local machine.

git clone https://github.com/JJPelk/Health-and-Fitness-Club-Management-System

2. Navigate to the cloned directory.

3. Install the required dependencies using npm

npm install 

4. Use the DDL and DML .sql files to generate the database by running them as queries

5. Customize the following code at the top of server.js to set up a connection to your newly created PostgreSQL database:
"// Set up PostgreSQL connection
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'A5',
  password: 'admin',
  port: 5432,
});"

## Usage
To run the application, navigate to the project directory and execute:

node server.js

## Video Demonstration:

https://www.youtube.com/watch?v=i6kic5RvcUo
