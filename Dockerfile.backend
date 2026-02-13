FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# Use writable temp home for Maven/Quarkus at runtime
ENV HOME=/tmp \
    MAVEN_USER_HOME=/tmp/.m2 \
    TMPDIR=/tmp \
    XDG_CACHE_HOME=/tmp/.cache
    
# Copy from context (quarkus-test/) to /app
COPY . /app

# Make wrapper executable, fix CRLF, download dependencies
RUN chmod +x mvnw && \
    sed -i 's/\r$//' mvnw && \
    ./mvnw -B -ntp dependency:go-offline && \
    rm -rf /tmp/.m2  # avoid root-owned cache in the image

# Clean up Windows ADS junk that Quarkus logs as "Unrecognized configuration file ... :Zone.Identifier"
RUN find /app -name '*:Zone.Identifier' -delete || true

# ---- Runtime config (everything needed defined here) ----
ENV SERVER_PORT=8080

# Quarkus HTTP config
ENV QUARKUS_HTTP_HOST=0.0.0.0 \
    QUARKUS_HTTP_PORT=8080

# Disable interactive analytics prompt
ENV QUARKUS_ANALYTICS_DISABLED=true

# Satisfy required config 'app.version' via env var (maps to app.version)
ENV APP_VERSION=1.0.0

# Also force via system properties (belt + suspenders)
ENV JAVA_TOOL_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Dquarkus.http.port=8080 -Dapp.version=1.0.0"

ENV QUARKUS_DEVUI_ENABLED=false \
    QUARKUS_LAUNCH_DEVUI=false \
    QUARKUS_DEV_UI=false

EXPOSE 8080

# Run via sh so platform entrypoint execs a real binary
CMD ["sh", "./mvnw", "quarkus:dev"]
