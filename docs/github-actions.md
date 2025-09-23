# GitHub Actions Workflows

This document provides documentation about the GitHub Actions CI/CD workflows for the  application.

### Architecture Components

- **Services**: Tether services
- **Multi-Platform Support**: Docker images built for `linux/amd64` and `linux/arm64` architectures

### Workflow Structure

```
.github/workflows/
├── build.yml             # Helper: Build Docker images
```

## Running Workflows Locally with `act`

You can run these workflows locally for testing and debugging using [act](https://github.com/nektos/act).

### Prerequisites

1. **Install Docker**: `act` uses Docker to execute workflows in a containerized environment
2. **Install `act`**: Follow the [official installation guide](https://github.com/nektos/act#installation)
3. **Register and GitHub Actions app to your repo**: [official docs](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app)

### Full System Testing

#### Complete System Validation

```bash
# Test main ci-cd workflow for app-node service
act workflow_dispatch \
 -W .github/workflows/ci-cd.yml \
 --input service_name=app-node \
 --secret-file .github/workflows/.secrets \
 --defaultbranch main

# Test main ci-cd workflow for all service
act workflow_dispatch \
 -W .github/workflows/ci-cd.yml \
 --input service_name=all \
 --secret-file .github/workflows/.secrets \
 --defaultbranch main
```

### Individual Helper Workflows

```bash
# Test main branch with build job
act workflow_dispatch \
  -W .github/workflows/build.yml \
  --input service_name=app-node \
  --secret-file .github/workflows/.secrets \
  --defaultbranch main

# Test dev branch  
act workflow_dispatch \
  -W .github/workflows/build.yml \
  --input service_name=tpl-wrk-thing \
  --secret-file .github/workflows/.secrets \
  --defaultbranch dev
```

## Basic Act CLI Commands

```bash
# List all available workflows
act --list

# Dry run to see execution plan
act workflow_dispatch --workflows .github/workflows/backend-fastapi-cicd.yml --dry-run

# Verbose output for debugging
act -W .github/workflows/backend-fastapi-cicd.yml --verbose --secret-file .github/workflows/.secrets
```

## Configuration

The [`.actrc`](./.actrc) file in the root of the project is pre-configured to use a Docker image that matches the GitHub Actions environment.

### Secrets Setup

Create a secrets file for testing:

```bash
# We need GitHub Actions credentials
cat > .github/workflows/.secrets << EOF
APP_ID=your-github-app-id
APP_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
your-private-key-content
-----END PRIVATE KEY-----"
EOF
```

**Important**: Add `.github/workflows/.secrets` to your `.gitignore` file.
