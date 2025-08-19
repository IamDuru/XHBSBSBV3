FROM python:3.10-slim-bullseye

# Install Node.js 19
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    curl -fsSL https://deb.nodesource.com/setup_19.x | bash - && \
    apt-get install -y nodejs

# Install other dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg aria2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app/

RUN python -m pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

CMD python3 -m DvisMusic
