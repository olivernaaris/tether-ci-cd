# Observability

This document provides an overview of the observability setup, which uses Prometheus for metrics collection and Grafana for visualization.

## Architecture

The observability stack consists of three main components running as Docker containers:

1.  **`app-node` Service**: The application that exposes its metrics.
2.  **Prometheus**: A time-series database that scrapes and stores the metrics.
3.  **Grafana**: A visualization tool that queries Prometheus to display metrics in dashboards.

These services are orchestrated using `docker-compose.yml`.

---

## How It Works

### 1. Metrics Exposition (`app-node`)

The `app-node` service is responsible for generating and exposing application-specific metrics.

-   **Implementation**: The logic is located in [`services/app-node/workers/lib/server.js`](services/app-node/workers/lib/server.js:255).
-   **Mechanism**: It uses the `prom-client` library to create a dedicated HTTP server. This server listens on a specific port (e.g., `9001`) and exposes a `/metrics` endpoint.
-   **Initialization**: The metrics server is started by the `startMetricsServer` function, which is called when the main `WrkNodeHttp` worker starts up in [`services/app-node/workers/http.node.wrk.js`](services/app-node/workers/http.node.wrk.js:68).
-   **Example Metric**: A sample `Gauge` metric named `app_node_health_status` is registered to track the health of the service.

### Architectural Note on Metrics Server

A separate HTTP server is initialized for metrics to provide greater control over its network configuration as `svc-facs-httpd` is a custom framework that has limited configuration options.

### 2. Metrics Collection (Prometheus)

Prometheus is configured to automatically discover and scrape the metrics exposed by the `app-node` service.

-   **Configuration**: The setup is defined in [`observability/prometheus.yml`](observability/prometheus.yml).
-   **Scrape Job**: A job named `app-node` is configured to scrape the `/metrics` endpoint of the `app-node` container at its internal Docker network address (`app-node:9001`).
-   **Storage**: Prometheus stores these metrics in its time-series database, making them available for querying.

```yaml
# observability/prometheus.yml
scrape_configs:
  - job_name: 'app-node'
    metrics_path: /metrics
    static_configs:
      - targets: ['app-node:9001']
```

### 3. Metrics Visualization (Grafana)

Grafana is used to create dashboards for visualizing the metrics collected by Prometheus.

-   **Integration**: As defined in [`docker-compose.yml`](docker-compose.yml), Grafana is provisioned with a pre-configured data source pointing to the Prometheus container.
-   **Data Source**: The configuration in [`observability/grafana/datasource.yml`](observability/grafana/datasource.yml) tells Grafana how to connect to Prometheus.
-   **Dashboards**: Once set up, you can access the Grafana UI (by default at `http://localhost:9191`) to build dashboards using the PromQL query language to visualize metrics from the `app-node` service.

---

## Local Setup

1.  **Run Services**: Start all services, including Prometheus and Grafana, using Docker Compose:
    ```bash
    docker compose up --build
    ```

2.  **Access Prometheus**: You can view the Prometheus UI and scraped targets at [http://localhost:9090](http://localhost:9090).

3.  **Access Grafana**: The Grafana UI is available at [http://localhost:9191](http://localhost:9191).