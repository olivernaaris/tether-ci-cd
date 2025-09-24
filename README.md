# Tether CI/CD Project

This repository contains the services and workers for the Tether project, managed as a monorepo.

## Project Structure

The repository is organized into the following key components:

-   **`services/`**: Contains the core microservices.
    -   `app-node`: The main application service that handles user-facing API requests.
    -   `wrk-ork`: The orchestrator worker that manages and coordinates other workers.
    -   `wrk-book`: A worker service responsible for managing book-related tasks.
-   **`packages/`**: Shared Node.js packages and templates used by the services.
    -   `wrk-base`: A base configuration for workers.
    -   `tpl-wrk-thing`: A template for creating new workers.
-   **`docs/`**: Contains detailed documentation for local development and CI/CD.
-   **`.github/`**: CI/CD workflows and other GitHub-related configurations.
-   **`docker-compose.yml`**: Defines the services for easy local development using Docker.

## Getting Started

For a quick setup, you can use Docker to build and run the services.

For detailed manual setup and configuration of each service, please refer to the [SETUP.md](SETUP.md) guide.

## Documentation

-   **CI/CD Setup**: [GitHub Actions Documentation](docs/github-actions.md)
-   **Local Development**: [Local Development Guide](docs/local-development.md)