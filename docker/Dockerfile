FROM debian:trixie-slim
LABEL MAINTAINER="Ted Neward"

RUN apt-get update && apt-get install -y \
    git \
    curl wget \
    nano \
    build-essential \
    zip unzip \
    ca-certificates \
    sudo \
    && rm -rf /var/lib/apt/lists/*
    # The last line is to keep the image size down by removing the apt cache. It means
    # that if you want to install more packages later, you'll need to run `apt-get update`
    # again first.

# Create a non-root user to do our work
# (This is a best practice for Docker containers, and also necessary to run SDKMAN)
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/apt-get, /usr/bin/apt" > /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

# Create a workspace directory for our work
RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME/workspace

# Set up host current directory as workspace
VOLUME /home/$USERNAME/workspace

# Bring in our dotfiles for bash customization
COPY --chown=$USERNAME:$USERNAME docker/dotfiles/.bashrc /home/$USERNAME/.bashrc
COPY --chown=$USERNAME:$USERNAME docker/dotfiles/.dircolors /home/$USERNAME/.dircolors

##### Java is necessary to run ANTLR4 and its associated toolset

# Get SDKMAN set up
RUN curl -s "https://get.sdkman.io" | bash \
    && bash -c "source /home/$USERNAME/.sdkman/bin/sdkman-init.sh && sdk update"
ENV SDKMAN_DIR="/home/$USERNAME/.sdkman"
ENV PATH="$SDKMAN_DIR/bin:$PATH"

# Install OpenJDK 17
RUN bash -c "source /home/$USERNAME/.sdkman/bin/sdkman-init.sh && sdk install java 17-open"
ENV JAVA_HOME="/home/$USERNAME/.sdkman/candidates/java/current"
ENV PATH="$JAVA_HOME/bin:$PATH"

# Gradle will be installed when we run the "gradlew" script from the root

# All the ANTLR4 bits and pieces are a part of the ANTLR jar in /antlr

CMD ["/bin/bash"]
