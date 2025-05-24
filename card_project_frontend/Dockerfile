# Stage 1: Build the React application
FROM node:18-alpine as build-stage

WORKDIR /app

COPY package*.json ./
# COPY yarn.lock ./ # If using yarn

RUN npm install
# RUN yarn install # If using yarn

COPY . .

RUN npm run build
# RUN yarn build # If using yarn

# Stage 2: Serve the application with Nginx
FROM nginx:1.25-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
