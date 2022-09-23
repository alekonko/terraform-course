variable "words" {
  description = "le mie parole da usare nel generatore"
  type = object({
    nouns         = list(string),
    adjectives    = list(string),
    verbs         = list(string),
    adverbs       = list(string),
    numbers       = list(number),
  })

  validation {
    condition = length(var.words["nouns"]) >= 20
    error_message = "Occcorrono almeno 20 parole."
  }
}

variable "num_files" {
  type = number
  default = 100
}