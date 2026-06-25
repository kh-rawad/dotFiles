{{/* Chart naming helpers */}}
{{- define "home-media-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "home-media-server.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "home-media-server.serviceFullname" -}}
{{- $root := .root -}}
{{- $serviceName := .serviceName -}}
{{- printf "%s-%s" (include "home-media-server.fullname" $root) $serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
