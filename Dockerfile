FROM ubuntu:24.04

LABEL ihorrusin <phoenix.ria@gmail.com>

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
ENV ANDROID_API_LEVEL android-34
ENV ANDROID_BUILD_TOOLS_VERSION 34.0.0
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_VERSION 34
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin

RUN apt-get update
RUN apt-get install openjdk-21-jdk curl unzip -y

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip && \
    # Download Android SDK
    yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME && \
    sdkmanager --update --sdk_root=$ANDROID_HOME && \
    sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" \
    "extras;android;m2repository" \
    "extras;google;m2repository" && \
    # Install Fastlane
    apt-get update && \
    apt-get install --no-install-recommends -y --allow-unauthenticated build-essential git ruby-full && \
    gem install rake && \
    gem install fastlane && \
    gem install bundler && \
    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean
