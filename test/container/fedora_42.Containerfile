FROM fedora:42

RUN groupadd --gid 1000 droptix \
    && useradd --uid 1000 --gid 1000 --shell /usr/bin/bash --create-home droptix

RUN chown -R droptix:droptix /home/droptix

RUN echo "droptix ALL=(ALL) NOPASSWD: ALL" \
    | tee /etc/sudoers.d/droptix-user-nopasswd \ 
    && chmod 0440 /etc/sudoers.d/droptix-user-nopasswd

USER droptix

WORKDIR /opt/system-forger
