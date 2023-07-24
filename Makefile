.DEFAULT_GOAL := help

help:
	@echo "make r				remove local venv"
	@echo "make c				create venv and pip install defined modules"
	@echo "make f				format code"
	@echo "make l				lint code"
	@echo "make fl				format and lint code"
	@echo "make x				execute app"

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
