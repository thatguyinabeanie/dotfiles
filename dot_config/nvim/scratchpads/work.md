# Civis Analytics API Requests

## Notes

- Use the appropriate environment section
- Update @path and @id variables as needed
- Copy the HTTP block content to a .http file if kulala doesn't execute directly from markdown

## Production

```http
@baseUrl=https://api.civisanalytics.com
@civisApiKey = {{CIVIS_API_KEY_PRODUCTION}}
@path=code_clouds
@id=48

### POST
POST {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

### LIST
GET {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### GET
GET {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### PATCH
PATCH {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

```

## Staging

```http
@baseUrl=https://api-staging.civisanalytics.com
@civisApiKey={{CIVIS_API_KEY_STAGING}}
@path=code_clouds
@id=43

### POST
POST {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

### LIST
GET {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### GET
GET {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### PATCH
PATCH {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }
```

## Local Development

```http
@baseUrl=https://platform.civis.test:3000
@civisApiKey={{CIVIS_API_KEY_LOCAL_CONSOLE}}
@path=code_clouds
@id=43

### POST
POST {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
{ }

### LIST
GET {{baseUrl}}/{{path}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### GET
GET {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json

### PATCH
PATCH {{baseUrl}}/{{path}}/{{id}}
Authorization: Bearer {{civisApiKey}}
Content-Type: application/json
Accept: application/json
