global: 
  dynamoguardnamespace: "${dynamoguard_namespace}"
  apiDomain: "${api_domain}"
  keycloakDomain: "${keycloak_domain}"
  uiDomain: "${ui_domain}"
  storageClass: "${storage_class}"
  storageClassName: "${storage_class}"
  config:
    common: dynamoai-core-common-config
    proxy: dynamoai-core-proxy-config
    api: dynamoai-api-config
  fullNameOverride: dynamoai
  nameOverride: dynamoai
  secrets:
    common: dynamoai-core-common-secret
    mongodb: dynamoai-core-mongodb-secret
    postgres: dynamoai-core-postgres-secret
    redis: dynamoai-redis-redis-secret
    apikeys: dynamoai-core-apikeys-secret
  serviceAccount:
    name: dynamoai-service-account
  metricsServer:
    address: "dynamoai-metrics-server.${dynamoguard_namespace}.svc.cluster.local:9090"

dynamoai-api:
  enabled: true
  dynamoai-common:
    ##########################################################
    # Jobs
    ##########################################################
    job:
      enabled: true
      # List of jobs, with job names as the outer block.
      jobs:
        db-migrations-job:
          image:
            repository: docker.io/db-migrations
            tag: 'dynamoai-3.18.4'
            digest: '' # if set to a non empty value, digest takes precedence on the tag
            pullPolicy: IfNotPresent
          env: 
            KEYCLOAK_BASE_URL:
              value: "{{ .Values.global.keycloakDomain }}"
            PG_DB_HOST:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: host
            PG_DB_NAME:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: name
            PG_DB_USERNAME:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: username
            PG_DB_PASSWORD:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: password
            PG_DB_PORT:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: port
            KEYCLOAK_DB_HOST:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: host
            KEYCLOAK_DB_NAME:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: keycloakDbName
            KEYCLOAK_DB_USERNAME:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: username
            KEYCLOAK_DB_PASSWORD:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: password
            KEYCLOAK_DB_PORT:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: port
            IS_KEYCLOAK_ENABLED:
              value: '{{ if eq .Values.authProvider "keycloak" }}true{{ else }}false{{ end }}'
            DB_MIGRATION_JOB_NAME:
              value: "db-migrations-job"
          backoffLimit: 4
          restartPolicy: "OnFailure"
    ##########################################################
    # Deployment
    ##########################################################
    deployment:
      enabled: true
      # Image of the app container
      replicas: 3
      image:
        repository: docker.io/dynamoai-api
        tag: 'dynamoai-3.18.4'
        digest: '' # if set to a non empty value, digest takes precedence on the tag
        pullPolicy: Always
      resources:
        limits:
          cpu: 500m
          ephemeral-storage: 1024Mi
          memory: 700Mi
        requests:
          cpu: 250m
          ephemeral-storage: 1024Mi
          memory: 500Mi
      env: 
        PROJECTS_BUCKET:
          value: "dynamoai-prod-projects"
        PORT:
          value: "{{ (index .Values.deployment.ports 0).containerPort }}"
        IS_AUDIT_LOGGING_ENABLED:
          value: "true"
        POD_NAME:
          valueFrom:
            fieldRef:
              fieldPath: 'metadata.name'
        NAMESPACE:
          valueFrom:
            fieldRef:
              fieldPath: 'metadata.namespace'
        PG_DB_HOST:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: host
        PG_DB_NAME:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: name
        PG_DB_USERNAME:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: username
        PG_DB_PASSWORD:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: password
        PG_DB_PORT:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: port
        KEYCLOAK_DB_HOST:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: host
        KEYCLOAK_DB_NAME:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: keycloakDbName
        KEYCLOAK_DB_USERNAME:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: username
        KEYCLOAK_DB_PASSWORD:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: password
        KEYCLOAK_DB_PORT:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.postgres }}"
              key: port
        IS_KEYCLOAK_ENABLED:
          value: '{{ if eq .Values.authProvider "keycloak" }}true{{ else }}false{{ end }}'
        API_AUTH_MODE:
          value: "keycloak-and-key"
        PROJECTS_BUCKET:
          value: dynamoai-uat-projects
        KEYCLOAK_REALM:
          value: dynamo-ai
        KEYCLOAK_API_CLIENT_ID:
          value: api
        KEYCLOAK_API_CLIENT_UUID:
          value: 1319a712-6308-440f-a584-24fa9cc6bc0d
        IS_KEYCLOAK_AUTHORIZATION_ENABLED:
          value: "true"
        KEYCLOAK_BASE_URL:
          value: "{{ .Values.global.keycloakDomain }}"
        KEYCLOAK_API_CLIENT_SECRET:
          value: g9ooZUkCOaiHfrnCBPvkrUQejSJfMd9p
        JOB_COMPUTE_KIND:
          value: "k8s"
        KC_HEALTH_ENABLED:
          value: "true"
        DB_MIGRATION_JOB_NAME:
          value: "db-migrations-job"
        DB_HOST:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.mongodb }}"
              key: host
        DB_USERNAME:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.mongodb }}"
              key: username
        DB_PASSWORD:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.mongodb }}"
              key: password
        DB_PORT:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.mongodb }}"
              key: port
        OPENAI_API_KEY:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.common }}"
              key: openai_api_key
        DEFAULT_USER_PASSWORD:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.common }}"
              key: defaultUserPassword
        DEFAULT_USER_EMAIL:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.common }}"
              key: defaultUserEmail
        DEFAULT_USER_API_KEY:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.common }}"
              key: defaultUserApiKey
        PLATFORM_ADMIN_PASSWORD:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.common }}"
              key: platformAdminPassword
        LICENSE:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.common }}"
              key: license
        SERVICE_USER_API_KEY_MAP:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.common }}"
              key: serviceUserApiKeyMap
        REDIS_HOST:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.redis }}"
              key: host
        REDIS_PORT:
          valueFrom:
            secretKeyRef:
              name: "{{ .Values.global.secrets.redis }}"
              key: port
        TEST_REPORT_GENERATION_ENABLED:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: testReportGenerationEnabled
        REMOTE_MODEL_CONFIG_VALIDATION_API_ENABLED:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: remoteModelConfigValidationApiEnabled
        HUGGINGFACE_API_REQUESTS_ENABLED:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: huggingfaceApiRequestsEnabled
        RATE_LIMIT_DYNAMO_GUARD:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: rateLimitDynamoGuard
        RATE_LIMIT_DYNAMO_EVAL:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: rateLimitDynamoEval
        PBAC_SAFETY_MODE_ENABLED:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: pbacSafetyModeEnabled
        COGNITO_USER_POOL_ID:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: cognitoUserPoolId
        COGNITO_CLIENT_ID:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: cognitoClientId
        PENTEST_BUCKET:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: bucketName
        CORS_RULE:
          value: "allow-all"
        OTEL_APPLICATION_METRICS_ENDPOINT:
          value: "http://opentelemetry-collector-application.opentelemetry.svc.cluster.local:4318/v1/metrics"
        OTEL_APPLICATION_TRACES_ENDPOINT:
          value: "http://opentelemetry-collector-application.opentelemetry.svc.cluster.local:4318/v1/traces"
        IS_TOKEN_BILLING_ENABLED:
          value: "false"
        NODE_ENV:
          value: "production"
        AWS_DEFAULT_REGION:
          value: "{{ .Values.global.awsRegion }}"
        MODERATOR_WORKER_ASYNC_ENDPOINT:
          value: '{{ include "dynamoai.fullname" . }}-moderation.{{ if and .Values.global.dynamoguardnamespace (ne .Values.global.dynamoguardnamespace "") }}{{ .Values.global.dynamoguardnamespace }}{{ else }}{{ .Release.Namespace }}{{ end }}.svc.cluster.local:2344'
      # Init containers which runs before the app container
      initContainers:
        init-checkers:
          image: docker.io/init-checkers:dynamoai-3.18.4
          imagePullPolicy: IfNotPresent
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: 'metadata.name'
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: 'metadata.namespace'
            - name: DB_MIGRATION_JOB_NAME
              value: 'db-migrations-job'
            - name: IS_KEYCLOAK_ENABLED
              value: '{{ if eq .Values.authProvider "keycloak" }}true{{ else }}false{{ end }}'
            - name: KEYCLOAK_DB_HOST
              valueFrom:
                secretKeyRef:
                  key: host
                  name: 'dynamoai-core-postgres-secret'
            - name: KEYCLOAK_DB_NAME
              valueFrom:
                secretKeyRef:
                  key: keycloakDbName
                  name: 'dynamoai-core-postgres-secret'
            - name: KEYCLOAK_DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: password
                  name: 'dynamoai-core-postgres-secret'
            - name: KEYCLOAK_DB_PORT
              valueFrom:
                secretKeyRef:
                  key: port
                  name: 'dynamoai-core-postgres-secret'
            - name: KEYCLOAK_DB_USERNAME
              valueFrom:
                secretKeyRef:
                  key: username
                  name: 'dynamoai-core-postgres-secret'
            - name: PG_DB_HOST
              valueFrom:
                secretKeyRef:
                  key: host
                  name: 'dynamoai-core-postgres-secret'
            - name: PG_DB_NAME
              valueFrom:
                secretKeyRef:
                  key: name
                  name: 'dynamoai-core-postgres-secret'
            - name: PG_DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: password
                  name: 'dynamoai-core-postgres-secret'
            - name: PG_DB_PORT
              valueFrom:
                secretKeyRef:
                  key: port
                  name: 'dynamoai-core-postgres-secret'
            - name: PG_DB_USERNAME
              valueFrom:
                secretKeyRef:
                  key: username
                  name: 'dynamoai-core-postgres-secret'
            - name: PROJECTS_BUCKET
              value: dynamoai-uat-projects
            - name: KEYCLOAK_REALM
              value: dynamo-ai
            - name: KEYCLOAK_API_CLIENT_ID
              value: api
            - name: KEYCLOAK_API_CLIENT_UUID
              value: 1319a712-6308-440f-a584-24fa9cc6bc0d
            - name: IS_KEYCLOAK_AUTHORIZATION_ENABLED
              value: "true"
            - name: KEYCLOAK_BASE_URL
              value: "{{ .Values.global.keycloakDomain }}"
            - name: KEYCLOAK_API_CLIENT_SECRET
              value: g9ooZUkCOaiHfrnCBPvkrUQejSJfMd9p
            - name: "API_AUTH_MODE"
              value: "keycloak-and-key"
            - name: JOB_COMPUTE_KIND
              value: "k8s"
            - name: KC_HEALTH_ENABLED
              value: "true"
    
    ##########################################################
    # ScaledJobs
    ##########################################################
    scaledJobs:
      enabled: false
      # List of jobs, with job names as the outer block.
      jobs:
        offline-secure-token-billing:
          image:
            repository: docker.io/billing
            tag: 'c283ff50f'
            digest: '' # if set to a non empty value, digest takes precedence on the tag
            pullPolicy: IfNotPresent
          pollingInterval: 10
          minReplicaCount: 0
          maxReplicaCount: 100
          successfulJobsHistoryLimit: 3
          failedJobsHistoryLimit: 2
          triggers:
            external:
              metadata:
                scalerAddress: "{{ $.Values.global.metricsServer.address }}"
                listName: "billing"
                listLength: '1'
          resources:
            requests:
              cpu: '200m'
              memory: '256Mi'
            limits:
              cpu: '300m'
              memory: '512Mi'
          config:
            cpu: 
              - "1"
          env:
            POD_NAME:
              valueFrom:
                fieldRef:
                  fieldPath: 'metadata.name'
            NAMESPACE:
              valueFrom:
                fieldRef:
                  fieldPath: 'metadata.namespace'
            DB_HOST:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.mongodb }}"
                  key: host
            DB_USERNAME:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.mongodb }}"
                  key: username
            DB_PASSWORD:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.mongodb }}"
                  key: password
            DB_PORT:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.mongodb }}"
                  key: port
            PG_DB_HOST:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: host
            PG_DB_NAME:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: keycloakDbName
            PG_DB_USERNAME:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: username
            PG_DB_PASSWORD:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: password
            PG_DB_PORT:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.postgres }}"
                  key: port
            REDIS_HOST:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.redis }}"
                  key: host
            REDIS_PORT:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.redis }}"
                  key: port
            REDIS_QUEUE:
              value: "billing"
            AWS_DEFAULT_REGION:
              value: "{{ .Values.global.awsRegion }}"
            S3_BUCKET_NAME:
              valueFrom:
                configMapKeyRef:
                  name: "{{ .Values.global.config.common }}"
                  key: bucketName
            API_DOMAIN:
              value: "{{ .Values.global.apiDomain }}"
            PENTEST_SERVICE_USER_API_KEY:
              valueFrom:
                secretKeyRef:
                  name: "{{ .Values.global.secrets.common }}"
                  key: pentestServiceUserApiKey

    authProvider: keycloak
    keycloakEnv:
      - name: PROJECTS_BUCKET
        value: dynamoai-prod-projects
      - name: KEYCLOAK_REALM
        value: dynamo-ai
      - name: KEYCLOAK_API_CLIENT_ID
        value: api
      - name: KEYCLOAK_API_CLIENT_UUID
        value: 1319a712-6308-440f-a584-24fa9cc6bc0d
      - name: IS_KEYCLOAK_AUTHORIZATION_ENABLED
        value: "true"
      - name: KEYCLOAK_BASE_URL
        value: "{{ .Values.global.keycloakDomain }}"
      - name: KEYCLOAK_API_CLIENT_SECRET
        value: g9ooZUkCOaiHfrnCBPvkrUQejSJfMd9p
      - name: "API_AUTH_MODE"
        value: "keycloak-and-key"
      - name: JOB_COMPUTE_KIND
        value: "k8s"
    natsEnv:
      enabled: false
    storageProvider: s3
      
    ##########################################################
    # Ingress object for exposing services
    ##########################################################
    ingress:
      enabled: false

    ##########################################################
    # Role Based Access Control (RBAC)
    ##########################################################
    rbac:
      enabled: true
      # Service Account to use by pods
      serviceAccount:
        enabled: true
        # if create = false, then default service account will be chosen.
        create: false
        name: ""

dynamoai-core:
  enabled: true
  dynamoai-common:
    apikeys:
      guard:
        - ${mistral_api_key}
      mistral:
        - ${mistral_api_key}
      openai:
        - ${openai_api_key}
    proxy:
      http: ""
      https: ""
      noProxy: ""

    ##########################################################
    # Role Based Access Control (RBAC)
    ##########################################################
    rbac:
      enabled: true
      # Service Account to use by pods
      serviceAccount:
        enabled: true
        # if create = false, then default service account will be chosen.
        create: true
        name: "dynamoai-service-account"
        # Additional Labels on service account
        additionalLabels:
          # key: value

        # Annotations on service account 
        annotations:
          # key: value

      roles:
      - name: ""
        rules:
        - apiGroups: [""]
          resources: ["pods", "pods/log", "pods/exec"]
          verbs: ["get", "list", "watch", "create", "delete"]
        - apiGroups: [""]
          resources: ["configmaps"]
          verbs: ["get", "create", "update"]
        - apiGroups: [""]
          resources: ["secrets"]
          verbs: ["get", "create"]
        - apiGroups: ["batch"]
          resources: ["jobs", "jobs/status"]
          verbs: ["get", "list", "watch"]
      # - name: configmaps
      #   rules:
      #   - apiGroups:
      #     - ""
      #     resources:
      #     - configmaps
      #     verbs:
      #     - get
    
    ##########################################################
    # ConfigMaps
    ##########################################################
    configMap:
      enabled: true
      additionalLabels:
        # key: value
      annotations:
        # key: value
      files:
       common-config:
          awsRegion: us-east-1
          bucketName: dfl-prod-aws-pentest-bucket
          corsRule: allow-all
          huggingfaceApiRequestsEnabled: "true"
          pbacSafetyModeEnabled: "true"
          rateLimitDynamoEval: "false"
          rateLimitDynamoGuard: "true"
          remoteModelConfigValidationApiEnabled: "true"
          testReportGenerationEnabled: "true"
       proxy-config:
          http_proxy: '{{ default "" .Values.proxy.http }}'
          https_proxy: '{{ default "" .Values.proxy.https }}'
          no_proxy: '{{ default "" .Values.proxy.noProxy }}'
          HTTP_PROXY: '{{ default "" .Values.proxy.http }}'
          HTTPS_PROXY: '{{ default "" .Values.proxy.https }}'
          NO_PROXY: '{{ default "" .Values.proxy.noProxy }}'
       #   nameSuffix of configMap , e.g. name of config map will be applicationName-code-config
       # code-config:
       #    key1: value1
       #    key2: value2
    ##########################################################
    # Secrets
    ##########################################################
    secret:
      enabled: true
      additionalLabels:
        # key: value
      annotations:
        # key: value
      files:
        #  nameSuffix of Secret , e.g. secret object name will be applicationName-credentials. Values should be in plaintext
        #  Templating of values supported.
        # credentials:
        #   data:
        #     secretKey1: secretValue1
        #     secretKey2: secretValue2
        common-secret:
          data:
            openai_api_key: "{{ (index .Values.apikeys.openai 0) }}"
            mistral_api_key: "{{ (index .Values.apikeys.mistral 0) }}"
            dataGenerationApiKey: ${data_generation_api_key}
            defaultUserApiKey: 4e632e6b-681e-4609-8d52-1ff5d5b7aa84
            defaultUserEmail: admin@admin.com
            defaultUserPassword: P@ssw0rd123
            hfToken: ${hf_token}
            license: ${license}
            pentestServiceUserApiKey: c96ce8c8-de7e-4aa4-be06-176c180e0b0e
            platformAdminPassword: P@ssword123
            serviceUserApiKeyMap: '{"monitoring":"169dad41-38d7-469e-b1c4-f3829a96f0ee","pentesting":"c96ce8c8-de7e-4aa4-be06-176c180e0b0e"}'
        mongodb-secret:
          data:
            host: dynamoai-mongodb-headless.${dynamoai_namespace}.svc.cluster.local
            name: admin
            password: 31lb4EK8u4kv
            port: "27017"
            username: root
        postgres-secret:
          data:
            host: ${postgres_host}
            name: "dynamoai"
            password: ${postgres_password}
            port: "5432"
            username: ${postgres_username}
            keycloakDbName: keycloak
        apikeys-secret:
          data:
            dynamoai.guard.apikeys: '{{ join "," .Values.apikeys.guard }}'
            dynamoai.pentest.apikeys.mistral: '{{ join "," .Values.apikeys.mistral }}'
            dynamoai.pentest.apikeys.openai: '{{- join "," .Values.apikeys.openai }}'
            dynamoai.pentest.apikeys.azure_openai: ""
            dynamoai.pentest.apikeys.azure_mistral: ""
        redis-secret:
          data:
            address: dynamoai-redis.${dynamoai_namespace}.svc.cluster.local:6379
            host: dynamoai-redis.${dynamoai_namespace}.svc.cluster.local
            port: 6379

dynamoai-metrics-server:
  enabled: true
  dynamoai-common:

    ##########################################################
    # Deployment
    ##########################################################
    deployment:
      enabled: true
      # Image of the app container
      image:
        repository: docker.io/metrics-report
        tag: 'dynamoai-3.18.4'
        digest: '' # if set to a non empty value, digest takes precedence on the tag
        pullPolicy: Always

dynamoai-redis:
  enabled: true
  dynamoai-common:

    ##########################################################
    # Deployment
    ##########################################################
    deployment:
      enabled: true
      # Image of the app container
      image:
        repository: docker.io/redis
        tag: '7.2-alpine'
        digest: '' # if set to a non empty value, digest takes precedence on the tag
        pullPolicy: Always

dynamoai-ui:
  enabled: true
  dynamoai-common:
    keycloak:
      enabled: true
      baseUrl: "{{ .Values.global.keycloakDomain }}"
    ##########################################################
    # Deployment
    ##########################################################
    deployment:
      enabled: true
      # Image of the app container
      replicas: 3
      image:
        repository: dynamoaimarketplace.azurecr.io/dynamoai-ui
        tag: '7fddd9725'
        digest: '' # if set to a non empty value, digest takes precedence on the tag
        pullPolicy: Always
      env:
        POD_NAME:
          valueFrom:
            fieldRef:
              fieldPath: 'metadata.name'
        NAMESPACE:
          valueFrom:
            fieldRef:
              fieldPath: 'metadata.namespace'
        DFL_UI_USERPOOL_ID:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: cognitoUserPoolId
        DFL_UI_USERPOOL_CLIENT_ID:
          valueFrom:
            configMapKeyRef:
              name: "{{ .Values.global.config.common }}"
              key: cognitoClientId
        DFL_UI_BASEURL:
          value: "{{ .Values.global.apiDomain }}"
        DFL_KEYCLOAK_REALM:
          value: "dynamo-ai"
        DFL_KEYCLOAK_UI_CLIENT_ID:
          value: "ui"
        DFL_KEYCLOAK_BASE_URL:
          value: "{{ .Values.keycloak.baseUrl }}"
        VITE_BASEURL:
          value: "{{ .Values.global.apiDomain }}"
        VITE_ENABLE_LOGS:
          value: "true"
        VITE_KEYCLOAK_BASE_URL:
          value: "{{ .Values.global.keycloakDomain }}"
        VITE_KEYCLOAK_REALM:
          value: "dynamo-ai"
        VITE_KEYCLOAK_UI_CLIENT_ID:
          value: "ui"
        VITE_ENABLE_SELF_MANAGED_MODELS:
          value: "false"
    ##########################################################
    # Ingress object for exposing services
    # #########################################################
    ingress:
      enabled: false

      # Name of the ingress class
      ingressClassName: nginx

      # List of host addresses to be exposed by this Ingress
      hosts:
        - host: "staging.dynamo.ai"
          paths:
          - path: /
            #  pathType:
            #  serviceName: ''
            #  servicePort: ''

      # Additional labels for this Ingress
      additionalLabels:

      # Add annotations to this Ingress
      annotations:

      # TLS details for this Ingress
      tls:
        # Secrets must be manually created in the namespace.
        # - secretName: chart-example-tls
        #   hosts:
        #     - chart-example.local

mongodb:
  architecture: replicaset
  auth:
    replicaSetKey: Dynam0FL
    rootPassword: 31lb4EK8u4kv
  enabled: true
  image:
    registry: docker.io
    repository: bitnami/mongodb
    tag: "5.0"
  livenessProbe:
    failureThreshold: 10
    initialDelaySeconds: 30
    periodSeconds: 20
    successThreshold: 1
    timeoutSeconds: 10
  pdb:
    create: true
    minAvailable: 2
  persistence:
    enabled: true
    size: 8Gi
  readinessProbe:
    failureThreshold: 10
    initialDelaySeconds: 30
    periodSeconds: 20
    successThreshold: 1
    timeoutSeconds: 10
  replicaCount: 2
  resources:
    limits:
      cpu: 1000m
      memory: 2000Mi
    requests:
      cpu: 1000m
      memory: 2000Mi
  service:
    nameOverride: dynamoai-mongodb-headless
  topologySpreadConstraints:
    - labelSelector:
        matchLabels:
          app.kubernetes.io/name: mongodb
      maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: ScheduleAnyway

minio:
  enabled: false

keycloak:
  enabled: true
  oktaIdpEnabled: false
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      ephemeral-storage: 1024Mi
      memory: 1300Mi
    requests:
      cpu: 250m
      ephemeral-storage: 100Mi
      memory: 1Gi
  secrets:
    create: false
  fullname: dynamoai-base-keycloak
  fullnameOverride: dynamoai-base-keycloak
  auth:
    adminUser: ${keycloak_username}
    adminPassword: ${keycloak_password}
    # existingSecret: dynamoai-keycloak-auth-secret

  adminIngress:
    enabled: false

  extraEnvVars:
    - name: DYNAMOAI_REALM_NAME
      value: "dynamo-ai"
    - name: DYNAMOAI_API_CLIENT_ID
      value: "api"
    - name: DYNAMOAI_UI_CLIENT_ID
      value: "ui"
    - name: DYNAMOAI_API_CLIENT_SECRET
      value: "g9ooZUkCOaiHfrnCBPvkrUQejSJfMd9p"
    - name: DYNAMOAI_UI_DOMAIN
      value: "{{ .Values.global.uiDomain }}"
    - name: REDIRECT_URL_DYNAMOAI_UI
      value: "{{ .Values.global.uiDomain }}/*"
    - name: POST_LOGOUT_REDIRECT_URI
      value: "{{ .Values.global.uiDomain }}/*"
    - name: KEYCLOAK_API_CLIENT_UUID
      value: 1319a712-6308-440f-a584-24fa9cc6bc0d
    - name: DYNAMOAI_API_CLIENT_UUID
      value: 1319a712-6308-440f-a584-24fa9cc6bc0d
    - name: DYNAMOAI_SSL_REQUIRED
      value: None
    - name: KEYCLOAK_EXTRA_ARGS
      value: "--hostname-url={{ .Values.global.keycloakDomain }} --hostname-admin-url={{ .Values.global.keycloakDomain }}/ --import-realm"
    - name: OKTA_BASE_URL
      value: ""
    - name: OKTA_CLIENT_ID
      value: ""
    - name: OKTA_CLIENT_SECRET
      value: ""
    - name: OKTA_IDP_ENABLED
      value: "false"
    - name: KC_HEALTH_ENABLED
      value: "true"

  externalDatabase:
    database: keycloak
    existingSecret: dynamoai-core-postgres-secret
    existingSecretHostKey: host
    existingSecretPortKey: port
    existingSecretUserKey: username
    existingSecretPasswordKey: password

kubernetes-event-exporter:
  enabled: true
  fullnameOverride: "kubernetes-event-exporter"
  config:
    receivers:
      - name: api-pod-k8-events
        webhook:
          endpoint: "{{ .Values.global.apiDomain }}/v1/k8-events/pod"
          headers:
            Authorization: "Bearer 169dad41-38d7-469e-b1c4-f3829a96f0ee"
    route:
      routes:
        - match:
            - receiver: api-pod-k8-events
              kind: "Pod"
              reason: "Evicted|OOMKilled"

dynamoai-amazon-cloudwatch:
    enabled: false

