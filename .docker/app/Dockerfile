FROM ruby:3.4.4-alpine

ENV RAILS_ENV=development
ENV APP_PATH=/app

# Installation des dépendances système nécessaires
# build-base: gcc, make, etc.
# postgresql-dev: headers pour la gem pg
# libffi-dev, yaml-dev, zlib-dev: souvent requis pour diverses gems
# gcompat: pour la compatibilité avec certaines gems compilées pour glibc
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    tzdata \
    git \
    libffi-dev \
    yaml-dev \
    zlib-dev \
    gcompat

# Mise à jour de Rubygems et Bundler
RUN gem update --system && gem update bundler

WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock ./
RUN bundle install


# Copier le script d'entrypoint avant le reste
COPY .docker/app/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

COPY . .

ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]