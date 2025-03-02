FROM node:16

WORKDIR /usr/src/app
COPY . .
# installing only server dependencies since client is already built
RUN cd server && npm install