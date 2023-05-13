#!/bin/bash


# Variáveis
SERVICE_NAME=ecs-nodejs-app-dev
CLUSTER_NAME=ecs-nodejs-app-dev
JSON_FILE=service.json
DELETE=false


# Verifica se o serviço já existe
SERVICE_EXISTS=$(aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER_NAME} --query 'length(services)' | tr -d '\n')
echo "aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER_NAME} --query 'length(services)' | tr -d '\n'"
if [[ ${SERVICE_EXISTS} -gt 0 ]]; then
  # Serviço existe
    echo "O Serviço ${SERVICE_NAME} existe..."
  if [[ ${DELETE} == true ]]; then
    # Excluir serviço
    echo "Excluindo serviço ${SERVICE_NAME}..."
    aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${SERVICE_NAME}  --desired-count 0 --force-new-deployment
    sleep 10
    aws ecs delete-service --service ${SERVICE_NAME} --cluster ${CLUSTER_NAME}
    echo "Serviço ${SERVICE_NAME} excluído com sucesso."
  else
    # Atualizar serviço
    echo "Atualizando serviço ${SERVICE_NAME}..."

    aws ecs update-service --service ${SERVICE_NAME} --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --desired-count $(jq -r '.desired_count' ${JSON_FILE}) --task-definition $(jq -r '.task_definition' ${JSON_FILE}) --platform-version $(jq -r '.platform_version' ${JSON_FILE}) --health-check-grace-period-seconds $(jq -r '.health_check_grace_period_seconds' ${JSON_FILE}) --deployment-configuration maximumPercent=$(jq -r '.deployment_configuration.maximumPercent' ${JSON_FILE}),minimumHealthyPercent=$(jq -r '.deployment_configuration.minimumHealthyPercent' ${JSON_FILE})
    echo "Serviço ${SERVICE_NAME} atualizado com sucesso."
  fi
else
  # Serviço não existe
  echo "Criando serviço ${SERVICE_NAME}..."
  ./deploy.sh
  #aws ecs create-service --service-name ${SERVICE_NAME} --cluster ${CLUSTER_NAME} --cli-input-json file://${JSON_FILE}
  echo "Serviço ${SERVICE_NAME} criado com sucesso."
fi
