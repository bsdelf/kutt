FROM node:20-slim as builder

RUN node -v

# Setting working directory.
WORKDIR /work
COPY . /work
RUN npm install
RUN npm run build

FROM node:20-slim
WORKDIR /app
COPY --from=builder /work/package.json /work/package-lock.json ./
COPY --from=builder /work/knexfile.ts ./
COPY --from=builder /work/dist ./dist
COPY --from=builder /work/server ./server
COPY --from=builder /work/node_modules/ ./node_modules

EXPOSE 3000

# Running the app
CMD [ "npm", "start" ]