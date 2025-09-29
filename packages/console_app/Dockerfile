# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /workspace
COPY . .
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
WORKDIR /workspace/packages/console_app
RUN dart compile exe bin/console_app.dart -o bin/console_app

# Build minimal serving image from AOT-compiled `/console_app`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /workspace/packages/console_app/bin/console_app /app/bin/

# Start app.
CMD ["/app/bin/console_app"]
