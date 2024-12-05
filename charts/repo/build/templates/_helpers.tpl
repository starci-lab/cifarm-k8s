{{- define "imagePullSecret" -}}
{
  "auths": {
    "{{ .Values.imageCredentials.registry }}": {
      "username": "{{ .Values.imageCredentials.username }}",
      "password": "{{ .Values.imageCredentials.password }}",
      "email": "{{ .Values.imageCredentials.email }}",
      "auth": "{{ printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc }}"
    }
  }
}
{{- end -}}
