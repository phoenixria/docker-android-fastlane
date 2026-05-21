FROM ubuntu:26.04

ARG ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip
ARG ANDROID_BUILD_TOOLS_VERSION=37.0.0
ARG ANDROID_PLATFORM_VERSION=37.0
ARG FASTLANE_VERSION=2.234.0
ARG BUNDLER_VERSION=4.0.11
ARG RAKE_VERSION=13.4.2

ENV ANDROID_HOME=/usr/local/android-sdk-linux \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

RUN set -eux; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      openjdk-25-jdk \
      curl \
      unzip \
      ca-certificates \
      build-essential \
      git \
      ruby-full; \
    mkdir -p "${ANDROID_HOME}/cmdline-tools" /root/.android /tmp/android-sdk; \
    cd "${ANDROID_HOME}"; \
    curl -fsSL -o sdk.zip "${ANDROID_SDK_URL}"; \
    unzip -q sdk.zip -d /tmp/android-sdk; \
    rm -f sdk.zip; \
    mv /tmp/android-sdk/cmdline-tools "${ANDROID_HOME}/cmdline-tools/latest"; \
    yes | sdkmanager --licenses --sdk_root="${ANDROID_HOME}"; \
    sdkmanager --update --sdk_root="${ANDROID_HOME}"; \
    sdkmanager --sdk_root="${ANDROID_HOME}" \
      "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
      "platforms;android-${ANDROID_PLATFORM_VERSION}" \
      "platform-tools" \
      "extras;android;m2repository" \
      "extras;google;m2repository"; \
    gem install --no-document rake -v "${RAKE_VERSION}"; \
    gem install --no-document bundler -v "${BUNDLER_VERSION}"; \
    gem install --no-document fastlane -v "${FASTLANE_VERSION}"; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
