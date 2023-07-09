# MicroBot-Chart-Captain

This is a Helm chart for deploying the MicroBot application to a Kubernetes cluster.

## Prerequisites

Before deploying this chart, you must have the following:

- A Kubernetes cluster
- Helm 3 installed on your local machine

## Installation

To install the chart, run the following command:

```
helm install myrelease . --namespace mynamespace -f custom_values.yaml
```


This will install the chart with the release name `myrelease` in the namespace `mynamespace`, using the values specified in the `custom_values.yaml` file.

## Configuration

The following table lists the configurable parameters of the chart and their default values:

| Parameter | Description | Default |
| --- | --- | --- |
| `image.repository` | The Docker image repository to use | `bebr/microbot` |
| `image.tag` | The Docker image tag to use | `latest` |
| `service.type` | The Kubernetes service type to use | `ClusterIP` |
| `service.port` | The port number to use for the Kubernetes service | `8080` |
| `ingress.enabled` | Whether to enable Kubernetes ingress | `true` |
| `ingress.hostname` | The hostname to use for the Kubernetes ingress | `mymicrobot.local` |
| `ingress.tls` | The TLS configuration for the Kubernetes ingress | `[]` |

You can override these values by creating a `custom_values.yaml` file and specifying your own values.

## Testing

To test the connection to the MicroBot application, you can run the following command:

```
helm test myrelease
```


This will run a test pod that connects to the MicroBot application and verifies that it is working correctly.

## Uninstallation

To uninstall the chart, run the following command:


```
helm uninstall myrelease
```


This will remove the chart and all associated resources from your Kubernetes cluster.