FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/alexandrunastase/json-formatter-live.git && \
    cd json-formatter-live && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:18-alpine AS build

WORKDIR /json-formatter-live
COPY --from=base /git/json-formatter-live .
RUN npm install && \
    npm run build

FROM pierrezemb/gostatic

COPY --from=build /json-formatter-live/build /srv/http
EXPOSE 8043
