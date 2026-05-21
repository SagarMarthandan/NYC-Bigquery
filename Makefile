.PHONY: help init up down restart dbt-deps dbt-run dbt-test tf-init tf-plan tf-apply lint

help:
	@echo "Available commands:"
	@echo "  init         - Initialize local project setup (copy .env, build containers)"
	@echo "  up           - Start Airflow containers in the background"
	@echo "  down         - Tear down Airflow containers"
	@echo "  restart      - Restart Airflow services"
	@echo "  dbt-deps     - Install dbt package dependencies"
	@echo "  dbt-run      - Run all dbt models"
	@echo "  dbt-test     - Run dbt test suite"
	@echo "  tf-init      - Initialize Terraform in the terraform/ directory"
	@echo "  tf-plan      - Show Terraform execution plan"
	@echo "  tf-apply     - Apply Terraform changes to GCP"
	@echo "  lint         - Format Python code using black and lint with flake8"

init:
	cp airflow/.env.example airflow/.env
	docker-compose -f airflow/docker-compose.yml build

up:
	docker-compose -f airflow/docker-compose.yml up -d

down:
	docker-compose -f airflow/docker-compose.yml down

restart: down up

dbt-deps:
	cd dbt && dbt deps

dbt-run:
	cd dbt && dbt run --profiles-dir .

dbt-test:
	cd dbt && dbt test --profiles-dir .

tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan

tf-apply:
	cd terraform && terraform apply -auto-approve

lint:
	black airflow/dags/
	flake8 airflow/dags/
	cd dbt && sqlfluff lint models/
