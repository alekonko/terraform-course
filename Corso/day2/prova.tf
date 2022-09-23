resource "google_compute_firewall" "foo" {
  name = "foo"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["80", "8080", "1000-2000"]
  }
}

variable "rules" {
  default = {
    icmp = null,
    tcp = ["80", "8080", "1000-2000"]
  }
}

resource "google_compute_firewall" "foo" {
  name = "my_rule"
    dynamic allow {
      for_each = var.rules
      iterator = rule
    content {
      protocol = rule.key
      ports = rule.value
    }
  }
}