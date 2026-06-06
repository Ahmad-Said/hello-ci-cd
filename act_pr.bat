@echo off
REM Run the PR Check workflow locally using act.
REM Secrets are loaded from .secrets (copy .secrets.example → .secrets and fill in values).
REM On GitHub, these must be set as repository secrets:
REM   Settings → Secrets and variables → Actions → New repository secret

act pull_request -W .github/workflows/on-pull-request.yml --secret-file .secrets
pause
