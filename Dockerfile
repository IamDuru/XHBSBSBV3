# Use an official Node.js image based on a supported OS
FROM node:19-bullseye

# Install Python, pip, ffmpeg, and aria2
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        ffmpeg \
        aria2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Optional: Create a symlink if your scripts use `python` and `pip`
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# Install Yarn globally via npm (Node.js image usually includes npm)
# The base image might already have yarn, but this ensures it's present.
RUN npm install -g yarn

COPY . /app/
WORKDIR /app/

# Upgrade pip and install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt

CMD python3 -m DvisMusic
