resource "aws_route53_zone" "private_zone" {
  name =  "${var.cluster_name}.${var.cluster_domain}"
  vpc {
    vpc_id =  data.aws_vpc.cluster_vpc.id
  }
  force_destroy = "true"

  tags =  merge(
  var.default_tags,
  map(
    "Name",  "${var.cluster_name}.${var.cluster_domain}",
    "kubernetes.io/cluster/${var.cluster_name}", "owned"
    )
  )
}

resource "aws_route53_record" "api-int" {
  name = "api-int.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = ["replaceme"]
  ttl = 300
  }

resource "aws_route53_record" "api" {
  name = "api.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = ["replaceme"]
  ttl = 300
}

resource "aws_route53_record" "etcd_srv" {
  allow_overwrite = "true"
  name = "_etcd-server-ssl._tcp"
  type = "SRV"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = [
    "0 10 2380 etcd-0.${var.cluster_name}.${var.cluster_domain}",
    "0 10 2380 etcd-1.${var.cluster_name}.${var.cluster_domain}",
    "0 10 2380 etcd-2.${var.cluster_name}.${var.cluster_domain}"
    ]
  ttl = 300
}

resource "aws_route53_record" "wildcard-apps" {
  name = "*.apps.${aws_route53_zone.private_zone.name}"
  type = "CNAME"
  zone_id = aws_route53_zone.private_zone.zone_id
  records = ["replaceme"]
  ttl = 300
}

resource "aws_route53_record" "etcd-entries" {
  count = 3
  zone_id = aws_route53_zone.private_zone.id
  name    = "etcd-${count.index}.${aws_route53_zone.private_zone.name}"
  type    = "A"
  ttl     = "300"
  records = ["192.168.1.100"]
}

resource "aws_route53_record" "registry" {
zone_id = aws_route53_zone.private_zone.id
name    = "registry.${aws_route53_zone.private_zone.name}"
type    = "A"
ttl     = "300"
records = ["192.168.1.100"]
}