variable "username" {
  type = list(string)
  default = ["givi", "selin", "slava", "rita"]
}

variable "dev_users" {
  type = list(string)
  default = ["givi", "selin", "rita"]
}

variable "devops_users" {
  type = list(string)
  default = ["slava", "rita"]
}
