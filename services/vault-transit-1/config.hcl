storage "raft" {
  path = "/vault/data"
}

listener "tcp" {
  address = "[::]:8200"
  tls_disable = true
}

disable_mlock = true
api_addr = "http://vault-transit-1:8200"
cluster_addr = "http://vault-transit-1:8201"
ui = true
