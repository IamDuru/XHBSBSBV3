FROM nikolaik/python-nodejs:python3.10-nodejs19

# 1️⃣  Fix APT sources: swap buster → bullseye
RUN sed -i 's|buster|bullseye|g' /etc/apt/sources.list && \
    sed -i 's|buster/updates|bullseye-security|g' /etc/apt/sources.list

# 2️⃣  Install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        aria2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3️⃣  Copy code & install Python deps
COPY . /app
WORKDIR /app
RUN python -m pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

CMD ["python3", "-m", "DvisMusic"]
