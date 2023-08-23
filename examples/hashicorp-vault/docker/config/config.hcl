disable_mlock = true
ui            = true

listener "tcp" {
  address     = "0.0.0.0:8300"
  tls_disable = "true"
}

storage "file" {
  path = "/tmp/vault-data"
}