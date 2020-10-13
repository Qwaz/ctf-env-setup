# To test: docker build .
FROM ubuntu:20.04
COPY . /app
RUN cd /app && ./setup.sh
