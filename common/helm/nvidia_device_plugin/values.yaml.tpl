nodeSelector:
  "node-type": "gpu"

tolerations:
  - key: "nvidia.com/gpu"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  - key: "gpu-memory"
    operator: "Exists"
    effect: "NoSchedule"
  - key: "gpu-type"
    operator: "Exists"
    effect: "NoSchedule"