-- BigQuery Standard SQL
-- Replace your-gcp-project-id with your Google Cloud project id.

CREATE SCHEMA IF NOT EXISTS `your-gcp-project-id.thelook_portfolio`
OPTIONS (
  location = 'US',
  description = 'Portfolio marts for TheLook growth and retention analysis'
);

-- Materialize a personal copy of all seven source tables.
-- This is the BigQuery equivalent of loading the dataset into your analytical storage.
CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.users` AS
SELECT * FROM `bigquery-public-data.thelook_ecommerce.users`;

CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.orders` AS
SELECT * FROM `bigquery-public-data.thelook_ecommerce.orders`;

CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.order_items` AS
SELECT * FROM `bigquery-public-data.thelook_ecommerce.order_items`;

CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.products` AS
SELECT * FROM `bigquery-public-data.thelook_ecommerce.products`;

CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.events` AS
SELECT * FROM `bigquery-public-data.thelook_ecommerce.events`;

CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.inventory_items` AS
SELECT * FROM `bigquery-public-data.thelook_ecommerce.inventory_items`;

CREATE OR REPLACE TABLE `your-gcp-project-id.thelook_portfolio.distribution_centers` AS
SELECT * FROM `bigquery-public-data.thelook_ecommerce.distribution_centers`;

-- Inspect the loaded tables.
SELECT
  table_name,
  row_count,
  size_bytes,
  TIMESTAMP_MILLIS(last_modified_time) AS last_modified_at
FROM `your-gcp-project-id.thelook_portfolio.__TABLES__`
ORDER BY table_name;
