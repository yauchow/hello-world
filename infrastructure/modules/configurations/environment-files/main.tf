variable "folder" {
  description = "folder relative from witin <root>/infrastructure, exclude trailing /"
  type        = string
}

locals {
  files = merge(
    fileexists("${var.folder}/config.yaml") ? yamldecode(file("${var.folder}/config.yaml")) : {},
    {
      for key, file in fileset(var.folder, "*.yaml") : trimsuffix(file, ".yaml") =>
      yamldecode(file("${var.folder}/${file}"))
    }
  )
}

output "config" {
  value = local.files
}