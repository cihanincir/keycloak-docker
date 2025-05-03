FROM quay.io/keycloak/keycloak:26.1 AS builder

ARG KC_HEALTH_ENABLED KC_METRICS_ENABLED KC_FEATURES KC_DB KC_HTTP_ENABLED PROXY_ADDRESS_FORWARDING QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY KC_HOSTNAME KC_LOG_LEVEL KC_DB_POOL_MIN_SIZE

ENV KC_HEALTH_ENABLED=${KC_HEALTH_ENABLED} \
    KC_METRICS_ENABLED=${KC_METRICS_ENABLED} \
    KC_FEATURES=${KC_FEATURES} \
    KC_DB=${KC_DB} \
    KC_HTTP_ENABLED=${KC_HTTP_ENABLED} \
    PROXY_ADDRESS_FORWARDING=${PROXY_ADDRESS_FORWARDING} \
    QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY=${QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY} \
    KC_HOSTNAME=${KC_HOSTNAME} \
    KC_LOG_LEVEL=${KC_LOG_LEVEL} \
    KC_DB_POOL_MIN_SIZE=${KC_DB_POOL_MIN_SIZE}

COPY custom-providers/*.jar /opt/keycloak/providers/
COPY /theme/keywind /opt/keycloak/themes/keywind

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.1

COPY java.config /etc/crypto-policies/back-ends/java.config
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--import-realm"]
