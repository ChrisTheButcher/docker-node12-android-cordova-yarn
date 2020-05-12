FROM openjdk:8-jdk-slim

ENV LANG en_US.UTF-8
ENV NODE_VERSION 12.16.1  
ENV DEPLOY_ENV production

# Generic build dependencies
RUN apt-get update && \
  apt-get install -y --no-install-recommends lsof wget curl apt-transport-https build-essential unzip rubygems ruby-dev git zipalign libgtk2.0-0 libgtk-3-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb vim && \
  rm -rf /var/lib/apt/lists/*

# Android SDK
ENV GRADLE_VERSION 4.10.3

RUN mkdir -p /android/
ENV ANDROID_HOME /android/home/
ENV PATH="/opt/gradle/bin/:/android/home/tools/bin/:/android/home/tools/:/android/home/platform-tools/:${PATH}"

RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O sdk-tools.zip && \
  unzip sdk-tools.zip -d /android/home/ && \
  yes | /android/home/tools/bin/sdkmanager --licenses && \
  /android/home/tools/bin/sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3" && \
  rm sdk-tools.zip

RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -O gradle.zip && \
  unzip gradle.zip -d /tmp/gradle/ && \
  mv /tmp/gradle/gradle-$GRADLE_VERSION /opt/gradle && \
  rm -fr /tmp/gradle/ && \
  rm gradle.zip

# Fastlane
RUN gem install fastlane bundler

# NVM Node
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
RUN nvm install $NODE_VERSION \
  && nvm install 8 \
  && nvm install 10 \
  && npm install -g yarn \
  && nvm use $NODE_VERSION \
  && npm install -g yarn
RUN yarn global add firebase-tools @vue/cli ts-mocha ts-node cypress@4.5.0 mocha jest cordova@latest
RUN cypress install
RUN cordova telemetry off
EXPOSE 5000-5050
EXPOSE 8000-8090

RUN echo "Copying workdir..."
COPY . /usr/src/app
WORKDIR /usr/src/app
ENTRYPOINT ["/bin/bash", "init.sh"]

# Run this from container
# --------------------------
# WORKDIR /var/tigerbee-app
# COPY . /var/tigerbee-app

# RUN mkdir -p ./src-cordova/www
# RUN yarn setup 