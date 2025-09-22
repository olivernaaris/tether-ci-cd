# Docker Build Instructions

This generic Dockerfile can be used across all Node.js services in the project. Use build arguments to customize the behavior for each service.

## Build Arguments

- `NODE_ENV`: Environment (production/development) - default: production
- `WORKER_TYPE`: Type of worker to run - default: wrk-node-http
- `PORT`: Port to expose - default: 3000
- `DEBUG`: Enable debug mode - default: false

## Building and Running Each Service

### app-node (HTTP Service)

**Build:**
```bash
docker build \
  --build-arg NODE_ENV=development \
  --build-arg WORKER_TYPE=wrk-node-http \
  --build-arg PORT=3000 \
  --build-arg DEBUG=false \
  -t app-node:latest \
  -f Dockerfile \
  ./app-node
```

**Run:**
```bash
docker run -p 3000:3000 app-node:latest
```

**With custom configuration:**
```bash
docker run -p 3000:3000 \
  -e ORK_RPC_KEY="your-ork-rpc-key" \
  -e SIGN_UP_SECRET="your-signup-secret" \
  app-node:latest \
  node worker.js --wtype wrk-node-http --env production --port 3000
```

### wrk-ork (Orchestrator)

**Build:**
```bash
docker build \
  --build-arg NODE_ENV=development \
  --build-arg WORKER_TYPE=wrk-ork-proc-aggr \
  --build-arg PORT=3001 \
  --build-arg DEBUG=true \
  -t wrk-ork:latest \
  -f Dockerfile \
  ./wrk-ork
```

**Run:**
```bash
docker run -p 3001:3001 \
  -e CLUSTER_NUMBER=1 \
  wrk-ork:latest \
  node worker.js --wtype wrk-ork-proc-aggr --env development --cluster 1
```

### wrk-book (Book Management)

**Build:**
```bash
docker build \
  --build-arg NODE_ENV=development \
  --build-arg WORKER_TYPE=wrk-book-rack \
  --build-arg PORT=3002 \
  --build-arg DEBUG=true \
  -t wrk-book:latest \
  -f Dockerfile \
  ./wrk-book
```

**Run:**
```bash
docker run -p 3002:3002 \
  -e RACK_ID=25d0c2e5-3d14-4975-bddf-b836bdf3842a \
  wrk-book:latest \
  node worker.js --wtype wrk-book-rack --env development --debug true --rack 25d0c2e5-3d14-4975-bddf-b836bdf3842a
```

### wrk-base (Base Service)

**Build:**
```bash
docker build \
  --build-arg NODE_ENV=production \
  --build-arg WORKER_TYPE=base-wrk \
  --build-arg PORT=3003 \
  --build-arg DEBUG=false \
  -t wrk-base:latest \
  -f Dockerfile \
  ./wrk-base
```

**Run:**
```bash
docker run -p 3003:3003 wrk-base:latest
```

### tpl-wrk-thing (Template Service)

**Build:**
```bash
docker build \
  --build-arg NODE_ENV=development \
  --build-arg WORKER_TYPE=tpl-thing-wrk \
  --build-arg PORT=3004 \
  --build-arg DEBUG=true \
  -t tpl-wrk-thing:latest \
  -f Dockerfile \
  ./tpl-wrk-thing
```

**Run:**
```bash
docker run -p 3004:3004 tpl-wrk-thing:latest
```
