#
# ===============LICENSE_START======================================================= Acumos ===================================================================================
#	Copyright (C) 2019 Nordix Foundation ===================================================================================
#	This Acumos software file is distributed by Nordix Foundation
#	under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
#	This file is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License. ===============LICENSE_END=========================================================
#	-->

FROM node:10-alpine

# Installs latest Chromium (73) package.
RUN apk update && apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge=~73.0.3683.103 \
      nss@edge \
      freetype@edge \
      freetype-dev@edge \
      harfbuzz@edge \
      ttf-freefont@edge

# This line is to tell karma-chrome-launcher where
# chromium was downloaded and installed to.
ENV CHROME_BIN /usr/bin/chromium-browser

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true


# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app/ \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser

# Create app directory
WORKDIR /app

# Install Puppeteer under /node_modules so it's available system-wide
COPY package*.json /app/

# # Puppeteer v1.12.2 works with Chromium 73.
RUN npm install
