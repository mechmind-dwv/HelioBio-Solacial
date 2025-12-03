#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# 🌞 HelioBio-Solacial - Port Configuration & Verification Script
# ═══════════════════════════════════════════════════════════════════════════
# Verifica y configura los puertos 1150-1180 para el proyecto
# Uso: ./configure_ports.sh [start_port] [end_port]
# Ejemplo: ./configure_ports.sh 1150 1180
# ═══════════════════════════════════════════════════════════════════════════

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║           🌞 HelioBio-Solacial Port Configuration 🌍                 ║
║                                                                       ║
║              Verificando puertos 1150-1180...                        ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Configuración por defecto
START_PORT=${1:-1150}
END_PORT=${2:-1180}

# Servicios asignados
declare -A SERVICES=(
    [1150]="Backend FastAPI"
    [1151]="Frontend React"
    [1152]="PostgreSQL + TimescaleDB"
    [1153]="Redis Cache"
    [1154]="Jupyter Notebooks"
    [1155]="PgAdmin"
    [1156]="Grafana"
    [1157]="API Docs Mirror"
    [1158]="Mobile API Gateway"
    [1159]="WebSocket Server"
    [1160]="Metrics Collector"
)

echo -e "${CYAN}📊 Configuración de Puertos:${NC}"
echo "   Rango: $START_PORT - $END_PORT"
echo "   Total puertos: $((END_PORT - START_PORT + 1))"
echo ""

# Función para verificar si un puerto está en uso
check_port() {
    local port=$1
    
    if command -v lsof &> /dev/null; then
        # En sistemas con lsof
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            return 0  # Puerto en uso
        else
            return 1  # Puerto libre
        fi
    elif command -v netstat &> /dev/null; then
        # En sistemas con netstat
        if netstat -tuln | grep -q ":$port "; then
            return 0  # Puerto en uso
        else
            return 1  # Puerto libre
        fi
    elif command -v ss &> /dev/null; then
        # En sistemas con ss (más moderno)
        if ss -tuln | grep -q ":$port "; then
            return 0  # Puerto en uso
        else
            return 1  # Puerto libre
        fi
    else
        echo -e "${YELLOW}⚠️  No se puede verificar puertos (instala lsof, netstat o ss)${NC}"
        return 2  # No se puede verificar
    fi
}

# Función para obtener proceso usando un puerto
get_process() {
    local port=$1
    
    if command -v lsof &> /dev/null; then
        lsof -i :$port -sTCP:LISTEN | tail -n +2 | awk '{print $1, $2}'
    else
        echo "Desconocido"
    fi
}

# Array para almacenar puertos problemáticos
declare -a OCCUPIED_PORTS=()
declare -a FREE_PORTS=()

echo -e "${BLUE}🔍 Escaneando puertos...${NC}"
echo ""

# Escanear todos los puertos en el rango
for port in $(seq $START_PORT $END_PORT); do
    service_name="${SERVICES[$port]:-Reservado para futuro}"
    
    if check_port $port; then
        # Puerto ocupado
        OCCUPIED_PORTS+=($port)
        process_info=$(get_process $port)
        echo -e "${RED}❌ Puerto $port [OCUPADO]${NC} - $service_name"
        echo -e "   Proceso: $process_info"
    else
        # Puerto libre
        FREE_PORTS+=($port)
        echo -e "${GREEN}✅ Puerto $port [LIBRE]${NC} - $service_name"
    fi
done

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}📈 RESUMEN DEL ESCANEO:${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "   Total puertos escaneados: $((END_PORT - START_PORT + 1))"
echo -e "   ${GREEN}Puertos libres: ${#FREE_PORTS[@]}${NC}"
echo -e "   ${RED}Puertos ocupados: ${#OCCUPIED_PORTS[@]}${NC}"
echo ""

# Si hay puertos ocupados, mostrar detalles
if [ ${#OCCUPIED_PORTS[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️  PUERTOS OCUPADOS DETECTADOS:${NC}"
    echo ""
    for port in "${OCCUPIED_PORTS[@]}"; do
        service_name="${SERVICES[$port]:-Puerto reservado}"
        echo -e "   🔴 Puerto $port - $service_name"
    done
    echo ""
    echo -e "${YELLOW}💡 SOLUCIONES POSIBLES:${NC}"
    echo ""
    echo "   1. Liberar puertos ocupados:"
    echo "      # Ver procesos:"
    echo "      sudo lsof -i :PORT_NUMBER"
    echo ""
    echo "      # Matar proceso (con cuidado!):"
    echo "      sudo kill -9 PID"
    echo ""
    echo "   2. Cambiar configuración de puertos:"
    echo "      Editar .env y cambiar variables:"
    echo "      BACKEND_PORT=XXXX"
    echo "      FRONTEND_PORT=YYYY"
    echo ""
    echo "   3. Usar Docker (aísla puertos):"
    echo "      docker-compose up -d"
    echo ""
    
    # Preguntar si quiere liberar puertos automáticamente
    echo -e "${CYAN}¿Deseas intentar liberar los puertos automáticamente? (requiere sudo)${NC}"
    read -p "   [y/N]: " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🔧 Liberando puertos...${NC}"
        
        for port in "${OCCUPIED_PORTS[@]}"; do
            echo -e "   Procesando puerto $port..."
            
            if command -v lsof &> /dev/null; then
                pids=$(lsof -t -i:$port -sTCP:LISTEN)
                
                if [ ! -z "$pids" ]; then
                    echo -e "   Matando procesos: $pids"
                    sudo kill -9 $pids 2>/dev/null || echo "   ⚠️  No se pudo matar proceso"
                    
                    # Verificar si se liberó
                    sleep 1
                    if ! check_port $port; then
                        echo -e "   ${GREEN}✅ Puerto $port liberado${NC}"
                    else
                        echo -e "   ${RED}❌ Puerto $port sigue ocupado${NC}"
                    fi
                fi
            fi
        done
        
        echo ""
        echo -e "${GREEN}✅ Proceso de liberación completado${NC}"
        echo -e "${CYAN}Ejecuta de nuevo este script para verificar${NC}"
    fi
else
    echo -e "${GREEN}🎉 ¡TODOS LOS PUERTOS ESTÁN LIBRES!${NC}"
    echo ""
    echo -e "${CYAN}✨ Puedes iniciar HelioBio-Solacial con:${NC}"
    echo ""
    echo "   Opción 1 - Docker (recomendado):"
    echo -e "   ${YELLOW}docker-compose up -d${NC}"
    echo ""
    echo "   Opción 2 - Local:"
    echo -e "   ${YELLOW}./start.sh${NC}"
    echo ""
fi

# Generar archivo de configuración de puertos
echo -e "${BLUE}📝 Generando archivo de configuración...${NC}"

cat > ports.config << EOF
# ═══════════════════════════════════════════════════════════════
# HelioBio-Solacial - Configuración de Puertos
# Generado: $(date)
# ═══════════════════════════════════════════════════════════════

# Puertos principales
BACKEND_PORT=1150
FRONTEND_PORT=1151
POSTGRES_PORT=1152
REDIS_PORT=1153
JUPYTER_PORT=1154

# Puertos adicionales
PGADMIN_PORT=1155
GRAFANA_PORT=1156
API_DOCS_PORT=1157
MOBILE_API_PORT=1158
WEBSOCKET_PORT=1159
METRICS_PORT=1160

# Estado de puertos (últimamente escaneado)
# Libres: ${#FREE_PORTS[@]}
# Ocupados: ${#OCCUPIED_PORTS[@]}

EOF

echo -e "${GREEN}✅ Archivo ports.config creado${NC}"

# Verificar firewall (solo en Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo ""
    echo -e "${BLUE}🔥 Verificando configuración de firewall...${NC}"
    
    if command -v ufw &> /dev/null; then
        if sudo ufw status | grep -q "Status: active"; then
            echo -e "${YELLOW}⚠️  UFW firewall está activo${NC}"
            echo ""
            echo "   Para permitir el rango de puertos:"
            echo -e "   ${CYAN}sudo ufw allow $START_PORT:$END_PORT/tcp${NC}"
            echo ""
            
            read -p "   ¿Abrir puertos en firewall ahora? [y/N]: " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                sudo ufw allow $START_PORT:$END_PORT/tcp
                echo -e "${GREEN}✅ Puertos abiertos en firewall${NC}"
            fi
        else
            echo -e "${GREEN}✅ UFW firewall desactivado${NC}"
        fi
    elif command -v firewall-cmd &> /dev/null; then
        echo -e "${YELLOW}⚠️  Firewalld detectado${NC}"
        echo ""
        echo "   Para permitir el rango de puertos:"
        echo -e "   ${CYAN}sudo firewall-cmd --permanent --add-port=$START_PORT-$END_PORT/tcp${NC}"
        echo -e "   ${CYAN}sudo firewall-cmd --reload${NC}"
    else
        echo -e "${GREEN}✅ No se detectó firewall activo${NC}"
    fi
fi

# Crear script de prueba de conectividad
echo ""
echo -e "${BLUE}🧪 Generando script de prueba...${NC}"

cat > test_ports.sh << 'EOF'
#!/bin/bash

# Script de prueba de conectividad para HelioBio-Solacial

echo "🧪 Probando conectividad de servicios..."
echo ""

# Función para probar HTTP
test_http() {
    local port=$1
    local name=$2
    
    if command -v curl &> /dev/null; then
        if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 2 http://localhost:$port > /dev/null 2>&1; then
            echo "✅ $name (puerto $port) - RESPONDIENDO"
        else
            echo "❌ $name (puerto $port) - NO RESPONDE"
        fi
    else
        echo "⚠️  curl no instalado, no se puede probar HTTP"
        return
    fi
}

# Función para probar TCP
test_tcp() {
    local port=$1
    local name=$2
    
    if timeout 2 bash -c "cat < /dev/null > /dev/tcp/localhost/$port" 2>/dev/null; then
        echo "✅ $name (puerto $port) - ACCESIBLE"
    else
        echo "❌ $name (puerto $port) - NO ACCESIBLE"
    fi
}

# Probar servicios HTTP
test_http 1150 "Backend API"
test_http 1151 "Frontend Dashboard"
test_http 1154 "Jupyter Notebooks"
test_http 1155 "PgAdmin"

# Probar servicios TCP
test_tcp 1152 "PostgreSQL"
test_tcp 1153 "Redis"

echo ""
echo "Prueba completada. Si hay errores, verifica que los servicios estén corriendo."
EOF

chmod +x test_ports.sh
echo -e "${GREEN}✅ Script test_ports.sh creado${NC}"

# Resumen final
echo ""
echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║                    ✨ CONFIGURACIÓN COMPLETADA ✨                     ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}📁 Archivos generados:${NC}"
echo "   ✅ ports.config - Configuración de puertos"
echo "   ✅ test_ports.sh - Script de prueba de conectividad"
echo ""

echo -e "${CYAN}🚀 Próximos pasos:${NC}"
echo "   1. Revisa ports.config para ver la configuración"
echo "   2. Inicia los servicios con docker-compose o ./start.sh"
echo "   3. Prueba la conectividad con ./test_ports.sh"
echo ""

echo -e "${GREEN}🌞 HelioBio-Solacial está listo para despegar 🌍${NC}"
echo ""
