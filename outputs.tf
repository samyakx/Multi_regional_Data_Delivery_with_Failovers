output "primary_cloudfront_domain" {
  value = aws_cloudfront_distribution.primary.domain_name
}

output "secondary_cloudfront_domain" {
  value = aws_cloudfront_distribution.secondary.domain_name
}

output "route53_name_servers" {
  value = aws_route53_zone.primary.name_servers
}