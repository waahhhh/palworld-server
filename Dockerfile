FROM ubuntu:latest

ARG PGID=1000
ARG PUID=1000

###
# This docker file is based on Steamcmd's Dockerfile mixed with custom statements to run as non-root.
# Source https://github.com/steamcmd/docker/blob/master/dockerfiles/ubuntu-24/Dockerfile
###

### Steamcmd Dockerfile ###

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends ca-certificates locales steamcmd \
 && rm -rf /var/lib/apt/lists/*

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8'
ENV LANGUAGE='en_US:en'

# Create symlink for executable
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

### Custom Dockerfile ###

# Safely remove Ubuntu's default user / group
RUN if getent passwd 1000 > /dev/null; then userdel -r ubuntu; fi && \
    if getent group 1000 > /dev/null; then groupdel ubuntu; fi

# Create a non-root user
RUN groupadd --gid "${PGID}" steam && \
    useradd --uid "${PUID}" --gid steam --shell /bin/bash --create-home steam

# Change the user
USER steam
WORKDIR /app

### Steamcmd Dockerfile ###

# Update SteamCMD and verify latest version
RUN steamcmd +quit

# Fix missing directories and libraries
RUN mkdir -p $HOME/.steam \
 && ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
 && ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
 && ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
 && ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so

### Game specific ###
