# Route 53 Hosted Zone (assuming you own the domain; otherwise, use an existing zone_id)
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Health Check for Primary CloudFront
resource "aws_route53_health_check" "primary" {
  fqdn               = aws_cloudfront_distribution.primary.domain_name
  port               = 443
  type               = "HTTPS"
  resource_path      = "/"  # Adjust to a health endpoint if needed
  failure_threshold  = 3
  request_interval   = 30
}

# Route 53 Failover Record - Primary
resource "aws_route53_record" "failover_primary" {
  zone_id         = aws_route53_zone.primary.zone_id
  name            = "data.${var.domain_name}"  # e.g., data.example.com
  type            = "A"
  set_identifier  = "primary"
  failover        = "PRIMARY"
  health_check_id = aws_route53_health_check.primary.id

  alias {
    name                   = aws_cloudfront_distribution.primary.domain_name
    zone_id                = aws_cloudfront_distribution.primary.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route 53 Failover Record - Secondary
resource "aws_route53_record" "failover_secondary" {
  zone_id        = aws_route53_zone.primary.zone_id
  name           = "data.${var.domain_name}"
  type           = "A"
  set_identifier = "secondary"
  failover       = "SECONDARY"

  alias {
    name                   = aws_cloudfront_distribution.secondary.domain_name
    zone_id                = aws_cloudfront_distribution.secondary.hosted_zone_id
    evaluate_target_health = false
  }
}