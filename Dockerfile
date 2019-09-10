FROM alpine:3.7 as build

RUN apk --update add curl bash

ENV HUGO_VERSION 0.46
ENV HUGO_DL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
RUN curl -fsSL ${HUGO_DL} | tar xvz -C /usr/local/bin

COPY . /app
WORKDIR /app
RUN hugo

FROM scratch as deploy

# Copy only the public files over to the final image. This way any secrets you
# may require while building will not be in the final image
COPY --from=build /app/public /public
