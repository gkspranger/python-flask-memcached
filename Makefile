.DEFAULT_GOAL := help

help:
	@echo "make r				remove local venv"
	@echo "make c				create venv and pip install defined modules"
	@echo "make f				format code"
	@echo "make l				lint code"
	@echo "make fl				format and lint code"
	@echo "make x				execute app"
	@echo "make b				build docker image"
	@echo "make xc				execute app, via container"

r:
	@rm -fr venv

c:
	@python -m venv venv
	@./venv/bin/python -m pip install --upgrade pip
	@./venv/bin/pip install -r requirements.txt

f:
	@./venv/bin/black app/

l:
	@./venv/bin/pylint app/

fl: f l

x:
	@./venv/bin/python app/

b:
	@docker image build -t gkspranger/flask-memcached-app:latest .

xc:
	@docker container run --rm -p 3000:3000 -e MEMCACHED_HOST=`hostname` gkspranger/flask-memcached-app
