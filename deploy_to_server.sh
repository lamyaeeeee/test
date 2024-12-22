#!/bin/bash

# je définis les variables nécessaires pour l'exécution du script.
DOCKER_USERNAME="lamyae237"
DOCKER_PASSWORD="$DOCKER_PASSWORD_ENV"
DOCKER_IMAGE_NAME="lamyae_app"
DOCKER_IMAGE_TAG="latest"
REMOTE_SERVER="192.168.157.129"
REMOTE_SSH_USER="lamyae"

# je construis l'image Docker
echo "Construction de l'image Docker en cours..."
docker build -t ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .

# connexion à DockerHub
echo "Connexion à DockerHub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# je pousse l'image vers DockerHub
echo "Envoi de l'image sur DockerHub..."
docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

# déployer l'image sur le serveur distant
echo "Déploiement de l'image Docker sur le serveur distant..."
ssh ${REMOTE_SSH_USER}@${REMOTE_SERVER} << EOF
echo "Récupération de l'image Docker depuis DockerHub..."
docker pull ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
echo "Arrêt et suppression des conteneurs existants, le cas échéant..."
docker stop ${DOCKER_IMAGE_NAME} || true
docker rm ${DOCKER_IMAGE_NAME} || true
 echo "Lancement du nouveau conteneur..."
docker run -d --name ${DOCKER_IMAGE_NAME} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
EOF

# confirmation que le déploiement est terminé.
echo "Déploiement terminé avec succès."
