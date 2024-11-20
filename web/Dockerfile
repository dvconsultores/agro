FROM node:20 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# setup [ARG] to catch values from workflow
ARG VITE_BASE_URL
ARG VITE_API_URL
ARG VITE_SECURE_STORAGE_NAME_SPACE
ARG VITE_SECURE_STORAGE_KEY

# move values from [ARG] to [ENV]
ENV VITE_BASE_URL $VITE_BASE_URL
ENV VITE_API_URL $VITE_API_URL
ENV VITE_SECURE_STORAGE_NAME_SPACE $VITE_SECURE_STORAGE_NAME_SPACE
ENV VITE_SECURE_STORAGE_KEY $VITE_SECURE_STORAGE_KEY

RUN npm run build

# Stage 2: Serve Vue app with Nginx
FROM nginx:1.25.1 as prod-stage
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
