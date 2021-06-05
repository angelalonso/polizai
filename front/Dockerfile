# thanks https://mherman.org/blog/dockerizing-a-react-app/
FROM node:13.12.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent
COPY . ./
RUN npm run build

# pull official base image
FROM node:13.12.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

#COPY --from=build /app/node_modules /app/
#COPY --from=build /app/package.json /app/
#COPY --from=build /app/build /app/
#COPY --from=build /app/env.sh /app/env.sh
#COPY --from=build /app/run /app/run
COPY --from=build /app /app

RUN apk add --update bash nodejs nodejs-npm


EXPOSE 3000

# start app
CMD ["/bin/bash", "-c", "/app/run"]
