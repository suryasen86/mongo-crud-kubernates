FROM node:16

#author 
MAINTAINER Suryasen Vishwakarma 

WORKDIR /usr/src/app
COPY . .

RUN npm install



EXPOSE 3000

CMD [ "node", "service.js" ]