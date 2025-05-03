FROM quay.io/keycloak/keycloak:26.1 AS builder

# Build time arg'larını tanımlıyoruz
ARG KC_HEALTH_ENABLED
ARG KC_METRICS_ENABLED
ARG KC_FEATURES
ARG KC_DB
ARG KC_HTTP_ENABLED
ARG PROXY_ADDRESS_FORWARDING
ARG QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY
ARG KC_HOSTNAME
ARG KC_LOG_LEVEL
ARG KC_DB_POOL_MIN_SIZE

# Keycloak temalarınızın ve custom provider dosyalarınızı kopyalıyoruz
COPY custom-providers/*.jar /opt/keycloak/providers/

# Keycloak'ı build ediyoruz
RUN /opt/keycloak/bin/kc.sh build

# Güvenlik konfigürasyon dosyasını kopyalıyoruz
COPY java.config /etc/crypto-policies/back-ends/java.config

# Keycloak'ı başlatmak için giriş komutunu tanımlıyoruz
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

# Keycloak'ı başlatmak için gereken komut
CMD ["start", "--optimized", "--import-realm"]
