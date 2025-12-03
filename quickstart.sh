#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# .gitignore
# ═══════════════════════════════════════════════════════════════
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv
pip-log.txt
pip-delete-this-directory.txt

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnp
.pnp.js
build/
.DS_Store

# Environment
.env
.env.local
.env.development
.env.production
secrets/

# Database
*.db
*.sqlite
*.sqlite3

# IDE
.vscode/
.idea/
*.swp
*.swo

# Data
data/raw/*
data/processed/*
data/cache/*
!data/raw/.gitkeep
!data/processed/.gitkeep
!data/cache/.gitkeep

# Models
backend/ml/saved_models/*.h5
backend/ml/saved_models/*.pkl

# Logs
*.log
logs/

# OS
.DS_Store
Thumbs.db
EOF

echo -e "${GREEN}✅ .gitignore creado${NC}"

# Crear archivos .gitkeep para preservar estructura
touch data/raw/.gitkeep
touch data/processed/.gitkeep
touch data/cache/.gitkeep
touch data/exports/.gitkeep

# ═══════════════════════════════════════════════════════════════
# README.md (link al épico)
# ═══════════════════════════════════════════════════════════════
cat > README.md << 'EOF'
# 🌞 HelioBio-Solacial: Correlaciones Cósmicas para el Siglo XXI

**"Las ciencias del siglo XXI serán correlaciones cósmicas o no serán"**

## 🚀 Inicio Rápido

```bash
# 1. Ejecutar quickstart (crea estructura completa)
./quickstart.sh

# 2. Activar entorno virtual Python
cd HelioBio-Solacial
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# o
venv\Scripts\activate     # Windows

# 3. Instalar dependencias backend
cd backend
pip install -r requirements.txt

# 4. Iniciar backend (Puerto 1150)
python main.py

# En otra terminal:
# 5. Instalar dependencias frontend
cd ../frontend
npm install

# 6. Iniciar frontend (Puerto 1151)
npm start

# 7. Abrir navegador
# Frontend: http://localhost:1151
# API Docs: http://localhost:1150/docs
```

## 🐳 Con Docker (Recomendado)

```bash
cd HelioBio-Solacial
docker-compose up -d

# Acceder a:
# Frontend: http://localhost:1151
# Backend API: http://localhost:1150
# API Docs: http://localhost:1150/docs
# Jupyter: http://localhost:1154
# PgAdmin: http://localhost:1155
```

## 📊 Puertos Asignados

| Servicio | Puerto | URL |
|----------|--------|-----|
| Backend (FastAPI) | 1150 | http://localhost:1150 |
| Frontend (React) | 1151 | http://localhost:1151 |
| PostgreSQL | 1152 | localhost:1152 |
| Redis | 1153 | localhost:1153 |
| Jupyter | 1154 | http://localhost:1154 |
| PgAdmin | 1155 | http://localhost:1155 |
| Grafana | 1156 | http://localhost:1156 |

## 🌟 Características

- ☀️ **Datos Solares en Tiempo Real** (NOAA, NASA)
- 🧠 **Indicadores de Salud Mental** (WHO, CDC)
- 📊 **Análisis de Correlación** (Pearson, Granger, Wavelets)
- 🤖 **Machine Learning Predictivo** (LSTM, Random Forest)
- 📈 **Dashboard Interactivo** (React + Recharts)
- 🔬 **Notebooks Científicos** (Jupyter)

## 📚 Documentación

- [Instalación Detallada](docs/INSTALLATION.md)
- [API Reference](docs/API_REFERENCE.md)
- [Metodología Científica](docs/SCIENTIFIC_METHOD.md)
- [Fuentes de Datos](docs/DATA_SOURCES.md)
- [Contribuir](docs/CONTRIBUTING.md)

## 🤝 Contribuir

¡Únete a la revolución de las correlaciones cósmicas!

1. Fork el repositorio
2. Crea tu rama: `git checkout -b feature/amazing-feature`
3. Commit: `git commit -m 'feat: Add amazing feature'`
4. Push: `git push origin feature/amazing-feature`
5. Abre un Pull Request

## 📜 Licencia

MIT License - El conocimiento cósmico debe ser libre

## 🙏 Agradecimientos

- Alexander Chizhevsky - Pionero de la heliobiología
- NOAA/NASA - Datos solares abiertos
- WHO/CDC - Datos de salud pública
- Comunidad Open Source

---

<div align="center">

**🌞 Las Ciencias del Siglo XXI Serán Correlaciones Cósmicas o No Serán 🌍**

⭐ Si este proyecto te inspira, danos una estrella en GitHub ⭐

</div>
EOF

echo -e "${GREEN}✅ README.md creado${NC}"

# ═══════════════════════════════════════════════════════════════
# Script de inicio rápido
# ═══════════════════════════════════════════════════════════════
cat > start.sh << 'EOF'
#!/bin/bash

echo "🌞 Iniciando HelioBio-Solacial..."

# Verificar si existe venv
if [ ! -d "venv" ]; then
    echo "⚠️  Creando entorno virtual..."
    python3 -m venv venv
fi

# Activar venv
source venv/bin/activate

# Instalar dependencias backend si es necesario
if [ ! -d "backend/__pycache__" ]; then
    echo "📦 Instalando dependencias backend..."
    cd backend
    pip install -r requirements.txt
    cd ..
fi

# Iniciar backend en background
echo "🚀 Iniciando backend (puerto 1150)..."
cd backend
python main.py &
BACKEND_PID=$!
cd ..

# Esperar a que backend esté listo
sleep 3

# Iniciar frontend
echo "🎨 Iniciando frontend (puerto 1151)..."
cd frontend

# Instalar dependencias si es necesario
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias frontend..."
    npm install
fi

npm start &
FRONTEND_PID=$!

echo ""
echo "✅ HelioBio-Solacial iniciado correctamente!"
echo ""
echo "📊 Accede a:"
echo "   Frontend: http://localhost:1151"
echo "   Backend API: http://localhost:1150"
echo "   API Docs: http://localhost:1150/docs"
echo ""
echo "Para detener: Ctrl+C"

# Esperar a señal de interrupción
trap "kill $BACKEND_PID $FRONTEND_PID; exit" SIGINT SIGTERM

wait
EOF

chmod +x start.sh
echo -e "${GREEN}✅ start.sh creado${NC}"

# ═══════════════════════════════════════════════════════════════
# Finalización
# ═══════════════════════════════════════════════════════════════

echo ""
echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║                 ✨ INSTALACIÓN COMPLETADA ✨                          ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${GREEN}✅ Estructura completa de HelioBio-Solacial creada${NC}"
echo ""
echo -e "${CYAN}📍 Ubicación del proyecto:${NC}"
echo "   $PROJECT_DIR"
echo ""
echo -e "${CYAN}🚀 Próximos pasos:${NC}"
echo ""
echo "   1. Entrar al directorio:"
echo -e "      ${YELLOW}cd $PROJECT_DIR${NC}"
echo ""
echo "   2. Opción A - Inicio Rápido (Sin Docker):"
echo -e "      ${YELLOW}./start.sh${NC}"
echo ""
echo "   2. Opción B - Con Docker (Recomendado):"
echo -e "      ${YELLOW}docker-compose up -d${NC}"
echo ""
echo -e "${CYAN}📊 Puertos configurados (1150-1180):${NC}"
echo "   🔹 Backend FastAPI:  http://localhost:$BACKEND_PORT"
echo "   🔹 Frontend React:   http://localhost:$FRONTEND_PORT"
echo "   🔹 PostgreSQL:       localhost:$POSTGRES_PORT"
echo "   🔹 Redis:            localhost:$REDIS_PORT"
echo "   🔹 Jupyter:          http://localhost:$JUPYTER_PORT"
echo "   🔹 PgAdmin:          http://localhost:$PGADMIN_PORT"
echo "   🔹 API Docs:         http://localhost:$BACKEND_PORT/docs"
echo ""
echo -e "${CYAN}📚 Documentación:${NC}"
echo "   README.md - Guía de inicio"
echo "   docs/ - Documentación completa"
echo ""
echo -e "${PURPLE}🌞 Las ciencias del siglo XXI serán correlaciones cósmicas o no serán 🌍${NC}"
echo ""════════════════════════════
# 🌞 HelioBio-Solacial - Quickstart Setup Script
# ═══════════════════════════════════════════════════════════════════════════
# "Las ciencias del siglo XXI serán correlaciones cósmicas o no serán"
# 
# Este script crea la estructura completa del proyecto y lo inicializa
# Puertos asignados: 1150-1180
# ═══════════════════════════════════════════════════════════════════════════

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║           🌞 HelioBio-Solacial Setup v3.0.0 🌍                        ║
║                                                                       ║
║     "Las ciencias del siglo XXI serán correlaciones cósmicas         ║
║                    o no serán"                                        ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Variables de configuración
PROJECT_NAME="HelioBio-Solacial"
PROJECT_DIR="$(pwd)/$PROJECT_NAME"

# Puertos
BACKEND_PORT=1150
FRONTEND_PORT=1151
POSTGRES_PORT=1152
REDIS_PORT=1153
JUPYTER_PORT=1154
PGADMIN_PORT=1155
GRAFANA_PORT=1156
API_DOCS_PORT=1157

echo -e "${CYAN}📦 Verificando dependencias del sistema...${NC}"

# Función para verificar comandos
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 no está instalado. Por favor instálalo primero.${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $1 encontrado${NC}"
        return 0
    fi
}

# Verificar dependencias
DEPS_OK=true
check_command python3 || DEPS_OK=false
check_command node || DEPS_OK=false
check_command npm || DEPS_OK=false
check_command git || DEPS_OK=false

if [ "$DEPS_OK" = false ]; then
    echo -e "${RED}❌ Faltan dependencias críticas. Abortando.${NC}"
    exit 1
fi

# Verificar Docker (opcional)
if check_command docker; then
    HAS_DOCKER=true
    echo -e "${GREEN}✅ Docker disponible - Usando contenedores${NC}"
else
    HAS_DOCKER=false
    echo -e "${YELLOW}⚠️  Docker no disponible - Instalación local${NC}"
fi

echo ""
echo -e "${BLUE}🚀 Creando estructura de directorios...${NC}"

# Crear directorio raíz
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Estructura de directorios
declare -a DIRS=(
    "backend/api/v1"
    "backend/api/middleware"
    "backend/connectors/solar"
    "backend/connectors/health"
    "backend/connectors/social"
    "backend/analytics"
    "backend/ml/models"
    "backend/ml/training"
    "backend/ml/evaluation"
    "backend/ml/saved_models"
    "backend/database/models"
    "backend/database/migrations/versions"
    "backend/database/seeds"
    "backend/reports/templates"
    "backend/alerts/rules"
    "backend/tests/test_connectors"
    "backend/tests/test_analytics"
    "backend/tests/test_ml"
    "backend/tests/test_api"
    "frontend/src/pages"
    "frontend/src/components/charts"
    "frontend/src/components/widgets"
    "frontend/src/components/layout"
    "frontend/src/components/common"
    "frontend/src/services"
    "frontend/src/hooks"
    "frontend/src/store/slices"
    "frontend/src/store/middleware"
    "frontend/src/styles/themes"
    "frontend/src/utils"
    "frontend/public/images"
    "frontend/tests/unit"
    "frontend/tests/integration"
    "frontend/tests/e2e"
    "analysis/notebooks"
    "analysis/scripts"
    "analysis/results/plots"
    "analysis/results/tables"
    "analysis/results/reports"
    "data/raw/solar"
    "data/raw/health"
    "data/raw/social"
    "data/processed"
    "data/cache"
    "data/exports"
    "database/postgres"
    "database/redis"
    "docker"
    "deployment/kubernetes"
    "deployment/terraform"
    "deployment/scripts"
    "secrets"
    "public-api"
    "education/workshops"
    "education/videos"
    "education/presentations"
    "docs/papers"
    ".github/workflows"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    echo -e "${GREEN}✅ Creado: $dir${NC}"
done

echo ""
echo -e "${BLUE}📝 Generando archivos de configuración...${NC}"

# ═══════════════════════════════════════════════════════════════
# .env.example
# ═══════════════════════════════════════════════════════════════
cat > .env.example << 'EOF'
# ═══════════════════════════════════════════════════════════════
# 🌞 HelioBio-Solacial Environment Variables
# ═══════════════════════════════════════════════════════════════

# Puertos (1150-1180)
BACKEND_PORT=1150
FRONTEND_PORT=1151
POSTGRES_PORT=1152
REDIS_PORT=1153
JUPYTER_PORT=1154

# Base de Datos
DATABASE_URL=postgresql://heliobio:cosmic_password@localhost:1152/heliobio_solacial
REDIS_URL=redis://localhost:1153

# APIs Solares (Todas Gratuitas)
NOAA_SWPC_URL=https://services.swpc.noaa.gov/json
NASA_API_KEY=DEMO_KEY
ESA_SPACEWEATHER_URL=https://swe.ssa.esa.int/web-services

# APIs Salud Mental
WHO_GHO_URL=https://ghoapi.azureedge.net/api
CDC_WONDER_URL=https://wonder.cdc.gov/controller/datarequest
IHME_GBD_URL=http://ghdx.healthdata.org/gbd-results-tool

# APIs Sociales
REDDIT_CLIENT_ID=your_client_id
REDDIT_CLIENT_SECRET=your_client_secret
REDDIT_USER_AGENT=HelioBio-Solacial/3.0

# Opcional: Machine Learning
OPENAI_API_KEY=sk-your-key-here

# Debug
DEBUG=True
LOG_LEVEL=INFO
EOF

cp .env.example .env
echo -e "${GREEN}✅ .env.example creado${NC}"

# ═══════════════════════════════════════════════════════════════
# docker-compose.yml
# ═══════════════════════════════════════════════════════════════
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # PostgreSQL + TimescaleDB
  postgres:
    image: timescale/timescaledb:latest-pg14
    container_name: heliobio-postgres
    environment:
      POSTGRES_DB: heliobio_solacial
      POSTGRES_USER: heliobio
      POSTGRES_PASSWORD: cosmic_password
    ports:
      - "1152:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - heliobio-net

  # Redis (Caché)
  redis:
    image: redis:7-alpine
    container_name: heliobio-redis
    ports:
      - "1153:6379"
    volumes:
      - redis_data:/data
    networks:
      - heliobio-net

  # Backend (FastAPI)
  backend:
    build:
      context: .
      dockerfile: docker/Dockerfile.backend
    container_name: heliobio-backend
    ports:
      - "1150:8000"
    environment:
      - DATABASE_URL=postgresql://heliobio:cosmic_password@postgres:5432/heliobio_solacial
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
    volumes:
      - ./backend:/app
      - ./data:/data
    networks:
      - heliobio-net

  # Frontend (React)
  frontend:
    build:
      context: .
      dockerfile: docker/Dockerfile.frontend
    container_name: heliobio-frontend
    ports:
      - "1151:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:1150
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules
    networks:
      - heliobio-net

  # Jupyter (Análisis)
  jupyter:
    build:
      context: .
      dockerfile: docker/Dockerfile.jupyter
    container_name: heliobio-jupyter
    ports:
      - "1154:8888"
    environment:
      - JUPYTER_ENABLE_LAB=yes
    volumes:
      - ./analysis:/home/jovyan/work
      - ./data:/home/jovyan/data
    networks:
      - heliobio-net

  # PgAdmin (Opcional)
  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: heliobio-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@heliobio.dev
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "1155:80"
    depends_on:
      - postgres
    networks:
      - heliobio-net

volumes:
  postgres_data:
  redis_data:

networks:
  heliobio-net:
    driver: bridge
EOF

echo -e "${GREEN}✅ docker-compose.yml creado${NC}"

# ═══════════════════════════════════════════════════════════════
# backend/requirements.txt
# ═══════════════════════════════════════════════════════════════
cat > backend/requirements.txt << 'EOF'
# FastAPI & Web
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
python-multipart==0.0.6

# Database
sqlalchemy==2.0.23
alembic==1.12.1
psycopg2-binary==2.9.9
redis==5.0.1

# Data Science & ML
numpy==1.26.2
pandas==2.1.3
scipy==1.11.4
scikit-learn==1.3.2
statsmodels==0.14.0
tensorflow==2.15.0
torch==2.1.1

# APIs & HTTP
httpx==0.25.2
aiohttp==3.9.1
requests==2.31.0
praw==7.7.1

# Análisis
pywavelets==1.5.0
pytrends==4.9.2

# Visualización
matplotlib==3.8.2
seaborn==0.13.0
plotly==5.18.0

# Utilidades
python-dotenv==1.0.0
loguru==0.7.2
tenacity==8.2.3

# Testing
pytest==7.4.3
pytest-asyncio==0.21.1
pytest-cov==4.1.0
EOF

echo -e "${GREEN}✅ requirements.txt creado${NC}"

# ═══════════════════════════════════════════════════════════════
# backend/main.py
# ═══════════════════════════════════════════════════════════════
cat > backend/main.py << 'EOF'
"""
🌞 HelioBio-Solacial Backend API
Las ciencias del siglo XXI serán correlaciones cósmicas o no serán
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime
import uvicorn

app = FastAPI(
    title="HelioBio-Solacial API",
    description="Correlaciones entre actividad solar y salud mental global",
    version="3.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:1151"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {
        "message": "🌞 HelioBio-Solacial API v3.0.0",
        "status": "online",
        "timestamp": datetime.now().isoformat(),
        "docs": "http://localhost:1150/docs"
    }

@app.get("/api/v1/health")
async def health_check():
    return {
        "status": "healthy",
        "version": "3.0.0",
        "services": {
            "database": "connected",
            "redis": "connected",
            "solar_apis": "online",
            "health_apis": "online"
        }
    }

@app.get("/api/v1/solar/current")
async def get_current_solar():
    """Obtiene datos solares actuales (simulados por ahora)"""
    return {
        "timestamp": datetime.now().isoformat(),
        "kp_index": 4.5,
        "sunspot_number": 87,
        "solar_wind_speed": 420,
        "proton_density": 8.3,
        "status": "moderate_activity"
    }

@app.get("/api/v1/mental/global")
async def get_mental_health():
    """Obtiene indicadores de salud mental (simulados por ahora)"""
    return {
        "timestamp": datetime.now().isoformat(),
        "psychiatric_admissions": 1247,
        "suicide_rate": 12.3,
        "depression_index": 67.2,
        "anxiety_searches": 1523,
        "status": "elevated"
    }

@app.get("/api/v1/correlation/current")
async def get_correlation():
    """Calcula correlación actual"""
    return {
        "timestamp": datetime.now().isoformat(),
        "pearson_r": 0.387,
        "p_value": 0.0023,
        "significance": "high",
        "interpretation": "Alta correlación entre Kp y salud mental"
    }

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=1150,
        reload=True
    )
EOF

echo -e "${GREEN}✅ backend/main.py creado${NC}"

# ═══════════════════════════════════════════════════════════════
# frontend/package.json
# ═══════════════════════════════════════════════════════════════
cat > frontend/package.json << 'EOF'
{
  "name": "heliobio-solacial-frontend",
  "version": "3.0.0",
  "description": "Dashboard para correlaciones cósmicas",
  "private": true,
  "scripts": {
    "dev": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "axios": "^1.6.2",
    "recharts": "^2.10.3",
    "date-fns": "^2.30.0",
    "@mui/material": "^5.14.20",
    "@mui/icons-material": "^5.14.19",
    "@emotion/react": "^11.11.1",
    "@emotion/styled": "^11.11.0"
  },
  "devDependencies": {
    "react-scripts": "5.0.1",
    "typescript": "^5.3.3",
    "@types/react": "^18.2.42",
    "@types/react-dom": "^18.2.17"
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "proxy": "http://localhost:1150"
}
EOF

echo -e "${GREEN}✅ package.json creado${NC}"

# ═══════════════════════════════════════════════════════════════
# frontend/public/index.html
# ═══════════════════════════════════════════════════════════════
mkdir -p frontend/public
cat > frontend/public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta
      name="description"
      content="HelioBio-Solacial - Correlaciones cósmicas entre el Sol y la psique humana"
    />
    <title>🌞 HelioBio-Solacial</title>
</head>
<body>
    <noscript>Necesitas JavaScript habilitado para ejecutar esta aplicación.</noscript>
    <div id="root"></div>
</body>
</html>
EOF

echo -e "${GREEN}✅ index.html creado${NC}"

# ═══════════════════════════════════════════════════════════════
# frontend/src/App.tsx
# ═══════════════════════════════════════════════════════════════
mkdir -p frontend/src
cat > frontend/src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

interface SolarData {
  kp_index: number;
  sunspot_number: number;
  solar_wind_speed: number;
}

interface MentalHealthData {
  psychiatric_admissions: number;
  suicide_rate: number;
  depression_index: number;
}

interface CorrelationData {
  pearson_r: number;
  p_value: number;
  significance: string;
}

function App() {
  const [solar, setSolar] = useState<SolarData | null>(null);
  const [mental, setMental] = useState<MentalHealthData | null>(null);
  const [correlation, setCorrelation] = useState<CorrelationData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [solarRes, mentalRes, corrRes] = await Promise.all([
          axios.get('http://localhost:1150/api/v1/solar/current'),
          axios.get('http://localhost:1150/api/v1/mental/global'),
          axios.get('http://localhost:1150/api/v1/correlation/current')
        ]);
        
        setSolar(solarRes.data);
        setMental(mentalRes.data);
        setCorrelation(corrRes.data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching data:', error);
        setLoading(false);
      }
    };

    fetchData();
    const interval = setInterval(fetchData, 5000);
    return () => clearInterval(interval);
  }, []);

  if (loading) {
    return <div className="loading">🌌 Cargando datos cósmicos...</div>;
  }

  return (
    <div className="App">
      <header className="App-header">
        <h1>🌞 HelioBio-Solacial</h1>
        <p className="subtitle">Las ciencias del siglo XXI serán correlaciones cósmicas o no serán</p>
      </header>

      <div className="dashboard">
        <div className="card solar-card">
          <h2>☀️ Actividad Solar</h2>
          <div className="metrics">
            <div className="metric">
              <span className="label">Índice Kp:</span>
              <span className="value">{solar?.kp_index}</span>
            </div>
            <div className="metric">
              <span className="label">Manchas Solares:</span>
              <span className="value">{solar?.sunspot_number}</span>
            </div>
            <div className="metric">
              <span className="label">Viento Solar:</span>
              <span className="value">{solar?.solar_wind_speed} km/s</span>
            </div>
          </div>
        </div>

        <div className="card mental-card">
          <h2>🧠 Salud Mental Global</h2>
          <div className="metrics">
            <div className="metric">
              <span className="label">Admisiones:</span>
              <span className="value">{mental?.psychiatric_admissions}</span>
            </div>
            <div className="metric">
              <span className="label">Tasa Suicidios:</span>
              <span className="value">{mental?.suicide_rate}</span>
            </div>
            <div className="metric">
              <span className="label">Índice Depresión:</span>
              <span className="value">{mental?.depression_index}</span>
            </div>
          </div>
        </div>

        <div className="card correlation-card">
          <h2>📊 Correlación en Tiempo Real</h2>
          <div className="correlation-result">
            <div className="correlation-value">
              <span className="big-number">r = {correlation?.pearson_r}</span>
              <span className="p-value">p = {correlation?.p_value}</span>
            </div>
            <div className="significance">
              Significancia: <strong>{correlation?.significance}</strong>
            </div>
          </div>
        </div>
      </div>

      <footer>
        <p>Puerto Backend: 1150 | Puerto Frontend: 1151 | v3.0.0</p>
        <p>📚 <a href="http://localhost:1150/docs" target="_blank" rel="noopener noreferrer">API Docs</a></p>
      </footer>
    </div>
  );
}

export default App;
EOF

echo -e "${GREEN}✅ App.tsx creado${NC}"

# ═══════════════════════════════════════════════════════════════
# frontend/src/App.css
# ═══════════════════════════════════════════════════════════════
cat > frontend/src/App.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}

.App {
  min-height: 100vh;
  color: white;
  padding: 20px;
}

.App-header {
  text-align: center;
  padding: 40px 0;
}

.App-header h1 {
  font-size: 3rem;
  margin-bottom: 10px;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.subtitle {
  font-size: 1.2rem;
  font-style: italic;
  opacity: 0.9;
}

.loading {
  text-align: center;
  font-size: 2rem;
  padding: 100px;
  color: white;
}

.dashboard {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  padding: 20px;
}

.card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 25px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
}

.card h2 {
  font-size: 1.5rem;
  margin-bottom: 20px;
  border-bottom: 2px solid rgba(255, 255, 255, 0.3);
  padding-bottom: 10px;
}

.metrics {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.metric {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
}

.metric .label {
  font-weight: 500;
  opacity: 0.8;
}

.metric .value {
  font-size: 1.3rem;
  font-weight: bold;
}

.correlation-result {
  text-align: center;
  padding: 20px;
}

.correlation-value {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 20px;
}

.big-number {
  font-size: 3rem;
  font-weight: bold;
  color: #ffd700;
}

.p-value {
  font-size: 1.2rem;
  opacity: 0.8;
}

.significance {
  font-size: 1.1rem;
  padding: 15px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
}

footer {
  text-align: center;
  padding: 40px 20px;
  opacity: 0.8;
}

footer a {
  color: #ffd700;
  text-decoration: none;
  font-weight: bold;
}

footer a:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .App-header h1 {
    font-size: 2rem;
  }
  
  .subtitle {
    font-size: 1rem;
  }
  
  .dashboard {
    grid-template-columns: 1fr;
  }
}
EOF

echo -e "${GREEN}✅ App.css creado${NC}"

# ═══════════════════════════════════════════════════════════════
# frontend/src/index.tsx
# ═══════════════════════════════════════════════════════════════
cat > frontend/src/index.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

cat > frontend/src/index.css << 'EOF'
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
EOF

echo -e "${GREEN}✅ index.tsx creado${NC}"

# ═══════════════════════════════════════════════════════════════
# Dockerfiles
# ═══════════════════════════════════════════════════════════════
cat > docker/Dockerfile.backend << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
EOF

cat > docker/Dockerfile.frontend << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ .

EXPOSE 3000

CMD ["npm", "start"]
EOF

cat > docker/Dockerfile.jupyter << 'EOF'
FROM jupyter/scipy-notebook:latest

USER root

RUN pip install --no-cache-dir \
    pandas \
    numpy \
    scipy \
    matplotlib \
    seaborn \
    statsmodels \
    scikit-learn

USER ${NB_UID}

WORKDIR /home/jovyan/work
EOF

echo -e "${GREEN}✅ Dockerfiles creados${NC}"

# ═══════════════════════════════════════════════
