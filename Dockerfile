FROM ubuntu:18.04
COPY . /app
RUN cd /app && ./setup.sh
