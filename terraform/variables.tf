variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID where resources will be provisioned."
  default     = "ny-taxi-pipeline-2025"
}

variable "gcp_region" {
  type        = string
  description = "The GCP geographic region for datasets and buckets."
  default     = "US"
}

variable "gcs_bucket_name" {
  type        = string
  description = "Unique name for the GCS raw landing zone bucket."
  default     = "ny-taxi-raw-2025"
}

variable "bq_raw_dataset_id" {
  type        = string
  description = "BigQuery dataset ID for raw data."
  default     = "raw_nyc_taxi"
}

variable "bq_marts_dataset_id" {
  type        = string
  description = "BigQuery dataset ID for production aggregate marts."
  default     = "mart_nyc_taxi"
}
