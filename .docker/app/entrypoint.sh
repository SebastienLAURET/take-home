#!/bin/sh
set -e

# Vérification des dépendances
echo "Vérification des gems..."
bundle check || bundle install

# Attente de la base de données si DATABASE_HOST est défini
if [ -n "$DATABASE_HOST" ]; then
  echo "Attente de la base de données sur $DATABASE_HOST:5432..."
  while ! nc -z "$DATABASE_HOST" 5432; do
    sleep 0.1
  done
  echo "Base de données prête !"
fi

# Supprimer le fichier pid du serveur s'il existe
rm -f /app/tmp/pids/server.pid

# Exécuter la commande passée au container (par défaut ce qu'il y a dans CMD)
exec "$@"
