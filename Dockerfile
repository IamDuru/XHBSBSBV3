FROM nikolaik/python-nodejs:python3.10-nodejs19

# 1. Fix broken APT sources (buster → bullseye)
RUN sed -ri \
    -e 's|deb.debian.org/debian buster|deb.debian.org/debian bullseye|g' \
    -e 's|security.debian.org buster/updates|security.debian.org bullseye-security|g' \
    /etc/apt/sources.list

# 2. Install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        aria2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Copy & install Python deps
COPY . /app
WORKDIR /app
RUN python -m pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

CMD ["python3", "-m", "DvisMusic"]
