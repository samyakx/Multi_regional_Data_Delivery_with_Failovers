# Primary CloudFront OAC
resource "aws_cloudfront_origin_access_control" "primary" {
  name                              = "primary-s3-oac"
  description                       = "OAC for primary S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Primary CloudFront Distribution
resource "aws_cloudfront_distribution" "primary" {
  origin {
    domain_name              = aws_s3_bucket.primary.bucket_regional_domain_name
    origin_id                = "primary-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.primary.id
  }

  enabled             = true
  default_root_object = "index.html"  # Adjust if needed

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "primary-s3"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Primary S3 Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.primary.arn}/*"
        Condition = {
          StringEquals = { "AWS:SourceArn" = aws_cloudfront_distribution.primary.arn }
        }
      }
    ]
  })
}

# Secondary CloudFront OAC
resource "aws_cloudfront_origin_access_control" "secondary" {
  name                              = "secondary-s3-oac"
  description                       = "OAC for secondary S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Secondary CloudFront Distribution
resource "aws_cloudfront_distribution" "secondary" {
  origin {
    domain_name              = aws_s3_bucket.secondary.bucket_regional_domain_name
    origin_id                = "secondary-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.secondary.id
  }

  enabled             = true
  default_root_object = "index.html"  # Adjust if needed

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "secondary-s3"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Secondary S3 Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.secondary.arn}/*"
        Condition = {
          StringEquals = { "AWS:SourceArn" = aws_cloudfront_distribution.secondary.arn }
        }
      }
    ]
  })
}