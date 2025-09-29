# Docker Instructions

## console_app

### Building the Container

From the repository root:

```bash
docker build -f packages/console_app/Dockerfile -t console_app .
```

### Running the Container

```bash
docker run -it --rm console_app
```

### Stopping the Container

1. List running containers:

```bash
docker ps
```

2. Stop the container (replace `<container_id>` or use the name if tagged):

```bash
docker stop <container_id>
```

### Removing the Image

```bash
docker rmi console_app
```

## dart_frog_app

### Building the Container

From the repository root:

```bash
docker build -f packages/dart_frog_app/Dockerfile -t dart_frog_app .
```

### Running the Container

```bash
docker run --rm -d -p 8000:8000 dart_frog_app
```

### Stopping the Container

1. List running containers:

```bash
docker ps
```

2. Stop the container (replace `<container_id>` or use the name if tagged):

```bash
docker stop <container_id>
```

### Removing the Image

```bash
docker rmi dart_frog_app
```

## shelf_app

### Building the Container

From the repository root:

```bash
docker build -f packages/shelf_app/Dockerfile -t shelf_app .
```

### Running the Container

```bash
docker run --rm -d -p 8000:8000 shelf_app
```

### Stopping the Container

1. List running containers:

```bash
docker ps
```

2. Stop the container (replace `<container_id>` or use the name if tagged):

```bash
docker stop <container_id>
```

### Removing the Image

```bash
docker rmi shelf_app
```

## Notes

- The container uses port 8000 by default (matching the server's default).
- If you need to change the port, set the `PORT` environment variable: `docker run -p <host_port>:8000 -e PORT=8000 shelf_app:latest`.
- Ensure Docker Desktop is running and WSL integration is enabled if on Windows/WSL.
- Docker commands may require `sudo` if your user is not in the `docker` group. To avoid this, run: `usermod -aG docker $USER`, then log out and back in (or run `newgrp docker`).
