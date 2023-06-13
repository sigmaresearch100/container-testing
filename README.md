# sigmaresearch100/testing

Anderson A. Anderson

<!-- badges: start -->
[![Docker and Apptainer Build and Push](https://github.com/sigmaresearch100/container-testing/actions/workflows/docker-apptainer-build-push.yml/badge.svg)](https://github.com/sigmaresearch100/container-testing/actions/workflows/docker-apptainer-build-push.yml)
[![Docker and Apptainer Build and Push (Daily)](https://github.com/sigmaresearch100/container-testing/actions/workflows/docker-apptainer-build-push-daily.yml/badge.svg)](https://github.com/sigmaresearch100/container-testing/actions/workflows/docker-apptainer-build-push-daily.yml)
[![Docker and Apptainer Build and Push (Weekly)](https://github.com/sigmaresearch100/container-testing/actions/workflows/docker-apptainer-build-push-weekly.yml/badge.svg)](https://github.com/sigmaresearch100/container-testing/actions/workflows/docker-apptainer-build-push-weekly.yml)
<!-- badges: end -->

## Description

Docker and Apptainer/Singularity containers. THIS IS FOR TESTING PURPOSES ONLY.

## GitHub Actions

The `Docker and Apptainer Build and Push` GitHub action performs the following:

- Builds the Docker image specified by the `Dockerfile`.
- Pushes the image to [DockerHub](https://hub.docker.com/repository/docker/sigmaresearch100/docker-sandbox/general) using the tags `latest` and `date and time of build (YEAR-MM-DD-HHMMSS)`.
- Builds the Singularity Image File (SIF) using Apptainer based on the Docker Hub image from the previous step.
- Creates a GitHub release named `sif-YEAR-MM-DD-HHMMSS`. Note that `sif-YEAR-MM-DD-HHMMSS.zip` contains the SIF. 

## Docker Shell

```bash
docker run -it sigmaresearch100/testing
```

## Apptainer Shell

Download and unzip `sif-YEAR-MM-DD-HHMMSS.zip` from the GitHub release to extract `testing.sif`.

```bash
apptainer shell testing.sif
```
