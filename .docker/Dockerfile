ARG PYTHON_IMAGE
ARG PYTHON_TAG
FROM ${PYTHON_IMAGE}:${PYTHON_TAG}

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl jq screen bash dos2unix net-tools \
    ca-certificates gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure Git globally
RUN git config --system user.name 'Jose Clemente Garcia Rodriguez' && \
    git config --system user.email 'josegarciarodriguez89@hotmail.com' && \
    git config --system core.autocrlf input && \
    git config --system core.fileMode false && \
    git config --system alias.l 'log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all' && \
    git config --system alias.s 'status --short' && \
    git config --system --add safe.directory /app && \
    git config --system --add safe.directory /app/api

# Copy the startup script that decides whether to launch Uvicorn or remain on standby
COPY ./.docker/start.sh /usr/local/bin/start.sh
RUN dos2unix /usr/local/bin/start.sh || true && chmod +x /usr/local/bin/start.sh

CMD ["start.sh"]
