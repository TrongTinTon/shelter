FROM hashicorp/vault

EXPOSE 8200

COPY config.hcl /vault/config/vault-config.hcl

COPY entrypoint.sh /vault/entrypoint.sh
RUN chmod +x /vault/entrypoint.sh

ENV VAULT_ADDR=http://vault-transit-1:8200
ENV VAULT_API_ADDR=http://vault-transit-1:8200

ENTRYPOINT ["/vault/entrypoint.sh"]
