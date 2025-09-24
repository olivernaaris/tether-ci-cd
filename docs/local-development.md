# Local Development Guide

This guide provides simple and straightforward instructions to build, test, and run the project on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:
- [nvm (Node Version Manager)](https://github.com/nvm-sh/nvm)
- [Docker](https://www.docker.com/get-started) and Docker Compose

## 1. Installation

First, set up the correct Node.js version using nvm. From the root directory, run:

```bash
nvm install
# or `nvm use` if you already have the version installed
```

This command reads the `.nvmrc` file at the root of the project to use the correct Node.js version.

Next, install the project dependencies:

```bash
npm install
```

## 2. Building the Project

Build all the services and packages in the monorepo using Turbo:

```bash
npm run build
```

## 3. Running the Services

To run all services (`app-node`, `wrk-book`, `wrk-ork`) together, use Docker Compose. This command will build the Docker images and start the containers.

```bash
docker compose up --build
```

The `app-node` service will be available at [http://localhost:3000](http://localhost:3000).

### Running Individual Services

If you only need to run a specific service, you can do so with the following commands:

```bash
# Run only the main application
docker compose up --build app-node

# Run only the book worker
docker compose up --build wrk-book

# Run only the orchestrator worker
docker compose up --build wrk-ork
```

## 4. Linting the Code

To check the code for linting errors across the entire project, run:

```bash
npm run lint
```

## 5. Troubleshooting

There are two primary ways to troubleshoot services running in Docker.

### Attaching to a Running Container

If your services are already running (from `docker compose up`), you can get a shell inside a specific container using `exec`:

```bash
# Shell into the running app-node container
docker compose exec app-node bash

# Shell into the running wrk-book container
docker compose exec wrk-book bash

# Shell into the running wrk-ork container
docker compose exec wrk-ork bash
```

### Running a One-off Command in a New Container

If you want to run a command in a fresh container, for example, to run a test or a script without affecting your running services, use `run`. This is also useful if the container fails to start and you need to debug the environment.

```bash
# Execute bash in a new app-node container for troubleshooting
docker compose run --rm --build app-node bash

# Execute bash in a new wrk-ork container
docker compose run --rm --build wrk-ork bash

# Execute bash in a new wrk-book container
docker compose run --rm --build wrk-book bash
```