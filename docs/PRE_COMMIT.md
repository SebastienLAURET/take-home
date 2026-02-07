# Pre-commit Hooks

Ce projet utilise [Overcommit](https://github.com/sds/overcommit) pour gérer les hooks Git et assurer la qualité du code avant chaque commit.

## Installation

Les hooks sont automatiquement installés lors du `bundle install`. Si vous devez les réinstaller manuellement :

```bash
bundle exec overcommit --install
```

## Vérifications effectuées

### Pre-commit (avant chaque commit)

1. **RuboCop** - Vérification du style de code Ruby
   - Exécute : `bundle exec rubocop`
   - Corrige automatiquement : `bundle exec rubocop -a`

2. **RSpec** - Exécution des tests
   - Exécute : `bundle exec rspec`
   - Assure que tous les tests passent avant le commit

3. **TrailingWhitespace** - Détection des espaces en fin de ligne

4. **ForbiddenBranches** - Empêche les commits directs sur :
   - `main`
   - `master`
   - `develop`

### Commit Message (validation du message de commit)

Le format **Conventional Commits** est obligatoire :

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

#### Types autorisés :
- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation uniquement
- `style`: Changements de formatage (espaces, virgules, etc.)
- `refactor`: Refactoring du code
- `perf`: Amélioration des performances
- `test`: Ajout ou modification de tests
- `chore`: Tâches de maintenance
- `build`: Changements du système de build
- `ci`: Changements de la CI
- `revert`: Annulation d'un commit précédent

#### Exemples valides :
```bash
git commit -m "feat(api): add user authentication endpoint"
git commit -m "fix(database): resolve connection timeout issue"
git commit -m "docs: update README with installation steps"
git commit -m "test(api): add integration tests for root endpoint"
```

#### Exemples invalides :
```bash
git commit -m "Added new feature"  # ❌ Pas de type
git commit -m "WIP"                # ❌ Pas de format
git commit -m "fix bug"            # ❌ Pas de scope (optionnel mais recommandé)
```

## Contourner les hooks (à utiliser avec précaution)

Si vous devez absolument contourner les hooks (déconseillé) :

```bash
git commit --no-verify -m "message"
```

⚠️ **Attention** : Contourner les hooks peut introduire du code de mauvaise qualité dans le dépôt.

## Désactiver temporairement un hook

Éditez `.overcommit.yml` et mettez `enabled: false` pour le hook concerné.

## Mettre à jour la configuration

Après avoir modifié `.overcommit.yml` :

```bash
bundle exec overcommit --sign
```

## Dépannage

### Les hooks ne s'exécutent pas

```bash
bundle exec overcommit --install
```

### Voir quels hooks sont installés

```bash
bundle exec overcommit --list-hooks
```

### Exécuter les hooks manuellement

```bash
bundle exec overcommit --run
```
