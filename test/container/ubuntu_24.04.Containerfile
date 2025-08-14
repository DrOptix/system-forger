FROM ubuntu:24.04

# CRITICAL FIX for unprivileged Podman containers with Ubuntu:
# Ubuntu base images often link /etc/mtab to /proc/mounts.
# Unprivileged containers cannot write to /proc, causing "Operation not permitted"
# when apt or other tools try to update mount info.
# This ensures /etc/mtab is a regular, writable file from the start.
RUN rm -f /etc/mtab && \
    touch /etc/mtab && \
    chmod 0644 /etc/mtab

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo

RUN groupadd --gid 1001 droptix \
    && useradd --uid 1001 --gid 1001 --shell /usr/bin/bash --create-home droptix

# Set permissions for home directory
RUN chown -R droptix:droptix /home/droptix

# Grant sudo without password for the 'droptix' user
# tee is used for safe writing as root to /etc/sudoers.d/
RUN echo "droptix ALL=(ALL) NOPASSWD: ALL" \
    | tee /etc/sudoers.d/droptix-user-nopasswd \
    && chmod 0440 /etc/sudoers.d/droptix-user-nopasswd

USER droptix

WORKDIR /opt/system-forger
