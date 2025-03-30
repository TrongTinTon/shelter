ui = true
disable_mlock = true

storage "raft" {
  path = "/vault/data"
  node_id = "node1"
}

listener "tcp" {
  address = "[::]:8200"
  tls_disable = true
}

seal "transit" {
  address = "http://vault-unseal-server:8200"
  disable_renewal = false
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = true
}

api_addr = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"
