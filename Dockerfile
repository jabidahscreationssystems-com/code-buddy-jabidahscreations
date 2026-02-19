# Base image - pinned version for reproducibility
FROM alpine:3.19

# Install required dependencies
RUN	apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]