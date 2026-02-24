#!/bin/bash

# Script para construir y ejecutar la aplicación con Docker
# Uso: ./docker-build.sh [opción]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables - TODO: Update these for your project
IMAGE_NAME="my-app-api"
IMAGE_TAG="latest"
CONTAINER_NAME="my-app-api"
PORT="5050"

echo -e "${GREEN}=== .NET Clean CQRS API - Docker Build Script ===${NC}"
echo ""

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [opción]"
    echo ""
    echo "Opciones:"
    echo "  build       - Construir la imagen Docker"
    echo "  run         - Ejecutar el contenedor"
    echo "  stop        - Detener el contenedor"
    echo "  logs        - Ver logs del contenedor"
    echo "  clean       - Limpiar contenedores e imágenes"
    echo "  help        - Mostrar esta ayuda"
    echo ""
}

# Función para construir la imagen
build_image() {
    echo -e "${YELLOW}Construyendo imagen Docker...${NC}"
    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
    echo -e "${GREEN}✓ Imagen construida exitosamente${NC}"
}

# Función para ejecutar el contenedor
run_container() {
    echo -e "${YELLOW}Ejecutando contenedor...${NC}"

    # Detener contenedor existente si está corriendo
    if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
        echo -e "${YELLOW}Deteniendo contenedor existente...${NC}"
        docker stop ${CONTAINER_NAME}
        docker rm ${CONTAINER_NAME}
    fi

    # Ejecutar nuevo contenedor
    docker run -d \
        --name ${CONTAINER_NAME} \
        -p ${PORT}:8080 \
        -e ASPNETCORE_ENVIRONMENT=Development \
        ${IMAGE_NAME}:${IMAGE_TAG}

    echo -e "${GREEN}✓ Contenedor iniciado${NC}"
    echo -e "${GREEN}  Swagger: http://localhost:${PORT}/swagger${NC}"
    echo -e "${GREEN}  Health: http://localhost:${PORT}/health${NC}"
}

# Función para detener el contenedor
stop_container() {
    echo -e "${YELLOW}Deteniendo contenedor...${NC}"
    if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
        docker stop ${CONTAINER_NAME}
        docker rm ${CONTAINER_NAME}
        echo -e "${GREEN}✓ Contenedor detenido${NC}"
    else
        echo -e "${RED}No hay contenedor corriendo${NC}"
    fi
}

# Función para ver logs
show_logs() {
    echo -e "${YELLOW}Mostrando logs...${NC}"
    docker logs -f ${CONTAINER_NAME}
}

# Función para limpiar
clean() {
    echo -e "${YELLOW}Limpiando contenedores e imágenes...${NC}"

    # Detener y eliminar contenedor
    if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
        docker stop ${CONTAINER_NAME} 2>/dev/null || true
        docker rm ${CONTAINER_NAME} 2>/dev/null || true
    fi

    # Eliminar imagen
    docker rmi ${IMAGE_NAME}:${IMAGE_TAG} 2>/dev/null || true

    echo -e "${GREEN}✓ Limpieza completada${NC}"
}

# Procesar argumentos
case "${1}" in
    build)
        build_image
        ;;
    run)
        run_container
        ;;
    stop)
        stop_container
        ;;
    logs)
        show_logs
        ;;
    clean)
        clean
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Opción inválida: ${1}${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}=== Completado ===${NC}"

