# Persistent Volume
## Example
```yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: cifarm-server-postgresql-master-volume
  labels:
    type: local
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/apps/cspmv/etc"