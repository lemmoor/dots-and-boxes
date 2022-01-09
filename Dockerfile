FROM node:16

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --silent && \
npm install react-scripts --silent
COPY . .
EXPOSE 3000
CMD ["npm", "start"]