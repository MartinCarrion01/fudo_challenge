<a name="top"></a>
# Fudo Challenge - API

Aplicación que permite crear y listar productos. Dichos productos son creados de manera asíncrona. Por lo que también cuenta con funcionalidades para consultar el estado de la creación de dichos productos.

# Índice
- Documentación
  - [Fudo](docs/fudo.md)
  - [HTTP](docs/http.md)
  - [TCP](docs/tcp.md)
- [Dependencias](#dependencias)
- [¿Como instalar?](#instalar)
- [¿Como usar la aplicación?](#usar)
- [Descripcion general de la aplicación](#descripcion-app)
- [Indice de rutas expuestas](#indice)

<a name='dependencias'></a>
# Dependencias

Tenemos que cumplir las siguientes dependencias para que el proyecto funcione correctamente:

### Ruby

Versión 3.3.6 o mayor

Para poder instalar Ruby, revisar la siguiente [guía](https://www.ruby-lang.org/en/documentation/installation/).

### SQLite3

Version 3.0.0 o mayor

Este proyecto utiliza SQLite para persistir los datos. Para instalar SQLite3, consultar la siguiente [guía](https://www.sqlite.org/).

### Docker (opcional)

Es posible utilizar Docker para poder levantar el proyecto si es necesario. Para instalar Docker consultar la siguiente [guía](https://docs.docker.com/engine/install/).

### Docker Compose (opcional)

Para poder levantar el proyecto junto la UI de Swagger para la documentación completa de la API, necesitamos tener Docker Compose instalado. Para ello, consultar la siguiente [guía](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)

<a name='instalar'></a>
# ¿Como instalar?

Una vez que satisfacemos las dependencias mencionadas previamente, podemos instalar este proyecto.

1. Clonamos este proyecto en nuestra computadora.

2. Inicializamos las variables de entorno con los siguientes comandos:
```bash
cp env.example .env
source .env
```
3. Instalamos todas las gemas que necesita el proyecto con el siguiente comando:
```bash
bundle install
```
4. Una vez instaladas las gemas, necesitamos crear la base de datos con el siguiente comando:
```
rake db:create
```
5. Luego de crear, necesitamos ejecutar las migraciones de la base de datos con el siguiente comando:
```
rake db:migrate
```
6. Por último, debemos realizar una carga inicial de datos con el siguiente comando:
```
rake db:seed
```

==IMPORTANTE==

En el caso de levantar el proyecto con Docker Compose, solo es necesario realizar el primer y segundo paso de la instalación.

<a name='usar'></a>
# ¿Como usar la aplicación? 

Para poder empezar a usar esta aplicación, es necesario iniciar el servidor web con el comando:

```
bundle exec puma
```
Si vamos a levantar el proyecto usando Docker Compose, hacemos:

```
docker compose up -d --remove-orphans
```

El servidor web escuchará peticiones en el puerto 5000 por defecto en el `localhost` (a menos que se modifique la variable de entorno `PORT`).

Si levantamos el proyecto con Docker Compose, también estará disponible la interfaz de Swagger de forma local en el puerto 8080. Con dicha interfaz podemos realizar pruebas de la API, con la posiblidad de ver a detalle los formatos de las respuestas, headers solicitados, etc.

Para poder realizar peticiones al servidor, podemos usar por ejemplo: Postman o cURL. En este documento, se usará cURL en los ejemplos para cada endpoint. 

Es importante recalcar que es necesario un token que autentique cada petición en el header `Authorization` para todas las requests (menos para el login y para los archivos estáticos).

Por último, el sistema cuenta con un usuario de prueba cuyas credenciales son:

```json
{
  "username": "fudochallenge",
  "password": "12345678"
}
```

<a name='descripcion-app'></a>
# Descripción general de la aplicación: 

## Casos de uso principales de la aplicación: 

### Login

La aplicacion cuenta con una funcionalidad para generar un token de autenticación a la API mediante el login. 

Para ello, el usuario debe especificar usuario y contraseña para obtener dicho token.

==IMPORTANTE:== El token es requerido en todas las peticiones al servidores. Por lo que es importante realizar un login previo a utilizar la API.

### Crear producto

La aplicación permite crear productos en el sistema, con la particularidad de que estos no son creados instantáneamente, si no que son creados de manera asíncrona.

Para ello, al momento de crear el producto, se valida y en caso de ser válido, se crea un Job que se ejecuta en segundo plano transcurrido 5 segundos desde que creo el mismo. El sistema devuelve el id del Job que está creando el producto.

El usuario puede consultar el estado del Job con el endpoint correspondiente y ver el estado de la creación del producto.

### Listar y detallar productos

El usuario puede listar todos los productos en el sistema así como detallar productos de manera individual.

### Listar y detallar Jobs

El usuario puede listar todos los Jobs de creación de productos en el sistema así como detallar productos de manera individual para poder consultar el estado de los mismos.

### Consultar AUTHORS y openapi.yaml

El usuario puede consultar los siguientes archivos:
- openapi.yaml: contiene una descripción de la API en formato OAS.
- AUTHORS: contiene el nombre del autor del proyecto. Este archivo se cachea por 24 horas en el cliente API.

<a name="indice"></a>
# Índice de rutas

- [Autenticación](#auth)
	- [Login](#login)
- [Productos](#productos)
	- [Crear producto](#crear-producto)
  - [Listar productos](#listar-productos)
  - [Detallar producto](#detallar-producto)
- [Jobs](#jobs)
  - [Listar Jobs](#listar-jobs)
  - [Detallar Job](#detallar-job)
- [Archivos](#archivos)
  - [AUTHORS](#authors)
  - [openapi.yaml](#openapi)

# <a name='auth'></a> Autenticación

## <a name='login'></a> Login
[Volver al índice](#indice)

<p>Genera token de autenticación a la API</p>

### Ruta
```
POST /api/v1/auth/login
```
### Headers 

```
{
  Content-Type: application/json
  Accept-Encoding: gzip, deflate, br'
}
```

### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>username</td>
    <td>Nombre de usuario</td>
  </tr>
  <tr>
    <td>password</td>
    <td>Contraseña del usuario</td>
  </tr>
</table>

### Ejemplo

```
curl --location 'http://0.0.0.0:5000/api/v1/auth/login' \
--header 'Accept-Encoding: gzip, deflate, br' \
--header 'Content-Type: application/json' \
--data '{
    "username": "fudochallenge",
    "password": "12345678"
}'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0NTM4NTR9._AyqlWnjrlOgMJi1NefK-oTOWhvOfyLDBZ4F9nZu08g"}
```

### Respuesta fallida

```
HTTP/1.1 401 Unauthorized
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"message":"Invalid credentials"}
```

# <a name='productos'></a> Productos

## <a name='crear-producto'></a> Crear producto
[Volver al índice](#indice)

<p>Encola un Job para la creación de un producto, devolviendo el id del Job para consultar el estado de la operación</p>

### Ruta
```
POST /api/v1/products
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: (token de login)
}
```

### Body params

<table>
  <tr>
    <th>Parametro</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>name</td>
    <td>Nombre del producto</td>
  </tr>
</table>

### Ejemplo
```
curl --location 'http://0.0.0.0:5000/api/v1/products' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MTk2MTF9.Ut3d5HShuYUBPJyFmmugUA3H9YXbMMz2OyrTIZnKNtQ' \
--header 'Accept-Encoding: gzip, deflate, br' \
--header 'Content-Type: application/json' \
--data '{
    "name": "burger"
}'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"message":"Processing product...","job_id":2}
```

### Respuesta fallida

```
HTTP/1.1 422 Unprocessable Content
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"name":["is too short or too long"]}
```

## <a name='listar-productos'></a> Listar productos
[Volver al índice](#indice)

<p>Devuelve una lista de los productos creados en el sistema</p>

### Ruta
```
GET /api/v1/products
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: (token de login)
}
```

### Ejemplo
```
curl --location 'http://0.0.0.0:5000/api/v1/products' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MTk2MTF9.Ut3d5HShuYUBPJyFmmugUA3H9YXbMMz2OyrTIZnKNtQ' \
--header 'Accept-Encoding: gzip, deflate, br' \
--header 'Content-Type: application/json'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
[{"id":1,"name":"lomito"},{"id":2,"name":"burger"},{"id":3,"name":"pizza"},{"id":4,"name":"shawarma"}]
```

## <a name='detallar-producto'></a> Listar productos
[Volver al índice](#indice)

<p>Devuelve el detalle del producto solicitado</p>

### Ruta
```
GET /api/v1/products/:id
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: (token de login)
}
```

### Ejemplo
```
curl --location 'http://0.0.0.0:5000/api/v1/products/1' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MTk2MTF9.Ut3d5HShuYUBPJyFmmugUA3H9YXbMMz2OyrTIZnKNtQ' \
--header 'Accept-Encoding: gzip, deflate, br' \
--header 'Content-Type: application/json'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"id":1,"name":"lomito"}
```

### Respuesta Fallida

```
HTTP/1.1 404 Not Found
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"message":"Product not found"}
```

# <a name='jobs'></a> Jobs

## <a name='listar-jobs'></a> Listar Jobs
[Volver al índice](#indice)

<p>Devuelve una lista de los Jobs de creacion de producto en el sistema</p>

### Ruta
```
GET /api/v1/jobs
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: (token de login)
}
```

### Ejemplo
```
curl --location 'http://0.0.0.0:5000/api/v1/jobs' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MTk2MTF9.Ut3d5HShuYUBPJyFmmugUA3H9YXbMMz2OyrTIZnKNtQ' \
--header 'Accept-Encoding: gzip, deflate, br' \
--header 'Content-Type: application/json'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
[{"id":1,"created_at":"2024-12-04 19:31:37 -0300","state":"success","payload":"{\"name\":\"pizza\"}","result":"{\"product\":{\"id\":3,\"name\":\"pizza\"}}"},{"id":2,"created_at":"2024-12-04 19:31:37 -0300","state":"success","payload":"{\"name\":\"shawarma\"}","result":"{\"product\":{\"id\":4,\"name\":\"shawarma\"}}"}]
```

## <a name='detallar-job'></a> Detallar job
[Volver al índice](#indice)

<p>Devuelve el detalle del Job solicitado. Sirve para consultar el estado de la creación de un producto.</p>

### Ruta
```
GET /api/v1/jobs/:id
```
### Headers 

```
{
  Content-Type: application/json
  Authorization: (token de login)
}
```

### Ejemplo
```
curl --location 'http://0.0.0.0:5000/api/v1/jobs/1' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MTk2MTF9.Ut3d5HShuYUBPJyFmmugUA3H9YXbMMz2OyrTIZnKNtQ' \
--header 'Accept-Encoding: gzip, deflate, br' \
--header 'Content-Type: application/json'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"id":1,"created_at":"2024-12-04 19:31:37 -0300","state":"success","payload":"{\"name\":\"pizza\"}","result":"{\"product\":{\"id\":3,\"name\":\"pizza\"}}"}
```

### Respuesta fallida

```
HTTP/1.1 404 Not Found
content-type: application/json
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
{"message":"Job not found"}
```

# <a name='archivos'></a> Archivos

## <a name='authors'></a> AUTHORS
[Volver al índice](#indice)

<p>Devuelve el archivo AUTHORS con el autor del proyecto</p>

### Ruta
```
GET /AUTHORS
```

### Ejemplo
```
curl --location 'http://0.0.0.0:5000/AUTHORS' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MTk2MTF9.Ut3d5HShuYUBPJyFmmugUA3H9YXbMMz2OyrTIZnKNtQ' \
--header 'Accept-Encoding: gzip, deflate, br'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
last-modified: Wed, 04 Dec 2024 12:37:32 GMT
content-type: text/plain
cache-control: max-age=86400
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
Martín Carrión
```

## <a name='openapi'></a> openapi.yaml
[Volver al índice](#indice)

<p>Devuelve el archivo openapi.yaml con la especificación de la API del proyecto en formato OAS</p>

### Ruta
```
GET /openapi.yaml
```

### Ejemplo
```
curl --location 'http://0.0.0.0:5000/openapi.yaml' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MTk2MTF9.Ut3d5HShuYUBPJyFmmugUA3H9YXbMMz2OyrTIZnKNtQ' \
--header 'Accept-Encoding: gzip, deflate, br'
```

### Respuesta exitosa

```
HTTP/1.1 200 OK
last-modified: Thu, 05 Dec 2024 00:56:30 GMT
content-type: text/yaml
cache-control: no-cache
vary: Origin,Accept-Encoding
content-encoding: gzip
Transfer-Encoding: chunked
 
openapi: 3.1.0...
```
