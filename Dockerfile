FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Installing apt-utils
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1

# Setting up development user
ARG USERNAME=devuser

# Or your actual UID, GID on Linux if not the default 1000
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID --shell /bin/bash -m $USERNAME \
    #
    # [Optional] Add sudo support
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Technically optional
ENV HOME /home/$USERNAME

# Installing minimal tools
RUN apt-get -y install git vim net-tools wget unzip xz-utils curl 
# lib32stdc++6

 # Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Set the default user
USER $USERNAME

ENV DEBIAN_FRONTEND=