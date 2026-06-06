@echo off
REM Run the Create Release (tag push) workflow locally using act.
REM Secrets are loaded from .secrets (copy .secrets.example → .secrets and fill in values).
REM On GitHub, these must be set as repository secrets:
REM   Settings → Secrets and variables → Actions → New repository secret
REM   Required: APP_ENV, RELEASE_TOKEN
REM
REM The events\tag_push.json file simulates a v1.0.0 tag push event.
REM Edit that file to change the simulated tag name.

act push -W .github/workflows/on-tag.yml --secret-file .secrets -e events/tag_push.json
pause
