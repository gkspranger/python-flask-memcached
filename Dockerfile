FROM public.ecr.aws/docker/library/python:3.11.4-slim

ENV MEMCACHED_HOST="127.0.0.1"
ENV MEMCACHED_PORT="11211"
ENV APP_PORT="3000"

WORKDIR /myapp

COPY app/__main__.py /myapp/
COPY requirements.txt /myapp/

RUN pip install -r /myapp/requirements.txt

EXPOSE 3000/tcp

ENTRYPOINT ["python", "/myapp/"]
