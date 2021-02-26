FROM node:14-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install --production
COPY . ./
# We do not want to be tracked
RUN npx next telemetry disable
# Building app
RUN npm run build
EXPOSE 3000
CMD [ "npm", "start" ]