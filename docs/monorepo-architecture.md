# Monorepo Architecture Overview

This document provides a concise overview of the monorepo setup, explaining how **npm Workspaces** and **Turborepo** are used to manage the project's architecture and development workflows.

## Core Components

The architecture is built on two key technologies:

1.  **npm Workspaces**: For managing multiple packages and services within a single repository.
2.  **Turborepo**: A high-performance build system for orchestrating tasks across the workspaces.

---

### 1. npm Workspaces

The foundation of the monorepo is defined in the root [`package.json`](../package.json). npm Workspaces allow us to manage dependencies and link local packages together seamlessly.

#### Workspace Structure

The `workspaces` configuration in [`package.json`](../package.json) specifies which directories are part of the monorepo:

```json
"workspaces": [
  "services/*",
  "packages/*"
]
```

-   **`services/`**: This directory contains all the runnable applications or microservices. Each service is its own self-contained project.
-   **`packages/`**: This directory holds shared code, utilities, configurations, or libraries that can be consumed by the different services.

#### Root Scripts

The root [`package.json`](../package.json) also defines top-level scripts that operate across all workspaces:

```json
"scripts": {
  "build": "turbo run build",
  "lint": "turbo run lint",
  "test": "turbo run test",
  "dev": "turbo run dev --parallel"
}
```

These scripts delegate all task execution to Turborepo, ensuring that tasks are run efficiently and in the correct order.
The script references should also exist in child packages and services package.json file.

---

### 2. Turborepo Task Orchestration

Turborepo is the build system that orchestrates how tasks are executed. Its configuration is defined in [`turbo.json`](../turbo.json).

#### Task Pipeline

The `tasks` object in [`turbo.json`](../turbo.json) defines the dependency graph and caching behavior for our scripts.

```json
{
  "$schema": "https://turborepo.org/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"]
    },
    "lint": {},
    "test": {
      "dependsOn": ["^build"]
    }
  }
}
```

-   **`build`**:
    -   `"dependsOn": ["^build"]`: The `^` symbol means that before running the `build` script for any given workspace, Turborepo must first run the `build` script for all of its internal dependencies. This ensures that packages are built in the correct topological order.

-   **`test`**:
    -   `"dependsOn": ["^build"]`: This ensures that all necessary code is built before any tests are run, preventing tests from failing due to stale code.

-   **`lint`**:
    -   This task has no dependencies, meaning it can be run at any time without needing other tasks to complete first.

## How It All Works Together

1.  A developer runs a command at the root of the project, such as `npm run build`.
2.  npm invokes the corresponding script: `turbo run build`.
3.  Turborepo reads the `turbo.json` configuration and analyzes the dependency graph between all the workspaces defined in `package.json`.
4.  It executes the `build` task for each workspace in the correct order, respecting the `dependsOn` dependencies.
5.  Turborepo caches the output of each task. On subsequent runs, if a workspace's code has not changed, Turborepo will restore the cached output instead of re-running the task, leading to significantly faster builds.

This setup provides a scalable and efficient way to manage a complex codebase, ensuring that development workflows are fast, reliable, and easy to manage.

For detailed instructions on how to build and run the project, please see the [Local Development Guide](local-development.md).