# GitHub Actions Workflows

This document provides documentation about the GitHub Actions CI/CD workflows for the  application.

### Architecture Components

- **Services**: Tether services mono repo
- **Multi-Platform Support**: Docker images built for `linux/amd64` and `linux/arm64` architectures
- **Local testing**: You can run these workflows locally on your machine for testing and debugging using [act](https://github.com/nektos/act).
- **Local build only**: As we don't want to spend money on Container Registry, we only do local builds and don't push the images anywhere.
- **Reusable workflows**: Use separate jobs for building, testing and triggering.

### Workflow Structure

```
.github/workflows/
├── helper-build.yml      # Helper: Build Docker images
├── helper-test.yml       # Helper: Run tests
├── helper-summary.yml    # Helper: Print out Service name, Docker image tag  
├── app-node.yml          # Run app-node CI/CD pipeline
├── wrk-book.yml          # Run wrk-book CI/CD pipeline
├── wrk-ork.yml           # Run wrk-ork CI/CD pipeline
├── .actrc                # File to define extra parameters for running act
```

### Prerequisites

1. **Install Docker**: `act` uses Docker to execute workflows in a containerized environment
2. **Install `act`**: Follow the [official installation guide](https://github.com/nektos/act#installation)
3. **Register and add and GitHub Actions app to your repo (used for giving access to GitHub API access)**: [official docs](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app)
4. **Local GitHub Actions App secret key**: Add App ID and private key added to .secrets folder in .github/workflows directory. See Secrets Setup example.
5. **Cloud GitHub Actions App secret**: Add App ID and private key to GitHub Repository secrets 

## Basic Act CLI Commands

```bash
# List all available workflows
act --list

# Dry run to see execution plan
act workflow_dispatch --workflows .github/workflows/app-node.yml --dry-run

# Verbose output for debugging
act -W .github/workflows/app-node.yml --verbose --secret-file .github/workflows/.secrets
```

## Configuration

The [`.actrc`](./.actrc) file in the root of the project is pre-configured to use a Docker image that matches the GitHub Actions environment. It also defines no checkout from GitHub, don't download if image exist already.

### Secrets Setup

Create a secrets file for local testing:
**Important**: Add `.github/workflows/.secrets` to your `.gitignore` file.

```bash
# We need GitHub Actions credentials
# Use GitHub Actions App secret key and app id
# Follow the guide shown in the Prerequisites step to do setup
cat > .github/workflows/.secrets << EOF
APP_ID=your-github-app-id
APP_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
your-private-key-content
-----END PRIVATE KEY-----"
EOF
```

## CI/CD testing

### Locally run end-to-end CI/CD flow(s)
Each service has it's own individual file to run end-to-end CI/CD workflow

```bash
# Test ci-cd workflow for app-node service using main branch
act workflow_dispatch \
 -W .github/workflows/app-node.yml \
 --secret-file .github/workflows/.secrets \
 --env GITHUB_REF=refs/heads/main

# Test ci-cd workflow for app-node service using dev branch
act workflow_dispatch \
 -W .github/workflows/app-node.yml \
 --secret-file .github/workflows/.secrets \
 --env GITHUB_REF=refs/heads/dev

# Test ci-cd workflow for app-node service using test branch
act workflow_dispatch \
 -W .github/workflows/app-node.yml \
 --secret-file .github/workflows/.secrets \
 --env GITHUB_REF=refs/heads/test
```

### Individual CI/CD Helper Workflows testing

```bash
# Test main branch with build job
 act workflow_dispatch \
  -W .github/workflows/helper-build.yml \
  --input service_name=app-node \
  --secret-file .github/workflows/.secrets \
  --env GITHUB_REF=refs/heads/main

# Test main branch with test job
act workflow_dispatch \
  -W .github/workflows/helper-tests.yml \
  --input service_name=app-node \
  --secret-file .github/workflows/.secrets \
  --env GITHUB_REF=refs/heads/main
```
