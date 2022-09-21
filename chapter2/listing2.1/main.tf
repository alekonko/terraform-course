terraform {
  required_version = ">= 0.15"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "literature" {
  filename = "art_of_war.txt"
  content     = <<-EOT
    Sun Tzu said: The art of war is of vital importance to the State.

    It is a matter of life and death, a road either to safety or to 
    ruin. Hence it is a subject of inquiry which can on no account be
    neglected.
  EOT
}

output "filename" {
  value = local_file.literature.filename
}

output "content" {
  value = local_file.literature.content
}


# value in random_string.random.result
resource "random_string" "random" {
  length = 12
  number = false
  upper = false
  special = false
}

# value in random_pet.random.id
resource "random_pet" "random" {
  length = 2
  separator = "-"
}

output "mypet" {
  value = random_pet.random
}

# resource "local_file" "the_lord_of_rings2" {
#     filename = "tolkien2.txt"
#     content = "time: ${timestamp()}\n"
# }