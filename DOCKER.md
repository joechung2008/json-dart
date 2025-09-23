# Docker Instructions for shelf_app

## Building the Container

From the repository root:

```bash
sudo docker build -f packages/shelf_app/Dockerfile .
```

This builds the Docker image for the shelf_app using the Dart workspace setup.

## Running the Container

After building, the image will be untagged. To run it:

1. List images to find the ID:

```bash
sudo docker images
```

2. Tag the image for easier reference (replace `<image_id>` with the actual ID from the list):

```bash
sudo docker tag <image_id> shelf_app:latest
```

3. Run the container, mapping port 8000:

```bash
sudo docker run -p 8000:8000 shelf_app:latest
```

The server will start and be accessible at `http://localhost:8000`.

## Listing Images

To see all Docker images:

```bash
sudo docker images
```

## Stopping the Container

If the container is running (e.g., from `docker run`), stop it before removing the image:

1. List running containers:

```bash
sudo docker ps
```

2. Stop the container (replace `<container_id>` or use the name if tagged):

```bash
sudo docker stop <container_id>
```

Or if tagged: `docker stop shelf_app:latest`

Note: If you ran the container in the foreground, you can also stop it with `Ctrl+C` in the terminal.

## Removing Containers and the Image

When you're done with the container and image:

1. If the container is stopped but still exists, remove it:

```bash
sudo docker rm <container_id>
```

Or: `sudo docker rm shelf_app:latest` (if named)

2. Remove the image:

```bash
sudo docker rmi shelf_app:latest
```

Or remove by image ID if untagged:

```bash
sudo docker rmi <image_id>
```

## Notes

- The container uses port 8000 by default (matching the server's default).
- If you need to change the port, set the `PORT` environment variable: `docker run -p <host_port>:8000 -e PORT=8000 shelf_app:latest`.
- Ensure Docker Desktop is running and WSL integration is enabled if on Windows/WSL.
- Docker commands may require `sudo` if your user is not in the `docker` group. To avoid this, run: `sudo usermod -aG docker $USER`, then log out and back in (or run `newgrp docker`).
