locals {
  contact = {
    address_line_1    = "Laerholzstraße 17"
    city              = "Bochum"
    contact_type      = "PERSON"
    country_code      = "DE"
    email             = "kosokolovsky@icloud.com"
    first_name        = "Konstantin"
    last_name         = "Sokolovskiy"
    phone_number      = "+49.1743466489"
    state             = "NRW"
    zip_code          = "44799"
  }
}

# resource "aws_route53domains_domain" "main" {
#   domain_name = var.domain_name
#   auto_renew  = true

#   admin_privacy      = true
#   registrant_privacy = true
#   tech_privacy       = true

#   admin_contact {
#     address_line_1    = local.contact.address_line_1
#     city              = local.contact.city
#     contact_type      = local.contact.contact_type
#     country_code      = local.contact.country_code
#     email             = local.contact.email
#     first_name        = local.contact.first_name
#     last_name         = local.contact.last_name
#     phone_number      = local.contact.phone_number
#     state             = local.contact.state
#     zip_code          = local.contact.zip_code
#   }

#   registrant_contact {
#     address_line_1    = local.contact.address_line_1
#     city              = local.contact.city
#     contact_type      = local.contact.contact_type
#     country_code      = local.contact.country_code
#     email             = local.contact.email
#     first_name        = local.contact.first_name
#     last_name         = local.contact.last_name
#     phone_number      = local.contact.phone_number
#     state             = local.contact.state
#     zip_code          = local.contact.zip_code
#   }

#   tech_contact {
#     address_line_1    = local.contact.address_line_1
#     city              = local.contact.city
#     contact_type      = local.contact.contact_type
#     country_code      = local.contact.country_code
#     email             = local.contact.email
#     first_name        = local.contact.first_name
#     last_name         = local.contact.last_name
#     phone_number      = local.contact.phone_number
#     state             = local.contact.state
#     zip_code          = local.contact.zip_code
#   }
# }

# resource "aws_route53_zone" "main" {
#   name = var.domain_name
# }

# resource "aws_route53_record" "a_record" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = var.domain_name
#   type    = "A"
#   ttl     = 300
#   records = ["3.67.163.253"]
# }