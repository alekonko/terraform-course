# Terraform in Action - Appunti conco

Revised code for Terraform course

## Link utili

- https://github.com/GoogleCloudPlatform/cloud-foundation-fabric
- https://github.com/terraform-google-modules/terraform-example-foundation
- https://www.cloudskillsboost.google/quests/212

## Basi

- Dipendenze (attese)

implicita: quando uso il ".result" dico che deve attendere che sia disponibile

```json
  content = templatefile(element(local.templates, count.index),
    {
      nouns       = random_shuffle.random_nouns[count.index].result,
```

esplicita: la impostiamo noi dicendo di aspettare che l'oggetto indicato (mad_libs) sia terminato

```json
data "archive_file" "mad_libs" {
  # attendi che finisca la generazione della risorsa mad_libs (sono i 100 file) altrimenti parte subito (non ha oggetti)
  depends_on = [
    local_file.mad_libs
  ]
```

- Datasource

Non ha drift in quanto è stateless. NON HA DESTROY

- Variabili: locals

- Variabili: output varibili che passo ad altri moduli o che stampo a video

## espressioni

- for

```json
[for o in var.list : o.id]
```

- splat expression (for compatto)

```json
var.list[*].id
```

## dynamic blocks

- https://www.terraform.io/language/expressions/dynamic-blocks

servono per ripetere delle configurazioni quando si realizzano dei moduli o dei template

You can dynamically construct repeatable nested blocks like setting using a special dynamic block type, which is supported inside resource, data, provider, and provisioner blocks:

```json
resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tf-test-name"
  application         = "${aws_elastic_beanstalk_application.tftest.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.4 running Go 1.12.6"

  dynamic "setting" {
    for_each = var.settings
    content {
      namespace = setting.value["namespace"]
      name = setting.value["name"]
      value = setting.value["value"]
    }
  }
}
```

```json
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
```


- https://github.com/terraform-google-modules/terraform-google-lb-http/blob/master/main.tf


```json
  dynamic "backend" {
    for_each = toset(each.value["groups"])
    content {
      description = lookup(backend.value, "description", null)
      group       = lookup(backend.value, "group")

      balancing_mode               = lookup(backend.value, "balancing_mode")
      capacity_scaler              = lookup(backend.value, "capacity_scaler")
      max_connections              = lookup(backend.value, "max_connections")
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance")
      max_connections_per_endpoint = lookup(backend.value, "max_connections_per_endpoint")
      max_rate                     = lookup(backend.value, "max_rate")
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance")
      max_rate_per_endpoint        = lookup(backend.value, "max_rate_per_endpoint")
      max_utilization              = lookup(backend.value, "max_utilization")
    }
  }
```

## moduli

A Terraform module is any folder that contains one or more files defining variables, resources, and optional outputs. The files you
have been working on so far are a module callable from other Terraform files.
A Terraform module is similar to a library or package in traditional programming
languages: a module can be distributed,documented, versioned, shared via a central
repository and then consumed by client code that imports/declares it.
Modules also encode patterns and make the low-level API interface more user friendly.

Default module structure:

- main.tf, resources, locals, etc.
- outputs.tf, module output variables
- variables.tf module input variables
- [versions.tf] Terraform version constraints
- [*.tf]. additional Terraform files if needed
- [modules/module-name] additional submodules if needed

USO:

```json
module "my-buckets" {
  source = "./modules/gcs"
  project_id = var.project_id
  prefix = "tf-ws-test"
  names = ["tfstate"]
  bucket_policy_only = {
      tfstate = false
    }
}
```



## importare modifiche

esempio, creo docker container poi lo porto in tf.

creo con comandi docker
creo nel file la risorsa "vuota"

```json
resource "docker_container" "web" {}
```

uso terraform import  (nome della risorsa)  $(docker inspect -f {{.ID}}) hashicorp-learn
e lo porto nello stato con docker show verso il file tf

```bash
terraform show -no-color > docker.tf
```

poi devo "pulire" l'oggetto dagli attributi read only o non necessari e con tf plan controllo



