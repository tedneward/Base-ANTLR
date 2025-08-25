FROM debian:trixie-slim
LABEL MAINTAINER="Ted Neward"

RUN apt-get update && apt-get install -y \
    git \
    curl wget \
#    zsh \  # Until I can figure out how to get past the zsh-newuser-install prompt
    nano \
    build-essential \
    zip unzip \
    ca-certificates \
    sudo \
#    htop \
#    tree \
#    jq \
#    openssh-client \
#    gnupg2 \
#    less \
#    netcat-openbsd \
#    dnsutils \
#    ripgrep \
#    fd-find \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/apt-get, /usr/bin/apt" > /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

RUN mkdir -p /home/$USERNAME/workspace

WORKDIR /home/$USERNAME/workspace

# Set up host current directory as workspace
VOLUME /home/$USERNAME/workspace

COPY --chown=$USERNAME:$USERNAME docker/dotfiles/.bashrc /home/$USERNAME/.bashrc
COPY --chown=$USERNAME:$USERNAME docker/dotfiles/.dircolors /home/$USERNAME/.dircolors

# Get SDKMAN set up
RUN curl -s "https://get.sdkman.io" | bash \
    && bash -c "source /home/$USERNAME/.sdkman/bin/sdkman-init.sh && sdk version"
ENV SDKMAN_DIR="/home/$USERNAME/.sdkman"
ENV PATH="$SDKMAN_DIR/bin:$PATH"

# Install OpenJDK 21
RUN bash -c "source /home/$USERNAME/.sdkman/bin/sdkman-init.sh && sdk install java 21.0.7-tem"

CMD ["/bin/bash"]
