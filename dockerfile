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

# Copiar requirements.txt primero para aprovechar el cache
COPY requirements.txt .

# Actualizar pip e instalar dependencias
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# ================================
# ETAPA 5: COPIAR CÓDIGO DE LA APLICACIÓN
# ================================

COPY . .

# ================================
# ETAPA 6: CONFIGURACIÓN DE USUARIO
# ================================

RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app

USER appuser

# ================================
# ETAPA 7: CONFIGURACIÓN DE RED
# ================================

# Exponer el puerto 5000 para Flask
EXPOSE 5000

# ================================
# ETAPA 8: COMANDO DE INICIO
# ================================

# Comando para iniciar Flask
CMD ["python", "app.py"]
