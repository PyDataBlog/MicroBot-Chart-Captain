{{/* Generate the default fully qualified app name */}}
{{- define "MyMicroBotDemo.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "MyMicroBotDemo.labels" -}}
app.kubernetes.io/name: {{ include "MyMicroBotDemo.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}