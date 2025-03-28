FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/alexandrunastase/json-formatter-live.git && \
    cd json-formatter-live && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /json-formatter-live
COPY --from=base /git/json-formatter-live .
RUN npm install && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /json-formatter-live/dist .
