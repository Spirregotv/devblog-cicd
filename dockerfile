# ================================
# ETAPA 1: IMAGEN BASE
# ================================

# Usar Python 3.11 slim como imagen base
FROM python:3.11-slim

# ================================
# ETAPA 2: METADATOS
# ================================

# Información sobre la imagen (buenas prácticas)
LABEL maintainer="tu-email@ejemplo.com"
LABEL description="DevBlog - Aplicación de blog para aprender DevOps"
LABEL version="1.0"

# ================================
# ETAPA 3: CONFIGURACIÓN DEL SISTEMA
# ================================

# Establecer variables de entorno
# - PYTHONUNBUFFERED=1: Logs en tiempo real
# - PYTHONDONTWRITEBYTECODE=1: No genera archivos .pyc
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Establecer directorio de trabajo
WORKDIR /app

# ================================ 
# ETAPA 4: INSTALACIÓN DE DEPENDENCIAS 
# ================================ 
 
# Copiar requirements.txt PRIMERO (optimización de Docker layers) 
# ¿Por qué copiar requirements.txt antes que el resto del código? 
# - Docker usa capas (layers) para optimizar builds 
# - Si solo cambia el código, no necesita reinstalar dependencias 
# - Esto hace los builds mucho más rápidos 
# 
#INSTALAR PARA PRODUCCION  
RUN apt-get update && apt-get install -y \ 
    curl \ 
    && rm -rf /var/lib/apt/lists/* 
 
COPY requirements.txt .

# ================================
# ETAPA 5: COPIAR CÓDIGO DE LA APLICACIÓN
# ================================

COPY . .

# ================================
# ETAPA 6: CONFIGURACIÓN DE USUARIO
# ================================

#PARA PRODUCCION 
# Health check 
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \ 
    CMD curl -f http://localhost:$PORT/api/health || exit 1 
# 
# ================================ 
# ETAPA 7: CONFIGURACIÓN DE RED 
# ================================ 
 
# Exponer el puerto 5000 (puerto por defecto de Flask) 
# Esto es documentativo - le dice a otros desarrolladores qué puerto usar 
# No abre automáticamente el puerto (eso se hace al ejecutar el contenedor) 
#CAMBIAR PARA PRODUCCION  
EXPOSE $PORT

# ================================
# ETAPA 8: COMANDO DE INICIO
# ================================

# Comando para iniciar Flask
CMD ["python", "app.py"]

# PYTHONDONTWRITEBYTECODE=1: Evita crear archivos .pyc (optimización) 
ENV PYTHONUNBUFFERED=1 
ENV PYTHONDONTWRITEBYTECODE=1 
#AGREGAR PARA PRODUCCION  
ENV FLASK_ENV=production 
ENV PORT=5000 