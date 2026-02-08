# Take-Home Technical Challenge - Rails API

![Coverage](https://img.shields.io/badge/coverage-99%25-brightgreen)

API REST construite avec Ruby on Rails et Grape pour gérer des opérations de chiffrement, déchiffrement, signature et vérification.

## 📋 Prérequis

- Ruby 3.4+
- PostgreSQL 14+
- Docker & Docker Compose (optionnel mais recommandé)

## 🚀 Installation

### Option 1 : Avec Docker (Recommandé)

```bash
# Cloner le repository
git clone <repository-url>
cd take-home

# Copier le fichier d'environnement
cp .env.dist .env

# Démarrer les services
docker compose up -d

# Créer et initialiser la base de données
docker compose run app bin/rails db:create db:migrate

# Installer les hooks pre-commit
docker compose run app bundle exec overcommit --install
```

### Option 2 : Installation locale

```bash
# Cloner le repository
git clone <repository-url>
cd take-home

# Installer les dépendances
bundle install

# Copier le fichier d'environnement
cp .env.dist .env

# Créer et initialiser la base de données
bin/rails db:create db:migrate

# Installer les hooks pre-commit
bundle exec overcommit --install
```

## 🔧 Configuration Pre-commit

Ce projet utilise **Overcommit** pour gérer les hooks Git et garantir la qualité du code.

### Installation des hooks

Après avoir cloné le projet et installé les dépendances :

```bash
bundle exec overcommit --install
```

### Vérifications automatiques

À chaque commit, les vérifications suivantes sont effectuées :

- ✅ **RuboCop** - Vérification du style de code
- ✅ **RSpec** - Exécution des tests
- ✅ **TrailingWhitespace** - Détection des espaces en fin de ligne
- ✅ **Conventional Commits** - Validation du format des messages de commit

### Format des messages de commit

Les messages de commit doivent suivre le format **Conventional Commits** :

```
<type>(<scope>): <subject>
```

**Types autorisés :**
- `feat` - Nouvelle fonctionnalité
- `fix` - Correction de bug
- `docs` - Documentation
- `style` - Formatage
- `refactor` - Refactoring
- `perf` - Performance
- `test` - Tests
- `chore` - Maintenance
- `build` - Build
- `ci` - CI/CD
- `revert` - Annulation

**Exemples :**
```bash
git commit -m "feat(api): add encryption endpoint"
git commit -m "fix(database): resolve connection timeout"
git commit -m "docs: update README with setup instructions"
```

📚 **Documentation complète** : Voir [docs/PRE_COMMIT.md](docs/PRE_COMMIT.md)

## 🧪 Tests

```bash
# Avec Docker
docker compose run app bundle exec rspec

# En local
bundle exec rspec

# Avec couverture de code
COVERAGE=true bundle exec rspec
```

## 🎨 Linting

```bash
# Vérifier le style de code
bundle exec rubocop

# Auto-correction
bundle exec rubocop -a

# Vérifier la sécurité
bundle exec brakeman
bundle exec bundler-audit
```

## 🏃 Démarrage du serveur

### Avec Docker

```bash
docker compose up
```

L'API sera accessible sur `http://localhost:3000`

### En local

```bash
bin/rails server
```

L'API sera accessible sur `http://localhost:3000`

## 📚 Documentation API

La documentation Swagger est disponible à l'adresse :

```
http://localhost:3000/swagger
```

## 🏗️ Structure du projet

```
.
├── app/
│   ├── api/              # API Grape
│   │   └── api/
│   │       ├── base.rb   # Configuration de base
│   │       └── v1/       # Endpoints v1
│   └── interactions/     # Business logic (ActiveInteraction)
├── config/
│   ├── database.yml      # Configuration BDD
│   └── initializers/     # Initialiseurs Rails
├── db/
│   ├── migrate/          # Migrations
│   └── schema.rb         # Schéma de la BDD
├── spec/                 # Tests RSpec
│   ├── integration/      # Tests d'intégration
│   └── unit/             # Tests unitaires
├── .overcommit.yml       # Configuration pre-commit
└── docker-compose.yml    # Configuration Docker
```

## 🔐 Variables d'environnement

Copiez `.env.dist` vers `.env` et configurez les variables suivantes :

```bash
# Base de données
DATABASE_HOST=db
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=password

# Rails
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

## 🐳 Commandes Docker utiles

```bash
# Démarrer les services
docker compose up -d

# Voir les logs
docker compose logs -f app

# Accéder au conteneur
docker compose run app bash

# Console Rails
docker compose run app bin/rails console

# Reset database
docker compose run app rails db:drop

# Init database
docker compose run app rails db:create db:migrate db:seed

# Run tests
docker compose run app rails db:test:prepare test
docker compose run app rspec

# Arrêter les services
docker compose down

# Nettoyer tout (volumes inclus)
docker compose down -v --remove-orphans
```

