# Use an official Python runtime as the base image (based on Debian Bullseye)
FROM python:3.10-slim-bullseye

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Node.js, npm, Yarn, ffmpeg, aria2, and other dependencies
# Using NodeSource setup script for Node.js 19.x (as your original image had Node 19)
# Note: Node 19 is EOL, consider upgrading to LTS (e.g., 18 or 20) if possible.
RUN apt-get update && \
    # Install common build tools and libraries needed for Python packages
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        ffmpeg \
        aria2 && \
    # Add NodeSource repository for Node.js 19.x
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repgpkey.asc | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_19.x bullseye main" > /etc/apt/sources.list.d/nodesource.list && \
    # Add Yarn repository
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarnkey.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list && \
    # Update package list again to include new repos
    apt-get update && \
    # Install Node.js and Yarn
    apt-get install -y --no-install-recommends nodejs yarn && \
    # Clean up apt cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Copy application code
COPY . /app/
WORKDIR /app/

# Upgrade pip and install Python dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade --requirement requirements.txt

# Define the command to run your application
CMD python -m DvisMusic
