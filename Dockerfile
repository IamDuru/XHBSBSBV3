# ---- Base ----
FROM nikolaik/python-nodejs:python3.10-nodejs19

# Debian 10 "buster" repos have moved to archive
RUN sed -i \
      -e 's|deb.debian.org|archive.debian.org|g' \
      -e 's|security.debian.org|archive.debian.org/|g' \
      /etc/apt/sources.list

# Install system deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        aria2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ---- App ----
WORKDIR /app
COPY requirements.txt .

# Upgrade pip & install Python deps
RUN python -m pip install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy rest of the source
COPY . .

# Heroku expects CMD to be an array
CMD ["python3", "-m", "DvisMusic"]
