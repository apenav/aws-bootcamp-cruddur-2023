FROM node:16.18

ENV PORT=3000
COPY . /frontend-react-js
WORKDIR /frontend-react-js

RUN npm install
#RUN npm audit fix
#RUN npm audit fix --force
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:${PORT}/ || exit 1
EXPOSE ${PORT}

EXPOSE ${PORT}
CMD ["npm", "start"]
