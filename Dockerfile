FROM nikolaik/python-nodejs:python3.10-nodejs19

# Point apt to the archived buster repositories
RUN sed -i \
  -e 's|deb.debian.org|archive.debian.org|g' \
  -e 's|security.debian.org|archive.debian.org/|g' \
  /etc/apt/sources.list

# Now install packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg aria2 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app/

RUN python -m pip install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --upgrade -r requirements.txt

CMD ["python3", "-m", "DvisMusic"]
