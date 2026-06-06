@echo off
REM Run ALL GitHub Actions workflows locally using act in sequence.
REM Secrets are loaded from .secrets (copy .secrets.example → .secrets and fill in values).
REM
REM To run a single workflow use the dedicated batch files:
REM   act_pr.bat          → on-pull-request.yml
REM   act_push_main.bat   → on-push-main.yml
REM   act_tag.bat         → on-tag.yml  (simulates a v1.0.0 tag push)

echo ============================================================
echo  Running: PR Check  (on-pull-request.yml)
echo ============================================================
act pull_request -W .github/workflows/on-pull-request.yml --secret-file .secrets

echo.
echo ============================================================
echo  Running: Push to Main  (on-push-main.yml)
echo ============================================================
act push -W .github/workflows/on-push-main.yml --secret-file .secrets

echo.
echo ============================================================
echo  Running: Create Release  (on-tag.yml)
echo ============================================================
act push -W .github/workflows/on-tag.yml --secret-file .secrets -e events/tag_push.json

echo.
echo ============================================================
echo  All workflows finished.
echo ============================================================
pause
