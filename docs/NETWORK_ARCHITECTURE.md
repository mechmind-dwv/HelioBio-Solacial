# 🌐 HelioBio-Solacial - Arquitectura de Red y Puertos

## 📋 Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Asignación de Puertos](#asignación-de-puertos)
- [Topología de Red](#topología-de-red)
- [Flujo de Datos](#flujo-de-datos)
- [Seguridad](#seguridad)
- [Troubleshooting](#troubleshooting)
- [Escalabilidad](#escalabilidad)

---

## 🎯 Descripción General

HelioBio-Solacial utiliza un rango de puertos **1150-1180** para todos sus servicios. Esta estrategia de puertos tiene varios beneficios:

### ¿Por Qué 1150-1180?

1. **No Conflictivos**: Evita puertos comunes (80, 443, 3000, 8000, etc.)
2. **Rango Memorizable**: Fácil de recordar y gestionar
3. **Espacio para Crecer**: 31 puertos disponibles para expansión
4. **Aislamiento**: No interfiere con otros servicios del sistema
5. **Rangos Estándar**: Fuera de rangos privilegiados (<1024) y conocidos

### Principios de Diseño

- **Microservicios**: Cada servicio es independiente
- **Contenedorización**: Docker para aislamiento y portabilidad
- **Comunicación Interna**: Red privada Docker (172.25.0.0/16)
- **Comunicación Externa**: Solo puertos necesarios expuestos al host

---

## 🔢 Asignación de Puertos

### Puertos Activos (v3.0.0)

| Puerto | Servicio | Protocolo | Estado | Descripción |
|--------|----------|-----------|--------|-------------|
| **1150** | Backend API | HTTP | ✅ Activo | FastAPI REST API |
| **1151** | Frontend Dashboard | HTTP | ✅ Activo | React SPA |
| **1152** | PostgreSQL | TCP | ✅ Activo | Base de datos principal + TimescaleDB |
| **1153** | Redis | TCP | ✅ Activo | Cache y message broker |
| **1154** | Jupyter Notebooks | HTTP | ✅ Activo | Análisis científico interactivo |
| **1155** | PgAdmin | HTTP | ✅ Activo | Administración de PostgreSQL |
| **1156** | Grafana | HTTP | ✅ Activo | Dashboards de métricas |
| **1157** | Nginx | HTTP | ✅ Activo | Reverse proxy |
| **1158** | Nginx SSL | HTTPS | 🔄 Opcional | Reverse proxy seguro |
| **1159** | WebSocket Server | WS | ✅ Activo | Actualizaciones en tiempo real |
| **1160** | Prometheus | HTTP | ✅ Activo | Recolección de métricas |

### Puertos Reservados (Futuro)

| Puerto | Servicio Planeado | Estado | ETA |
|--------|-------------------|--------|-----|
| **1161** | Mobile API Gateway | 📅 Planeado | Q3 2025 |
| **1162** | ML Model Server | 📅 Planeado | Q2 2025 |
| **1163** | Backup Service | 📅 Planeado | Q4 2025 |
| **1164** | Alert Manager | 📅 Planeado | Q2 2025 |
| **1165** | Log Aggregator | 📅 Planeado | Q3 2025 |
| **1166-1180** | Reservados | 🔮 Por definir | TBD |

---

## 🏗️ Topología de Red

### Diagrama de Red Completo

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          HOST MACHINE                                   │
│                          (localhost)                                    │
└─────────────────────────────────────────────────────────────────────────┘
                                  │
                                  │ Port Mapping
                                  ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                     DOCKER NETWORK (heliobio-net)                       │
│                        Subnet: 172.25.0.0/16                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │                    CAPA DE PRESENTACIÓN                          │ │
│  ├──────────────────────────────────────────────────────────────────┤ │
│  │                                                                  │ │
│  │  📱 Frontend (1151)            🔒 Nginx (1157/1158)            │ │
│  │  IP: 172.25.0.21               IP: 172.25.0.25                  │ │
│  │  - React Dashboard             - Reverse Proxy                  │ │
│  │  - Material-UI                 - SSL Termination               │ │
│  │  - Recharts                    - Load Balancer                  │ │
│  │                                                                  │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                  │                                      │
│                                  ▼                                      │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │                    CAPA DE APLICACIÓN                            │ │
│  ├──────────────────────────────────────────────────────────────────┤ │
│  │                                                                  │ │
│  │  🚀 Backend API (1150)         📡 WebSocket (1159)             │ │
│  │  IP: 172.25.0.20               IP: 172.25.0.26                  │ │
│  │  - FastAPI                     - Socket.io                      │ │
│  │  - REST Endpoints              - Real-time Updates              │ │
│  │  - Business Logic              - Event Broadcasting             │ │
│  │                                                                  │ │
│  │  📊 Jupyter (1154)             🤖 ML Server (1162)*            │ │
│  │  IP: 172.25.0.22               IP: 172.25.0.32*                 │ │
│  │  - Notebooks                   - TensorFlow Serving*            │ │
│  │  - Analysis                    - Model Predictions*             │ │
│  │                                                                  │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                  │                                      │
│                                  ▼                                      │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │                    CAPA DE DATOS                                 │ │
│  ├──────────────────────────────────────────────────────────────────┤ │
│  │                                                                  │ │
│  │  🗄️ PostgreSQL (1152)         💾 Redis (1153)                  │ │
│  │  IP: 172.25.0.10               IP: 172.25.0.11                  │ │
│  │  - TimescaleDB                 - Cache Layer                    │ │
│  │  - Time Series Data            - Session Store                  │ │
│  │  - Relational Data             - Pub/Sub                        │ │
│  │                                                                  │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                  │                                      │
│                                  ▼                                      │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │                    CAPA DE MONITOREO                             │ │
│  ├──────────────────────────────────────────────────────────────────┤ │
│  │                                                                  │ │
│  │  📈 Grafana (1156)             📊 Prometheus (1160)            │ │
│  │  IP: 172.25.0.24               IP: 172.25.0.27                  │ │
│  │  - Visualización               - Metrics Collection             │ │
│  │  - Dashboards                  - Time Series DB                 │ │
│  │  - Alerting                    - Monitoring                     │ │
│  │                                                                  │ │
│  │  🔧 PgAdmin (1155)             🚨 AlertManager (1164)*         │ │
│  │  IP: 172.25.0.23               IP: 172.25.0.34*                 │ │
│  │  - DB Management               - Alert Routing*                 │ │
│  │  - Query Tool                  - Notifications*                 │ │
│  │                                                                  │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

* Servicios planeados para futuras versiones
```

### Asignación de IPs Internas

| Servicio | IP Interna | Puerto Interno | Puerto Externo |
|----------|------------|----------------|----------------|
| PostgreSQL | 172.25.0.10 | 5432 | 1152 |
| Redis | 172.25.0.11 | 6379 | 1153 |
| Backend | 172.25.0.20 | 8000 | 1150 |
| Frontend | 172.25.0.21 | 3000 | 1151 |
| Jupyter | 172.25.0.22 | 8888 | 1154 |
| PgAdmin | 172.25.0.23 | 80 | 1155 |
| Grafana | 172.25.0.24 | 3000 | 1156 |
| Nginx | 172.25.0.25 | 80 | 1157 |
| WebSocket | 172.25.0.26 | 8080 | 1159 |
| Prometheus | 172.25.0.27 | 9090 | 1160 |

---

## 🔄 Flujo de Datos

### 1. Flujo de Solicitud Usuario → Sistema

```
┌──────────┐
│ Usuario  │
└────┬─────┘
     │ http://localhost:1151
     ▼
┌──────────────┐
│ Frontend     │ Puerto 1151
│ (React)      │
└────┬─────────┘
     │ HTTP Request
     │ http://backend:8000/api/v1/*
     ▼
┌──────────────┐
│ Nginx        │ Puerto 1157 (opcional)
│ (Proxy)      │
└────┬─────────┘
     │ Forward
     ▼
┌──────────────┐
│ Backend API  │ Puerto 1150
│ (FastAPI)    │
└────┬─────────┘
     │
     ├─────────────────┐
     │                 │
     ▼                 ▼
┌──────────┐      ┌──────────┐
│ Redis    │      │ Postgres │
│ Cache    │      │ Database │
│ 1153     │      │ 1152     │
└──────────┘      └──────────┘
```

### 2. Flujo de Datos en Tiempo Real (WebSocket)

```
┌──────────────┐
│ Frontend     │ Puerto 1151
└────┬─────────┘
     │ ws://localhost:1159
     ▼
┌──────────────┐
│ WebSocket    │ Puerto 1159
│ Server       │
└────┬─────────┘
     │ Subscribe to Redis Pub/Sub
     ▼
┌──────────────┐
│ Redis        │ Port 1153
│ Pub/Sub      │
└────┬─────────┘
     │ Backend publishes updates
     ▼
┌──────────────┐
│ Backend API  │ Puerto 1150
└──────────────┘
```

### 3. Flujo de Análisis Científico

```
┌──────────────┐
│ Jupyter      │ Puerto 1154
│ Notebook     │
└────┬─────────┘
     │ Read Data
     ▼
┌──────────────┐
│ PostgreSQL   │ Puerto 1152
│ TimescaleDB  │
└────┬─────────┘
     │ Time Series Query
     ▼
┌──────────────┐
│ Analysis     │
│ - Correlación│
│ - Granger    │
│ - Wavelets   │
└──────────────┘
```

### 4. Flujo de Monitoreo

```
┌──────────────┐
│ All Services │
└────┬─────────┘
     │ Expose /metrics
     ▼
┌──────────────┐
│ Prometheus   │ Puerto 1160
│ Scraping     │
└────┬─────────┘
     │ Store Time Series
     ▼
┌──────────────┐
│ Grafana      │ Puerto 1156
│ Visualization│
└──────────────┘
```

---

## 🔒 Seguridad

### Principios de Seguridad por Capas

#### 1. Capa de Red

```yaml
# docker-compose.yml
networks:
  heliobio-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.25.0.0/16
    driver_opts:
      com.docker.network.bridge.enable_icc: "true"
      com.docker.network.bridge.enable_ip_masquerade: "true"
```

**Características**:
- Red privada aislada del host
- Comunicación inter-contenedor sin exponer puertos
- NAT para acceso externo controlado

#### 2. Puertos Expuestos

Solo los puertos necesarios están expuestos al host:

```bash
# Puertos públicos (accesibles desde host)
1150 - Backend API (requiere autenticación)
1151 - Frontend (público)
1154 - Jupyter (requiere token)
1155 - PgAdmin (requiere login)
1156 - Grafana (requiere login)
1157 - Nginx (público)
1159 - WebSocket (requiere token)
1160 - Prometheus (opcional: solo localhost)

# Puertos privados (solo red interna)
PostgreSQL: 5432 (mapeado a 1152)
Redis: 6379 (mapeado a 1153)
```

#### 3. Autenticación y Autorización

**Backend API (1150)**:
```python
# JWT Authentication
from fastapi import Security, HTTPException
from fastapi.security import HTTPBearer

security = HTTPBearer()

@app.get("/api/v1/protected")
async def protected_route(token: str = Security(security)):
    if not verify_token(token):
        raise HTTPException(status_code=401)
    return {"data": "protected"}
```

**Redis (1153)**:
```bash
# Contraseña requerida
requirepass cosmic_redis_2025
```

**PostgreSQL (1152)**:
```sql
-- Usuario con permisos limitados
CREATE USER heliobio_reader WITH PASSWORD 'secure_password';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO heliobio_reader;
```

#### 4. Firewall Configuration

**UFW (Ubuntu)**:
```bash
# Permitir solo rango HelioBio
sudo ufw allow 1150:1180/tcp

# Bloquear todo lo demás
sudo ufw default deny incoming
sudo ufw enable
```

**firewalld (CentOS/RHEL)**:
```bash
# Zona personalizada para HelioBio
sudo firewall-cmd --permanent --new-zone=heliobio
sudo firewall-cmd --permanent --zone=heliobio --add-port=1150-1180/tcp
sudo firewall-cmd --reload
```

#### 5. SSL/TLS (Producción)

**Nginx con Let's Encrypt**:
```nginx
server {
    listen 1158 ssl http2;
    server_name heliobio.yourdomain.com;

    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://backend:8000;
    }
}
```

### Checklist de Seguridad

- [ ] Cambiar todas las contraseñas por defecto en `.env`
- [ ] Habilitar autenticación JWT en Backend
- [ ] Configurar CORS restrictivo
- [ ] Habilitar SSL/TLS en producción
- [ ] Configurar firewall (UFW/firewalld)
- [ ] Implementar rate limiting en Nginx
- [ ] Rotar logs regularmente
- [ ] Auditorías de seguridad mensuales
- [ ] Backups automáticos de PostgreSQL
- [ ] Monitoreo de intentos de acceso

---

## 🐛 Troubleshooting

### Problemas Comunes

#### 1. Puerto Ocupado

**Error**:
```
Error starting userland proxy: listen tcp 0.0.0.0:1150: bind: address already in use
```

**Solución**:
```bash
# Identificar proceso
sudo lsof -i :1150

# Matar proceso
sudo kill -9 <PID>

# O usar el script
./configure_ports.sh
```

#### 2. No Puede Conectar a PostgreSQL

**Error**:
```
sqlalchemy.exc.OperationalError: could not connect to server
```

**Solución**:
```bash
# Verificar que PostgreSQL está corriendo
docker-compose ps postgres

# Ver logs
docker-compose logs postgres

# Reiniciar servicio
docker-compose restart postgres

# Verificar conectividad
docker-compose exec backend pg_isready -h postgres -p 5432
```

#### 3. Frontend No Carga

**Error**: Pantalla en blanco en localhost:1151

**Solución**:
```bash
# Ver logs del frontend
docker-compose logs frontend

# Verificar variables de entorno
docker-compose exec frontend env | grep REACT_APP

# Reconstruir
docker-compose up -d --build frontend
```

#### 4. WebSocket Disconnects

**Error**: Conexión WebSocket se cierra constantemente

**Solución**:
```bash
# Aumentar timeout en nginx
# docker/nginx.conf
proxy_read_timeout 3600s;
proxy_send_timeout 3600s;

# Verificar Redis
docker-compose exec redis redis-cli ping
```

### Comandos de Diagnóstico

```bash
# Estado de todos los servicios
docker-compose ps

# Uso de recursos
docker stats

# Logs en tiempo real
docker-compose logs -f --tail=100

# Conectividad de red
docker-compose exec backend ping postgres
docker-compose exec backend ping redis

# Verificar DNS interno
docker-compose exec backend nslookup postgres

# Test de API
curl http://localhost:1150/api/v1/health

# Test de WebSocket
wscat -c ws://localhost:1159
```

### Logs Importantes

```bash
# Backend API
docker-compose logs backend | grep ERROR

# PostgreSQL
docker-compose logs postgres | grep FATAL

# Nginx
docker-compose logs nginx | grep error

# Exportar logs
docker-compose logs > heliobio-logs-$(date +%Y%m%d).txt
```

---

## 🚀 Escalabilidad

### Escenarios de Crecimiento

#### 1. Escalado Horizontal (Docker Swarm)

```yaml
# docker-compose.swarm.yml
version: '3.8'

services:
  backend:
    image: heliobio/backend:latest
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
    ports:
      - target: 8000
        published: 1150
        mode: host
```

**Configuración Load Balancer**:
```nginx
# docker/nginx.conf
upstream backend_cluster {
    least_conn;
    server backend_1:8000;
    server backend_2:8000;
    server backend_3:8000;
}

server {
    listen 1157;
    location /api/ {
        proxy_pass http://backend_cluster;
    }
}
```

#### 2. Escalado Vertical (Recursos)

```yaml
# docker-compose.yml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          cpus: '1.0'
          memory: 2G
  
  postgres:
    deploy:
      resources:
        limits:
          cpus: '4.0'
          memory: 8G
        reservations:
          cpus: '2.0'
          memory: 4G
```

#### 3. Kubernetes Deployment

```yaml
# deployment/kubernetes/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: heliobio-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: heliobio/backend:3.0.0
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: heliobio-secrets
              key: database-url
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  type: LoadBalancer
  ports:
  - port: 1150
    targetPort: 8000
  selector:
    app: backend
```

#### 4. Particionamiento de Base de Datos

```sql
-- PostgreSQL Partitioning por fecha
CREATE TABLE solar_data (
    timestamp TIMESTAMPTZ NOT NULL,
    kp_index FLOAT,
    sunspot_number INT,
    ...
) PARTITION BY RANGE (timestamp);

-- Particiones mensuales
CREATE TABLE solar_data_2025_01 PARTITION OF solar_data
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE solar_data_2025_02 PARTITION OF solar_data
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

-- Índices por partición
CREATE INDEX ON solar_data_2025_01 (timestamp DESC);
```

### Puertos Adicionales para Microservicios

A medida que el proyecto crece, puedes agregar servicios especializados:

```
1161 - Mobile API Gateway
1162 - ML Model Server (TensorFlow Serving)
1163 - Backup Service
1164 - Alert Manager
1165 - Log Aggregator (ELK)
1166 - Message Queue (RabbitMQ)
1167 - Cache Layer (Memcached)
1168 - Search Engine (Elasticsearch)
1169 - Object Storage (MinIO)
1170 - CDN Origin
```

---

## 📚 Referencias

### Documentación Oficial

- [Docker Networking](https://docs.docker.com/network/)
- [FastAPI Deployment](https://fastapi.tiangolo.com/deployment/)
- [PostgreSQL Port Configuration](https://www.postgresql.org/docs/current/runtime-config-connection.html)
- [Nginx Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)

### Herramientas Recomendadas

- **Portainer**: Gestión visual de contenedores Docker
- **Traefik**: Reverse proxy alternativo con auto-configuración
- **Consul**: Service discovery para microservicios
- **Vault**: Gestión de secretos

### Comandos de Emergencia

```bash
# Detener todo inmediatamente
docker-compose kill

# Reinicio completo
docker-compose down && docker-compose up -d

# Limpiar todo (¡CUIDADO!)
docker-compose down -v --remove-orphans
docker system prune -a

# Backup de PostgreSQL
docker-compose exec postgres pg_dump -U heliobio heliobio_solacial > backup.sql

# Restaurar PostgreSQL
docker-compose exec -T postgres psql -U heliobio heliobio_solacial < backup.sql
```

---

## 📞 Soporte

Si encuentras problemas con la configuración de red:

1. Ejecuta: `./configure_ports.sh` para diagnosticar
2. Revisa logs: `docker-compose logs`
3. Consulta Issues: https://github.com/mechmind-dwv/HelioBio-Solacial/issues
4. Discord: https://discord.gg/heliobio

---

<div align="center">

**🌞 HelioBio-Solacial - Arquitectura de Red v3.0.0 🌍**

*Las ciencias del siglo XXI serán correlaciones cósmicas o no serán*

</div>
