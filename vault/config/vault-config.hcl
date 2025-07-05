storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1  # Disable TLS for simplicity (enable in production)
}

api_addr = "http://0.0.0.0:8200"
ui = true  # Enable Vault web UI
