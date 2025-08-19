FROM nikolaik/python-nodejs:python3.10-nodejs19-bullseye

# 1. 修复 APT 源：用 bullseye 替换 buster
RUN set -eux; \
    sed -i 's|buster|bullseye|g' /etc/apt/sources.list; \
    sed -i 's|buster/updates|bullseye-security|g' /etc/apt/sources.list

# 2. 安装所需软件
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg aria2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. 复制代码并安装依赖
COPY . /app/
WORKDIR /app/
RUN python -m pip install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --upgrade --requirement requirements.txt

CMD ["python3", "-m", "DvisMusic"]
