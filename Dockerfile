FROM bitnami/minideb:trixie

# Build-time variables
ARG userid=1000
ARG groupid=1000
ARG username=foxtainer

# Using separate RUNs here allows Docker to cache each update
RUN DEBIAN_FRONTEND="noninteractive" apt-get update

# Make sure the base image is up to date
RUN DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y

# Install apt-utils to make apt run more smoothly
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y apt-utils

# Install basic packages
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y sudo wget curl vim

# Install the packages needed for the build
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y python-is-python3 less bc \
jq git

# User management
RUN groupadd -g $groupid $username \
 && useradd -m -s /bin/bash -u $userid -g $groupid $username \
 &&  echo "${username} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers \
 && chown -R ${username}:${username} /home/${username} \
 && mkdir /aosp && chown $userid:$groupid /aosp && chmod ug+s /aosp

WORKDIR /home/${username}
USER ${username}
CMD ["/bin/bash"]

# Git configs
RUN git config --global user.name rvsmooth \
&& git config --global user.email riveeks.smooth@gmail.com \
&& git config --global color.ui false \
&& git config --global core.editor vim 
