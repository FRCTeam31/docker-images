# roborio-cross-ubuntu-shrunner

Self-hosted GitHub Actions runner with WPILib 2026 and Docker support.

## Features

- Based on `frcteam31/roborio-cross-ubuntu:2026`
- GitHub Actions runner pre-installed
- Docker installed for building Docker images in CI
- Automatic runner configuration and startup
- Persistent runner configuration

## Quick Start

### Using Docker Compose (Recommended)

1. Edit `docker-compose.yml` and set your values:
   - `RUNNER_URL`: Your repository or organization URL (e.g., `https://github.com/FRCTeam31/robot-code`)
   - `RUNNER_TOKEN`: Generate this from your repo Settings → Actions → Runners → New self-hosted runner

2. Start the runner:
   ```bash
   docker-compose up -d
   ```

3. Check logs:
   ```bash
   docker-compose logs -f
   ```

### Using Docker Run

```bash
docker run -d \
  --name roborio-runner-2026 \
  --restart unless-stopped \
  -e RUNNER_URL="https://github.com/YourOrg/YourRepo" \
  -e RUNNER_TOKEN="your-token-here" \
  -e RUNNER_NAME="roborio-runner-2026" \
  -e RUNNER_LABELS="roborio,wpilib,2026,self-hosted" \
  -v runner-config:/home/runner/actions-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  frcteam31/roborio-cross-ubuntu-shrunner:2026
```

## Important Notes

### Docker Socket Mount
The runner needs access to the Docker socket (`/var/run/docker.sock`) to build Docker images. This is mounted in the docker-compose.yml file.

### Runner Token Expiration
GitHub runner tokens expire after 1 hour. If you see configuration errors:
1. Generate a new token from your repository settings
2. Update the `RUNNER_TOKEN` environment variable
3. Restart the container

### Persisting Configuration
The runner configuration is stored in a Docker volume (`runner-config`). This persists across container restarts.

## Environment Variables

- `RUNNER_URL` (required): Repository or organization URL
- `RUNNER_TOKEN` (required): Registration token from GitHub
- `RUNNER_NAME` (optional): Name for this runner (default: `roborio-runner-2026`)
- `RUNNER_LABELS` (optional): Comma-separated labels (default: `roborio,wpilib,2026,self-hosted`)

## What's Included

- Everything from `roborio-cross-ubuntu:2026`:
  - WPILib 2026.2.1
  - OpenJDK 17
  - Build tools (gcc, g++, cmake, git, etc.)
  - Python 3
- GitHub Actions runner (v2.330.0)
- Docker CE (for building images in CI)
- Non-root `runner` user with sudo access

## Troubleshooting

### "Error: RUNNER_TOKEN and RUNNER_URL environment variables must be set"
Make sure you've set both environment variables when starting the container.

### "Failed to configure runner after 5 attempts"
Your runner token may have expired. Generate a new one and restart the container.

### Docker commands fail with permission errors
Ensure `/var/run/docker.sock` is mounted and the runner user is in the `docker` group (this is done automatically in the Dockerfile).
