# Multi_regional_Data_Delivery_with_Failovers

Overview
This project sets up a multi-regional data delivery system using AWS S3, CloudFront, S3 Cross-Region Replication (CRR), Route 53 health checks, and failover routing. It provides high availability and low-latency content delivery with automatic failover from a primary region (us-east-1) to a secondary region (us-west-2).
Key Components:

S3 Buckets: Primary in us-east-1, secondary in us-west-2 with CRR enabled.
CloudFront Distributions: One for each S3 bucket for global CDN delivery.
Route 53: DNS routing with health checks on the primary; fails over to secondary if unhealthy.
Terraform: Infrastructure as Code (IaC) to deploy the setup.
SQL File: A basic example SQL script (e.g., for metadata tracking if integrating with a database like Athena or RDS).

This is a basic setup for static content delivery (e.g., files, images). Customize for production use.
Architecture

Upload data to primary S3 → Replicates to secondary S3.
Requests go to data.example.com via Route 53.
Route 53 checks primary CloudFront health; routes to primary if healthy, else secondary.
CloudFront caches and delivers content from the respective S3 bucket.


Usage

Deploy Infrastructure: Run the Terraform commands above.
Upload Data: Use AWS CLI or console to upload files to the primary S3 bucket (e.g., aws s3 cp file.txt s3://my-primary-data-bucket-unique/).
Access Data: Via the Route 53 alias (e.g., https://data.example.com/file.txt).
Test Failover: Simulate failure by making the primary health check fail (e.g., remove the root object or use AWS console to test).
SQL Example: The example.sql is a sample script for tracking deliveries. Upload to S3 and query via Athena if needed, or use with an RDS database.

To destroy: terraform destroy.
