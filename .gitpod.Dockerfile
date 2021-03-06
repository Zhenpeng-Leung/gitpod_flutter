FROM gitpod/workspace-full

USER root
RUN apt-get update &&\
    apt-get -y install xz-utils openjdk-8-jdk &&\
    apt-get -y upgrade

USER gitpod

# Install android SDK
ENV ANDROID_HOME=${HOME}/sdk/android
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ARG ANDROID_SDK_NAME=sdk-tools-linux-4333796.zip

RUN mkdir -p ${HOME}/.android ${ANDROID_HOME} &&\
    touch ${HOME}/.android/repositories.cfg &&\
    cd ${ANDROID_HOME} &&\
    wget -q https://dl.google.com/android/repository/${ANDROID_SDK_NAME} &&\
    unzip -q ${ANDROID_SDK_NAME} &&\
    rm -f ${ANDROID_SDK_NAME} &&\
    yes | sdkmanager --licenses &&\
    sdkmanager --update

# Install flutter beta SDK. The beta includes web support
ENV FLUTTER_HOME=${HOME}/sdk/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin
ARG FLUTTER_SDK_NAME=flutter_linux_v1.12.13+hotfix.5-stable.tar.xz

RUN cd ${HOME}/sdk &&\
    wget -q https://storage.googleapis.com/flutter_infra/releases/stable/linux/${FLUTTER_SDK_NAME} &&\
    tar -xf ${FLUTTER_SDK_NAME} &&\
    rm -f ${FLUTTER_SDK_NAME} &&\
    flutter channel beta &&\
    flutter upgrade &&\
    flutter config --enable-web

USER root
RUN apt-get -y purge openjdk-8-jdk &&\
    apt-get -y autoremove && apt-get clean &&\
    rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*
