# Docker Laravel Automated Setup

This repository provides a fast and efficient solution for setting up a Laravel development environment using Docker. The goal is to automate the entire container creation and configuration process, allowing you to get started with your Laravel project without worrying about manual environment setup.

# Video Demonstration

Watch the following video to see the full process of setting up the project:

- [Watch the demo on YouTube](https://www.youtube.com/watch?v=nrSqmeHyKQs)

## Features

- Automated Docker setup for PHP, Nginx, MySQL, and Redis.
- Self-signed SSL certificates for local development.
- Queue configuration with `php artisan queue:work`.
- Easy to customize and adapt for other Laravel projects.

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker
- Docker Compose

## Getting Started

To get started with this project, follow these steps:

1. Clone this repository:

   ```bash
   git clone https://github.com/wallacemartinss/laravel-docker-automated-setup
   cd docker-laravel-automated-setup
   ```

2. Copy the .env.example file to .env

   ```bash
   cp .env.example .env
   ```

3. Open the .env file and configure the following variables:

   ```bash

   APP_NAME="your Application name"
   DB_DATABASE=your_database_name
   DB_USERNAME=your_database_username
   DB_PASSWORD=your_database_password

   ```

4. Give execution permission to the start.sh script:

   ```bash
   chmod +x start.sh
   ```

5. Run the start.sh script to bring up the containers and laravel:

   ```bash
   ./start.sh
   ```

6. To start developing the application, access the app container with the following command:

   ```bash
   docker compose exec app bash
   ```

## This will set up the following services:

app: PHP-FPM with Laravel
nginx: Web server (with SSL enabled)
mysql: MySQL database
redis: Redis caching service
mailpit: Local mail server for development

## Customization

You can easily customize the Docker and Nginx configuration to fit your needs. Here's what you can modify:

Dockerfile: Modify to install additional PHP extensions or tools.
nginx/default.conf: Adjust server settings and routes.
.env: Change environment variables for your Laravel project (e.g., database credentials, Redis settings).

## Contributing

Feel free to contribute by submitting issues or pull requests. If you have suggestions or improvements, they are always welcome!
