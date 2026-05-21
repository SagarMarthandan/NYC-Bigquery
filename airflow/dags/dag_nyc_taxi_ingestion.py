from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.operators.empty import EmptyOperator

default_args = {
    "owner": "Sagar Marthandan",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    "nyc_taxi_pipeline",
    default_args=default_args,
    description="Orchestrator for NYC Taxi Data Ingestion and Transformation",
    schedule_interval="@monthly",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["nyc-taxi", "airbyte", "dbt", "bigquery"],
) as dag:

    start_pipeline = EmptyOperator(task_id="start_pipeline")

    # Airflow task triggers API ingestion / Airbyte sync for the monthly NYC Taxi dataset
    trigger_airbyte_sync = BashOperator(
        task_id="trigger_airbyte_sync",
        bash_command="echo 'Triggering Airbyte connection sync via API...'",
    )

    # In a real environment, you'd run a task to verify load or run additional validations
    verify_bq_raw_load = BashOperator(
        task_id="verify_bq_raw_load",
        bash_command="echo 'Verifying BigQuery raw schema and row counts...'",
    )

    # Trigger dbt models runs
    run_dbt_models = BashOperator(
        task_id="run_dbt_models",
        bash_command="cd /opt/airflow/dbt && dbt run --profiles-dir .",
    )

    # Trigger dbt tests to enforce data quality rules
    test_dbt_models = BashOperator(
        task_id="test_dbt_models",
        bash_command="cd /opt/airflow/dbt && dbt test --profiles-dir .",
    )

    end_pipeline = EmptyOperator(task_id="end_pipeline")

    # Task dependency graph
    start_pipeline >> trigger_airbyte_sync >> verify_bq_raw_load >> run_dbt_models >> test_dbt_models >> end_pipeline
