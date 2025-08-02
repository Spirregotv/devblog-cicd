from flask import Blueprint, render_template, request, jsonify, redirect, url_for, flash
from app.models import blog_storage, BlogPost
from config import Config
from app import create_app

# Crear la aplicación usando la factory function
app = create_app()

if __name__ == '__main__':
    """
    Punto de entrada de la aplicación
    """
    print("Iniciando DevBlog...")
    print(f"Servidor corriendo en: http://{Config.HOST}:{Config.PORT}")
    print("Presiona Ctrl+C para detener el servidor")

    app.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=Config.DEBUG
    )
