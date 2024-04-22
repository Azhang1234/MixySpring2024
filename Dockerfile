# Use a base image with the necessary dependencies for Flutter and Android SDK
FROM ghcr.io/cirruslabs/flutter:3.19.6

# Set the working directory in the container
WORKDIR /app

# Copy the Flutter app to the container
COPY . /app

# Set up environment variables. No need to redefine FLUTTER_HOME as it should already be set in the base image
# ENV FLUTTER_HOME is not needed here since we're using the cirrusci/flutter image which already has Flutter installed

# Adjust file permissions for the flutter SDK if necessary (the location might vary)
# For the cirrusci/flutter image, Flutter is already correctly set up, so this might not be needed.
# However, if you have a custom setup that requires adjusting permissions or configuring safe directory access, you can uncomment and adjust the following lines:
# USER root
# RUN chown -R root:root $FLUTTER_HOME && \
#     chmod -R 755 $FLUTTER_HOME && \
#     git config --global --add safe.directory $FLUTTER_HOME

# Fetch dependencies for the project
RUN flutter pub get

# Accept Android licenses
RUN yes "y" | flutter doctor --android-licenses

# Build the APK
# You might need to adjust this command based on your project's specific build configurations (e.g., for different flavors or build modes)
RUN flutter build apk

# At this point, the APK is built and located in /app/build/app/outputs/flutter-apk/app-release.apk within the container.
# You might want to extract this APK from the container for distribution.
# Use Docker commands like `docker cp` or consider setting up volume mounting as appropriate.
