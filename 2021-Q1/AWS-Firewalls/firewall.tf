resource "aws_networkfirewall_rule_group" "rule_group" {
  capacity = 1000
  name     = "${var.name}-firewall-rule-group"
  type     = "STATELESS"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              source {
                address_definition = "0.0.0.0/0"
              }
              destination {
                address_definition = aws_vpc.main.cidr_block
              }
              destination_port {
                from_port = 80
                to_port = 80
              }
              protocols = [6]
            }
          }
        }
        stateless_rule {
          priority = 2
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              source {
                address_definition = aws_vpc.main.cidr_block
              }
              source_port {
                from_port = 80
                to_port = 80
              }
              destination {
                address_definition = "0.0.0.0/0"
              }
              protocols = [6]
            }
          }
        }
        stateless_rule {
          priority = 3
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              source {
                address_definition = aws_vpc.main.cidr_block
              }
              destination {
                address_definition = "0.0.0.0/0"
              }
              destination_port {
                from_port = 80
                to_port = 443
              }
              protocols = [6]
            }
          }
        }
        stateless_rule {
          priority = 4
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              source {
                address_definition = "0.0.0.0/0"
              }
              source_port {
                from_port = 80
                to_port = 443
              }
              destination {
                address_definition = aws_vpc.main.cidr_block
              }
              protocols = [6]
            }
          }
        }
      }
    }
  }
  tags = merge({ Name = "fw-rg-${var.name}" }, var.tags)
}

resource "aws_networkfirewall_firewall_policy" "policy" {
  name = "${var.name}-firewall-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:drop"]
    stateless_fragment_default_actions = ["aws:drop"]
    stateless_rule_group_reference {
      priority     = 20
      resource_arn = aws_networkfirewall_rule_group.rule_group.arn
    }
  }

  tags = merge({ Name = "fw-policy-${var.name}" }, var.tags)
}

resource "aws_networkfirewall_firewall" "firewall" {
  name                = "${var.name}-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.policy.arn
  vpc_id              = aws_vpc.main.id
  subnet_mapping {
    subnet_id = aws_subnet.subnet["firewall"].id
  }

  tags = merge({ Name = "fw-${var.name}" }, var.tags)
}
