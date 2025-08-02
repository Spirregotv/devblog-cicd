import pytest
from app import create_app
from app.models import blog_storage

# ================================
# FIXTURE: APLICACIÓN DE PRUEBA
# ================================
@pytest.fixture
def app():
    """
    Crea una instancia de la aplicación Flask para testing.

    ¿Qué es un fixture?
    - Función que prepara datos/objetos para las pruebas
    - Se ejecuta antes de cada test que lo necesite
    - Garantiza un estado limpio para cada prueba
    """
    app = create_app()
    app.config['TESTING'] = True
    app.config['WTF_CSRF_ENABLED'] = False  # Desactiva CSRF en tests
    return app

# ================================
# FIXTURE: CLIENTE HTTP DE PRUEBA
# ================================
@pytest.fixture
def client(app):
    """
    Crea un cliente de prueba para simular peticiones HTTP.

    ¿Para qué sirve?
    - Simula un navegador web
    - Permite hacer GET, POST, etc.
    - No requiere servidor real
    """
    return app.test_client()

# ================================
# FIXTURE: RUNNER PARA CLI
# ================================
@pytest.fixture
def runner(app):
    """
    Permite ejecutar comandos CLI de la app (si los hubiera).
    """
    return app.test_cli_runner()

# ================================
# FIXTURE: RESET DEL ALMACENAMIENTO
# ================================
@pytest.fixture(autouse=True)
def reset_storage():
    """
    Limpia y reinicia el almacenamiento de posts antes de cada test.

    ¿Por qué autouse=True?
    - Se ejecuta automáticamente antes de cada prueba
    - Garantiza que los tests no se contaminen entre sí
    """
    # Reiniciar almacenamiento
    blog_storage._posts.clear()
    blog_storage._next_id = 1
    blog_storage._create_sample_posts()

    yield  # Aquí se ejecuta la prueba

    # Post-test cleanup (si fuera necesario)
    pass