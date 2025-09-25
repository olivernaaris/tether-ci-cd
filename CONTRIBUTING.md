# Contributing

## How to Make Changes

All changes should be done via pull requests. No direct pushes to `main` or `dev` branches are allowed.

1.  **Fork the repository** and create your branch from `main`.
2.  **Name your branch** using the convention described below.
3.  **Make your changes**.
4.  **Ensure your changes are well-tested**.
5.  **Create a pull request** against the `dev` branch.
6.  **Wait for a review**.

## Branch Naming Convention

Please use the following format for your branch names:

`<type>/<short-description>`

-   **type**: `feature`, `fix`, `chore`, `docs`
-   **short-description**: A brief, hyphenated description of the change.

**Examples:**

-   `feature/user-authentication`
-   `fix/login-button-bug`
-   `docs/update-contributing-guide`

## Versioning and Docker Builds

Our versioning and Docker image tagging are based on the branch being built.

-   **main branch**: Builds from the `main` branch are considered stable releases and are pushed as the `latest` Docker image.
-   **dev branch**: Builds from the `dev` branch are considered development builds and are tagged and pushed as `development` builds.
-   **Other branches**: Any other branch will be tagged with the branch name.

## CI/CD Pipeline

We have pipelines that run tests and build the image on each push. This ensures that all changes are automatically tested and that a Docker image is available for every change.

## Best Practices

-   Write clean, readable, and maintainable code.
-   Keep your pull requests small and focused on a single issue or feature.
-   Provide a clear and descriptive title and description for your pull requests.
