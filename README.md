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
-   **`docs/`**: Contains detailed documentation about the project (local development, CI/CD etc).
-   **`.github/`**: CI/CD workflows and other GitHub-related configurations.
-   **`docker-compose.yml`**: Defines the services for easy local development using Docker.

## Documentation

-   **CI/CD Setup**: [GitHub Actions Documentation](docs/github-actions.md)
-   **Local Development**: [Local Development Guide](docs/local-development.md)
-   **Monorepo Architecture**: [Monorepo Architecture Overview](docs/monorepo-architecture.md)
-   **Observability**: [Observability Guide](docs/observability.md)

## Contributing

Before getting started, please review our contributing guidelines.

-   **[CONTRIBUTING.md](CONTRIBUTING.md)**: Our main contribution guide, covering everything from reporting bugs to submitting pull requests.
-   **[CODEOWNERS](CODEOWNERS)**: This file lists the owners for different parts of the codebase, who will be automatically requested for review on pull requests.