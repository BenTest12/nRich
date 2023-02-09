FROM node:14
WORKDIR /usr/share/app
COPY ./webapp/package*.json .
COPY ./webapp .
RUN npm i && npm audit fix --force && npm install typescript -g && tsc index.ts --outDir dist/ --esModuleInterop 
EXPOSE 4444
CMD ["npm", "start"]