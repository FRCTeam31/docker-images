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
        "wpilibsuite.vscode-wpilib",
        "vscjava.vscode-java-pack",
        "redhat.java"
      ],
      "settings": {
        "java.home": "/usr/lib/jvm/java-17-openjdk-amd64"
      }
    }
  },

  "remoteEnv": {
    "JAVA_HOME": "/usr/lib/jvm/java-17-openjdk-amd64",
    "WPILIB_HOME": "/opt/wpilib/2026"
  },

  "remoteUser": "root"
}
```

3. Commit and push to your repository
4. Open your repository in GitHub Codespaces

## What's Included

- Ubuntu 24.04 LTS
- WPILib 2026.2.1
- OpenJDK 17
- CMake (from Kitware PPA)
- Build tools (gcc, g++, make, etc.)
- Git (latest from PPA)
- Python 3 with pip
- All necessary libraries for FRC development

## Environment Variables

- `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64`
- `WPILIB_HOME=/opt/wpilib/2026`

## User

The default user is `root`. You can create your own non-root user in your devcontainer configuration if needed.
