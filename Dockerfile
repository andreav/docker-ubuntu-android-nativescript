FROM ubuntu:bionic AS ubuntunativescript
MAINTAINER Andrea V <andreav.pub@gmail.com>

RUN useradd -ms /bin/bash nativescript

# Utilities
RUN apt-get update && \
    apt-get -y install apt-transport-https unzip curl usbutils --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# JAVA
RUN apt-get update && \
    #apt-get -y install default-jdk --no-install-recommends && \
    apt-get -y install openjdk-8-jdk --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get -y install nodejs --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# NativeScript
RUN npm install -g nativescript && \
    tns error-reporting disable

# Android build requirements
RUN apt-get update && \
    apt-get -y install lib32stdc++6 lib32z1 --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# Download and untar Android SDK tools
RUN mkdir -p /usr/local/android-sdk-linux && \
    curl -sL https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -o tools.zip && \
    unzip tools.zip -d /usr/local/android-sdk-linux && \
    rm tools.zip

# Set environment variable
# ENV JAVA_HOME $(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "tools" "emulator" "platform-tools" "platforms;android-28" "build-tools;28.0.3" "extras;android;m2repository" "extras;google;m2repository"

WORKDIR /usr/src/app

CMD ["bash", "/docker-entrypoint.sh"]
