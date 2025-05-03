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
COPY /theme/keywind /opt/keycloak/themes/keywind

# Keycloak yapılandırmasını doğru log seviyesinde ayarlıyoruz
ENV KC_LOG_LEVEL=debug  # Veya ihtiyacınıza göre 'info' ya da 'warn' olabilir

# Keycloak'ı build ediyoruz
RUN /opt/keycloak/bin/kc.sh build

# Ana imaj olarak son sürümü alıyoruz
FROM quay.io/keycloak/keycloak:latest

# Güvenlik konfigürasyon dosyasını kopyalıyoruz
COPY java.config /etc/crypto-policies/back-ends/java.config

# Builder aşamasından keycloak dosyalarını alıyoruz
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Keycloak'ı başlatmak için giriş komutunu tanımlıyoruz
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

# Keycloak'ı başlatmak için gereken komut
CMD ["start", "--optimized", "--import-realm"]
