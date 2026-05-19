# docker-android-fastlane

Docker image definition for building Android apps with Fastlane on Ubuntu.

## What's included

- Ubuntu `26.04` base image.
- Android SDK Command-line Tools.
- Android SDK components:
  - `build-tools;36.0.0`
  - `platforms;android-36`
  - `platform-tools`
  - `extras;android;m2repository`
  - `extras;google;m2repository`
- OpenJDK 21.
- Ruby toolchain with pinned gems:
  - Fastlane `2.234.0`
  - Bundler `4.0.11`
  - Rake `13.4.2`

## Files

- `Dockerfile`: image definition and provisioning steps.

## Build

```bash
docker build -t docker-android-fastlane:latest .
```

## Verify tools inside the image

```bash
docker run --rm -it docker-android-fastlane:latest bash -lc 'java -version && sdkmanager --version && fastlane --version && bundler --version && rake --version'
```

## Notes

- The Dockerfile accepts Android SDK licenses during build.
- Gem versions are pinned for reproducibility.
- Android SDK root is set to `/usr/local/android-sdk-linux`.
