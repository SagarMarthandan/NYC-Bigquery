output "gcs_bucket_url" {
  value       = google_storage_bucket.raw_data_bucket.url
  description = "The URL of the GCS bucket for raw taxi ingestion."
}

output "bigquery_raw_dataset_id" {
  value       = google_bigquery_dataset.raw_dataset.dataset_id
  description = "The dataset ID of the BigQuery raw ingestion layer."
}
