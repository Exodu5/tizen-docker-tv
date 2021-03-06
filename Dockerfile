FROM ubuntu:16.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

LABEL maintainer="fremontclement21@gmail.com" \
      version="0.1" \
      description="NUGUSDK for Tizen development environment"

ENV DEBIAN_FRONTEND=noninteractive \
    USER=work \
    LC_ALL=en_US.UTF-8 \
    LANG=$LC_ALL

RUN apt-get update && apt-get install -y \
        acl \
        ca-certificates-java \
        openjdk-8-jdk \
        pciutils \
        rpm2cpio \
        sudo \
        zip \
        gettext \
        libcanberra-gtk-module \
        libcurl3-gnutls \
        libsdl1.2debian \
        libwebkitgtk-1.0-0 \
        libv4l-0 \
        libvirt-bin \
        libxcb-render-util0 \
        libxcb-randr0 \
        libxcb-shape0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxtst6 \
        cpio \
        bridge-utils \
        openvpn \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# User
RUN useradd -ms /bin/bash $USER \
	&& echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
	&& chmod 0440 /etc/sudoers.d/$USER \
	&& echo 'Defaults env_keep="http_proxy https_proxy ftp_proxy no_proxy"' >> /etc/sudoers \
	&& adduser $USER dialout

USER $USER
ENV HOME=/home/$USER \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH=$JAVA_HOME/bin:$PATH
WORKDIR /home/$USER

# Tizen Studio CLI tool
RUN wget http://download.tizen.org/sdk/Installer/tizen-studio_3.6/web-cli_Tizen_Studio_3.6_ubuntu-64.bin \
    && chmod 755 web-cli_Tizen_Studio_3.6_ubuntu-64.bin \
    && yes | ./web-cli_Tizen_Studio_3.6_ubuntu-64.bin --accept-license \
    && rm web-cli_Tizen_Studio_3.6_ubuntu-64.bin

# Add tizen cli path
ENV PATH=/home/$USER/tizen-studio/tools/ide/bin:$PATH
# Add sdb cli path
ENV PATH=/home/$USER/tizen-studio/tools/sdb:$PATH

RUN sudo chmod 755 /root

RUN ./tizen-studio/package-manager/package-manager-cli.bin \
    install --accept-license Emulator

RUN ./tizen-studio/package-manager/package-manager-cli.bin \
    install --accept-license Baseline-SDK

RUN ./tizen-studio/package-manager/package-manager-cli.bin \
    install --accept-license TV-SAMSUNG-Extension-Resources

RUN ./tizen-studio/package-manager/package-manager-cli.bin \
    install --accept-license TV-SAMSUNG-Extension-Tool

RUN ./tizen-studio/package-manager/package-manager-cli.bin \
    install --accept-license TV-SAMSUNG-Public

RUN ./tizen-studio/package-manager/package-manager-cli.bin \
    install --accept-license TV-SAMSUNG-Public-Emulator

RUN ./tizen-studio/package-manager/package-manager-cli.bin \
    install --accept-license TV-SAMSUNG-Public-WebAppDevelopment


ENTRYPOINT [ "/bin/bash" ]