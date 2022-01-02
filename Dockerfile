################### multi-stage dockerfile ####################
########### Part one:  install dependencies (Install dependencies only when needed) ############
### In container deps ###
FROM node:alpine AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
# Create app directory as workdir
WORKDIR /app
######### install dependencies ############
# Using general npm
COPY package.json package-lock.json ./
RUN npm install
# Using yarn from official document
# COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile

########### Part two:  Rebuild the source code only when needed ############
### second container builder ###
FROM node:alpine AS builder
WORKDIR /app

COPY . .
COPY --from=deps /app/node_modules ./node_modules
RUN npm run build && npm install --production --ignore-scripts --prefer-offline

########### Part three:  Production image, copy all the files and run next ############
### last container, the production image ###
FROM node:alpine AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# You only need to copy next.config.js if you are NOT using the default configuration
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER nextjs
# container should expose the port number
EXPOSE 5000

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry.
ENV NEXT_TELEMETRY_DISABLED 1

# run 
CMD ["npm","run","start"]





################ Extra #################
# docker dive commands to reduce image size
# docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -e DOCKER_API_VERSION=1.41 wagoodman/dive:latest e5da73dcdc8c