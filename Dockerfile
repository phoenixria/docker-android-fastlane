FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
    ANDROID_API_LEVEL=android-36 \
    ANDROID_BUILD_TOOLS_VERSION=36.0.0 \
    ANDROID_HOME=/usr/local/android-sdk-linux \
    ANDROID_VERSION=36 \
    FASTLANE_VERSION=2.234.0 \
    BUNDLER_VERSION=4.0.11 \
    RAKE_VERSION=13.4.2

ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

RUN set -eux; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install --no-install-recommends -y \
      openjdk-21-jdk \
      curl \
      unzip \
      ca-certificates \
      build-essential \
      git \
      ruby-full; \
    mkdir -p "${ANDROID_HOME}" /root/.android; \
    cd "${ANDROID_HOME}"; \
    curl -fsSL -o sdk.zip "${ANDROID_SDK_URL}"; \
    unzip -q sdk.zip; \
    rm -f sdk.zip; \
    mv cmdline-tools cmdline-tools-tmp; \
    mkdir -p "${ANDROID_HOME}/cmdline-tools"; \
    mv cmdline-tools-tmp "${ANDROID_HOME}/cmdline-tools/latest"; \
    yes | sdkmanager --licenses --sdk_root="${ANDROID_HOME}"; \
    sdkmanager --update --sdk_root="${ANDROID_HOME}"; \
    sdkmanager --sdk_root="${ANDROID_HOME}" \
      "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
      "platforms;android-${ANDROID_VERSION}" \
      "platform-tools" \
      "extras;android;m2repository" \
      "extras;google;m2repository"; \
    gem install --no-document rake -v "${RAKE_VERSION}"; \
    gem install --no-document bundler -v "${BUNDLER_VERSION}"; \
    gem install --no-document fastlane -v "${FASTLANE_VERSION}"; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
