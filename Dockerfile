# Imagen base
FROM nginx:alpine

# Copiar nuestro HTML a la carpeta pública de nginx
COPY index.html /usr/share/nginx/html/index.html

# Exponer el puerto por defecto de nginx
EXPOSE 80
