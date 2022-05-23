# Install dependencies only when needed
FROM node:16-alpine as deps

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat

ARG dotenv
ARG token

WORKDIR /app

COPY . .
COPY package*.json .

# Refs
# - https://simbathesailor.dev/github-packages/
RUN echo //npm.pkg.github.com/:_authToken=$token >> .npmrc
RUN echo @ebrain-lab:registry=https://npm.pkg.github.com/ >> .npmrc

## Install build toolchain, install node deps and compile native add-ons
# https://github.com/npm/cli/issues/3847
# RUN npm install -g npm@7.18.1
RUN npm ci
RUN rm -f .npmrc


# base
FROM node:16-alpine as builder

# will be development, staging, production
ARG dotenv
# will be aaa, bbb...
ARG package
ARG token
ARG sha


WORKDIR /app

COPY --from=deps /app/package*.json .
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/packages ./packages

WORKDIR /app/packages/${package}

RUN cp .env.${dotenv} .env.production.local

RUN echo //npm.pkg.github.com/:_authToken=$token >> .npmrc
RUN echo @ebrain-lab:registry=https://npm.pkg.github.com/ >> .npmrc

RUN npm ci
RUN npm run build
RUN rm -f .npmrc


# release
FROM node:16-alpine as release
WORKDIR /app

ARG package
ARG dotenv
ARG token
ARG sha
ARG root=packages/${package}

# ENV NODE_ENV ${environment}

COPY --from=builder /app/${root}/.next ./.next
COPY --from=builder /app/${root}/public ./public
COPY --from=builder /app/${root}/.env ./
COPY --from=builder /app/${root}/.env.${dotenv} ./.env.production.local
COPY --from=builder /app/${root}/next.config.js ./
COPY --from=builder /app/${root}/package*.json ./

RUN echo //npm.pkg.github.com/:_authToken=$token >> .npmrc
RUN echo @ebrain-lab:registry=https://npm.pkg.github.com/ >> .npmrc

# TODO:
# 배포 타겟에 맞는 환경 변수를 가져갈 수 있도록 개선
# COPY --from=build /app/.env.production ./env.production
# COPY .env .env.${environment} next.config.js package.json package-lock.json ./
RUN npm install --only=production
RUN rm -f .npmrc

EXPOSE 3000
CMD [ "npm", "start" ]
