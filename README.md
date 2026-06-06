# GitHub CI/CD Tutorial with `act`

Welcome to the GitHub Actions CI/CD tutorial! This repository serves as a practical guide to understanding and building CI/CD pipelines using GitHub Actions, and how to test them locally using [`act`](https://github.com/nektos/act).

## What is CI/CD?

*   **Continuous Integration (CI):** The practice of automating the integration of code changes from multiple contributors into a single software project. It often involves running automated tests to ensure that the new code doesn't break existing functionality.
*   **Continuous Deployment/Delivery (CD):** The practice of automatically deploying the integrated code to production (or staging) environments.

## What is GitHub Actions?

GitHub Actions is a CI/CD platform that allows you to automate your build, test, and deployment pipeline right from GitHub. You create workflows that run based on specific events (like a push to a branch, a pull request, or a new release).

## What is `act`?

`act` is a command-line tool that lets you run your GitHub Actions locally. It uses Docker to spin up containers that mimic the GitHub Actions environment, allowing you to test and debug your workflows before committing and pushing them to GitHub.

## Project Structure

This repository contains a simple Python project with tests:

*   `src/math_ops.py`: A basic Python module with math functions.
*   `tests/test_math_ops.py`: Pytest unit tests for the math module.
*   `requirements.txt`: Python dependencies.
*   `.github/workflows/`: The directory containing our CI/CD pipelines.

## The Workflows

We have defined three different workflows to demonstrate various triggers:

### 1. Pull Request Pipeline (`.github/workflows/on-pull-request.yml`)
Runs whenever a Pull Request is opened or updated against the `main` branch.
*   **Purpose:** Ensures that proposed changes pass all tests before they can be merged.
*   **Steps:** Checkout code -> Setup Python -> Install Dependencies -> Run Pytest.

### 2. Push to Main Pipeline (`.github/workflows/on-push-main.yml`)
Runs whenever code is directly pushed or merged into the `main` branch.
*   **Purpose:** Simulates a continuous deployment scenario. It runs tests and then performs a simulated deployment.
*   **Steps:** Checkout code -> Setup Python -> Install Dependencies -> Run Pytest -> Simulate Deploy.

### 3. Release Pipeline (`.github/workflows/on-tag.yml`)
Runs whenever a new Git tag starting with `v` (e.g., `v1.0.0`) is pushed.
*   **Purpose:** Automates the creation of a release artifact.
*   **Steps:** Checkout code -> Setup Python -> Install Dependencies -> Run Pytest -> Package Application -> Simulate Release.

## How to Test Locally with `act`

### Prerequisites

1.  **Docker:** `act` requires Docker to run containers. Make sure Docker Desktop or Docker Engine is installed and running.
2.  **act:** Install `act` according to your OS.
    *   **macOS (Homebrew):** `brew install act`
    *   **Windows (Chocolatey):** `choco install act-cli`
    *   **Linux/curl:** `curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash`

### Running Workflows

Here are some examples of how to simulate different GitHub events locally using `act`.

**Note:** `act` might ask you to choose an image on your first run. The default `Micro` image is usually sufficient for simple python tasks.

#### Example 1: Simulate a Pull Request

To run the pipeline triggered by a pull request:

```bash
act pull_request
```
This will find the `on-pull-request.yml` workflow and execute it.

#### Example 2: Simulate a Push

By default, running `act` simulates a `push` event. Let's see what happens when we simulate pushing to the current branch (which we'll assume is `main`).

```bash
act push
```
Or just:
```bash
act
```
This will trigger the `on-push-main.yml` workflow.

#### Example 3: Simulate a Push of a Tag

To simulate creating a release tag (like `v1.0.0`), you can use the `--tag` argument:

```bash
act push --tag v1.0.0
```

#### Other Useful `act` Commands

*   **List all available actions:**
    ```bash
    act -l
    ```
*   **Run a specific job by its name (e.g., `test`):**
    ```bash
    act -j test
    ```
*   **Dry run (see what would happen without actually running the containers):**
    ```bash
    act -n
    ```

## Publishing to GitHub

Once you are satisfied with your local tests:
1. Initialize your git repository: `git init`
2. Add files: `git add .`
3. Commit: `git commit -m "Initial commit"`
4. Push to a GitHub repository. 

GitHub will automatically detect the `.github/workflows` directory and start running the actions on their servers!
