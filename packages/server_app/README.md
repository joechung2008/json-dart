# JSON Parser Server

A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This server provides a REST API for parsing JSON using a custom Dart JSON parser.
It accepts POST requests to `/api/v1/parse` with `text/plain` content type.

## API Endpoint

### POST /api/v1/parse

Parses the request body as JSON and returns the parsed result.

**Request:**
- Method: POST
- Content-Type: text/plain
- Body: JSON string to parse

**Response:**
- Success (200): application/json with the parsed JSON object
- Invalid Content-Type (415): application/json with error details
- Parse Error (400): application/json with error details

## Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8000
```

And then from a second terminal:
```
$ curl -X POST -H "Content-Type: text/plain" -d '{"key": "value"}' http://0.0.0.0:8000/api/v1/parse
{"key":"value"}
```

For invalid JSON:
```
$ curl -X POST -H "Content-Type: text/plain" -d '{"invalid": json}' http://0.0.0.0:8000/api/v1/parse
{"code":400,"message":"FormatException: expected array, false, null, number, object, string, or true, actual 'j'"}
```

For wrong content type:
```
$ curl -X POST -H "Content-Type: application/json" -d '{"key": "value"}' http://0.0.0.0:8000/api/v1/parse
{"code":415,"message":"Invalid Media Type"}
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8000:8000 myserver
Server listening on port 8000
```

And then from a second terminal:
```
$ curl -X POST -H "Content-Type: text/plain" -d '{"key": "value"}' http://0.0.0.0:8000/api/v1/parse
{"key":"value"}
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 POST    [200] /api/v1/parse
```
