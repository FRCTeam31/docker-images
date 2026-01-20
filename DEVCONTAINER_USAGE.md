# Using the roborio-cross-ubuntu Image with GitHub Codespaces

The `frcteam31/roborio-cross-ubuntu:2026` image is a complete FRC development environment with WPILib 2026 pre-installed.

## For GitHub Codespaces

To use this image in your FRC robot code repository:

1. Create a `.devcontainer` folder in your repository root
2. Create `.devcontainer/devcontainer.json` with the following content:

```json
{
  "name": "WPILib 2026 Development",
  "image": "frcteam31/roborio-cross-ubuntu:2026",
  
  "customizations": {
    "vscode": {
      "extensions": [
        "vscjava.vscode-java-pack",
        "redhat.java"
      ],
      "settings": {
        "java.home": "/usr/lib/jvm/java-17-openjdk-amd64",
        "wpilib.projectYear": "2026"
      }
    }
  },

  "remoteEnv": {
    "JAVA_HOME": "/usr/lib/jvm/java-17-openjdk-amd64",
    "WPILIB_HOME": "/opt/wpilib/2026"
  },

  "remoteUser": "root",
  
  "postCreateCommand": "bash -c 'mkdir -p ~/wpilib && ln -sf /opt/wpilib/2026 ~/wpilib/2026 && for vsix in /opt/wpilib/2026/vsCodeExtensions/*.vsix; do code --install-extension \"$vsix\" --force 2>/dev/null || true; done && echo \"WPILib 2026 environment ready!\"'"
}
```

The `postCreateCommand` automatically:
1. Creates the `~/wpilib` directory if needed
2. Creates a symlink from `~/wpilib/2026` to `/opt/wpilib/2026` (this is what makes the icons work!)
3. Installs all WPILib VS Code extensions
4. Confirms the environment is ready

3. Commit and push to your repository
4. Open your repository in GitHub Codespaces

## What's Included

- Ubuntu 24.04 LTS
- WPILib 2026.2.1 (installed at `/opt/wpilib/2026`)
- OpenJDK 17
- CMake (from Kitware PPA)
- Build tools (gcc, g++, make, etc.)
- Git (latest from PPA)
- Python 3 with pip
- All necessary libraries for FRC development
- WPILib VS Code extension (installed automatically via postCreateCommand)

## Using the WPILib Extension

The devcontainer configuration includes a `postCreateCommand` that automatically installs the WPILib extension from the installer. This gives you the same build, deploy, and simulation features as the desktop WPILib VS Code:

- Create new projects via Command Palette (`Ctrl+Shift+P` → "WPILib: Create a new project")
- Build robot code
- Deploy to robot
- Run robot simulation
- Access WPILib commands and tools

## Known Limitations

- **Hardware Access**: Deploying to a physical robot may have limitations depending on your network setup. You may need to be on the same network as the robot or use port forwarding.

## Environment Variables

- `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64`
- `WPILIB_HOME=/opt/wpilib/2026`

## User

The default user is `root`. You can create your own non-root user in your devcontainer configuration if needed.
