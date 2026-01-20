#!/bin/bash
set -e

# Fix Docker socket permissions - the socket from host may have different group
if [ -S /var/run/docker.sock ]; then
    # Make the socket accessible to the runner user
    sudo chmod 666 /var/run/docker.sock
fi

# Create .env file for the runner to pass variables to jobs
cat > /home/runner/actions-runner/.env << "EOF"
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
WPILIB_HOME=/opt/wpilib/2026
PATH=/usr/lib/jvm/java-17-openjdk-amd64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
EOF

echo "Created .env file with JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"

if [ -z "$RUNNER_TOKEN" ] || [ -z "$RUNNER_URL" ]; then
    echo "Error: RUNNER_TOKEN and RUNNER_URL environment variables must be set"
    exit 1
fi

# Remove old configuration if it exists
if [ -f ".runner" ]; then
    echo "Removing old runner configuration..."
    ./config.sh remove --token "$RUNNER_TOKEN" || true
    rm -f .runner .credentials .credentials_rsaparams
fi

# Configure the runner with retry logic
echo "Configuring GitHub Actions runner..."
MAX_RETRIES=5
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if ./config.sh --url "$RUNNER_URL" --token "$RUNNER_TOKEN" --name "${RUNNER_NAME:-roborio-runner-2026}" --work _work --labels "${RUNNER_LABELS:-roborio,wpilib,2026}" --unattended --replace; then
        echo "Runner configured successfully!"
        break
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo "Configuration failed. Retrying in 10 seconds... (Attempt $RETRY_COUNT/$MAX_RETRIES)"
            sleep 10
        else
            echo "Failed to configure runner after $MAX_RETRIES attempts."
            echo "Please check:"
            echo "  1. Your RUNNER_TOKEN is valid (tokens expire after 1 hour)"
            echo "  2. Your RUNNER_URL is correct"
            echo "  3. Your network connection to GitHub is working"
            exit 1
        fi
    fi
done

# Start the runner
echo "Starting GitHub Actions runner..."
echo "JAVA_HOME is set to: /usr/lib/jvm/java-17-openjdk-amd64"
./run.sh
