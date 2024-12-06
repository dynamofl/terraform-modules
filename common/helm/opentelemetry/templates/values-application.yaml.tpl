config:
  exporters:
    debug: {}
    prometheus:
      endpoint: 0.0.0.0:8889
      metric_expiration: 60m
      resource_to_telemetry_conversion:
        enabled: true
      send_timestamps: true
  extensions:
    health_check: {}
  processors:
    batch: {}
  receivers:
    otlp:
      protocols:
        http:
          endpoint: 0.0.0.0:4318
  service:
    extensions:
    - health_check
    pipelines:
      metrics:
        exporters:
        - debug
        - prometheus
        processors:
        - memory_limiter
        - batch
        receivers:
        - otlp
      traces:
        exporters:
        - debug
        processors:
        - memory_limiter
        - batch
        receivers:
        - otlp
fullnameOverride: opentelemetry-collector-application
image:
  repository: ${image_repository}
  tag: ${image_tag}
mode: deployment
podAnnotations:
  metrics_type: application
ports:
  prometheus:
    containerPort: 8889
    enabled: true
    hostPort: 8889
    protocol: TCP
    servicePort: 8889
presets:
  kubernetesAttributes:
    enabled: true
resources:
  limits:
    cpu: 250m
    memory: 400Mi
  requests:
    cpu: 250m
    memory: 400Mi