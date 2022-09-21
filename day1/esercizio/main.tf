# primo esempio: creo una mappa di liste come db. prendo i random, poi genero dei file dal template (file alice.txt) usando i valori generati
# es input = var.words["nouns"]
# secondo: creo usando iteratori, una nuova mappa random ma metterndo uppercase le stringhe
# uso input = local.uppercase_words["nouns"]
# terzo: metto tante istanze

# dichiaro variabili locali
# creo usando iteratori, una nuova mappa random ma metterndo uppercase le stringhe
 locals {
  uppercase_words = { for k, v in var.words : k => [for s in v : upper(s) ]}
  templates = tolist(fileset(path.module, "templates/*.txt"))
#element(["a", "b", "c"], 1)
}

# prendo dal value il valore randomico e lo assegno
resource "random_shuffle" "random_nouns" {
  #input = var.words["nouns"]
  count = var.num_files
  input = local.uppercase_words["nouns"]
}
resource "random_shuffle" "random_adjectives" {
  #input = var.words["adjectives"]
  count = var.num_files  
  input = local.uppercase_words["adjectives"]
}
resource "random_shuffle" "random_verbs" {
  #input = var.words["verbs"]
  count = var.num_files
  input = local.uppercase_words["verbs"]
}
resource "random_shuffle" "random_adverbs" {
  #input = var.words["adverbs"]
  count = var.num_files  
  input = local.uppercase_words["adverbs"]
}
resource "random_shuffle" "random_numbers" {
  #input = var.words["numbers"]
  count = var.num_files  
  input = local.uppercase_words["numbers"]
}

resource "local_file" "mad_libs" {
  count = var.num_files
  filename = "madlibs/madlibs-${count.index}.txt"
  content = templatefile(element(local.templates, count.index), 
    {
      nouns       = random_shuffle.random_nouns[count.index].result,
      adjectives  = random_shuffle.random_adjectives[count.index].result,
      verbs       = random_shuffle.random_verbs[count.index].result,
      adverbs     = random_shuffle.random_adverbs[count.index].result,
      numbers     = random_shuffle.random_numbers[count.index].result,      
    }
  )
}

# primo esercizio
# metto il risultato dentro la var mad_lips
# output "mad_lips" {
#   value = templatefile("${path.module}/templates/alice.txt", 
#   { 
#     nouns      = random_shuffle.random_nouns.result,
#     adjectives = random_shuffle.random_adjectives.result,
#     verbs      = random_shuffle.random_verbs.result,
#     adverbs    = random_shuffle.random_adverbs.result,
#     numbers    = random_shuffle.random_numbers.result,
#    }
# )
#}

data "archive_file" "mad_libs" {
  # attendi che finisca la generazione della risorsa mad_libs (sono i 100 file)
  depends_on = [
    local_file.mad_libs
  ]

  type = "zip"
  source_dir =  "${path.module}/madlibs"
  output_path = "${path.cwd}/madlibs.zip"

}
