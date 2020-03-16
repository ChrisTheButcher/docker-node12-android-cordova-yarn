# Source code of `https://hub.docker.com/repository/docker/chriswijnia/dev`

#### This serves as a base for Cordova projects
An example Dockerfile that uses this as a base could look something like this:
```
FROM chriswijnia/dev:latest
WORKDIR /var/my-app
COPY . /var/my-app
RUN yarn 
```

#### How to use
- build image: `yarn build`
- start in bash: `yarn start`
- deploy to dockerhub: `yarn deploy`

#### Features
- from `openjdk:8-jdk-slim`
- available commands `yarn`, `git`, `apt`, `node`  (v12), `cordova`, `gradle`, `zipalign`, `bundler`, `fastlane`, and more...

