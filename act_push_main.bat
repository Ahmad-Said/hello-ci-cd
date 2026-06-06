@echo off
REM Run the Push-to-Main (test + deploy) workflow locally using act.
REM Secrets are loaded from .secrets (copy .secrets.example → .secrets and fill in values).
REM On GitHub, these must be set as repository secrets:
REM   Settings → Secrets and variables → Actions → New repository secret
REM   Required: APP_ENV, DEPLOY_API_KEY

act push -W .github/workflows/on-push-main.yml --secret-file .secrets
pause
