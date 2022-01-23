# qgis image

Edit following volume bind path.
- QGIS_BIND_PATH

## App specific configuration
```yaml
  qgis:
    build: https://github.com/ysuito/desktop-compose.git#master:src/qgis
    image: qgis
    container_name: qgis
    depends_on:
      - ubuntubase
    volumes:
      - "QGIS_BIND_PATH:/home/user"
    command: ["su user -c \\\"qgis\\\""]
```

