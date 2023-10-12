# Define your custom domain in Route 53
resource "aws_route53_record" "test_dns" {
  zone_id = "Z0305038G8KK5LHB4FJJ"
  name    = "devtest.hereonline.co.uk"
  type    = "A"

  alias {
    #name                   = aws_cloudfront_distribution.website_distribution.domain_name
    #zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    name    =   aws_s3_bucket.devops_challenge.website_endpoint
    zone_id = aws_s3_bucket.devops_challenge.hosted_zone_id

    evaluate_target_health = false
  }
}
