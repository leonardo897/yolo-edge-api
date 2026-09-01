#!/bin/bash

echo "========================================"
echo "Deploy — $(date)"
echo "========================================"

echo "[INFO] Imagem atual: yolo-api-yolo-api"

# [1/4] Baixando nova imagem
echo "[1/4] Baixando nova imagem..."
docker compose pull
python3 -m dvc pull models/yolo-epi.pt

docker pull ghcr.io/***897/yolo-edge-api/yolo-api:latest

# [2/4] Parar e remover containers antigos
echo "[2/4] Parando containers antigos..."
docker compose up -d --build

docker stop yolo-api 2>/dev/null || echo "Container yolo-api não está rodando"
docker rm yolo-api 2>/dev/null || echo "Container yolo-api não existe"
docker stop yolo-client 2>/dev/null || echo "Container yolo-client não está rodando"
docker rm yolo-client 2>/dev/null || echo "Container yolo-client não existe"

# [3/4] Iniciando novos containers
echo "[3/4] Iniciando nova versão..."
docker run -d \
  --name yolo-api \
  --restart unless-stopped \
  -p 8000:8000 \
  ghcr.io/***897/yolo-edge-api/yolo-api:latest

docker run -d \
  --name yolo-client \
  --restart unless-stopped \
  ghcr.io/***897/yolo-edge-api/yolo-client:latest

# [4/4] Verificar status
echo "[4/4] Verificando status..."
docker ps | grep yolo

echo "Deploy concluído!"
