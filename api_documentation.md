# How it Works

### 1. Register and Authentication users

* This app used [Guardian](https://github.com/ueberauth/guardian) to manage users;

### 2. Create, update and Show Accounts

#### Create/Update
* Any Account is related a User;
* Before create Account, checks if there is already an Account with CPF informated;
* If does not exist, try to create a new one;
* Else, try update Account with data information;

* To encrypt `name`,`email` , `cpf` and `birth_date` fields use lib [cloak_ecto](https://github.com/danielberkompas/cloak_ecto);
* To validate CPF use lib [brcpfcnpj](https://github.com/williamgueiros/Brcpfcnpj);

##### Show
* Request returns user information data;
* If the account is completed, show accounts creates with user account referral code;


### 3. Endpoints and requests examples

> To authenticate, register a new user with `sign_up` or log in an existing user with `sign_in` route, and add `jwt` token returned in the response to header request as in the examples.

#### post `/sign_up` => Register new user:

```
curl --location --request POST 'localhost:4000/api/v1/sign_up' \
--header 'Content-Type: application/json' \
--data-raw '{
	"user": {
		"username": "Some Name",
		"password": "myPassword",
		"password_confirmation": "myPassword"
	}
}'
```

#### post `/sign_in` => Login user:

```
curl --location --request POST 'localhost:4000/api/v1/sign_in' \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "Some Name",
    "password": "myPassword"
}'
```

#### put `/user` => Update passwords:

```
curl --location --request PUT 'localhost:4000/api/v1/users/1' \
--header 'Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJiYW5rQWNjb3VudCIsImV4cCI6MTU5NjU0Njg1NSwiaWF0IjoxNTk0MTI3NjU1LCJpc3MiOiJiYW5rQWNjb3VudCIsImp0aSI6ImY3ZGYxM2M0LWMwNjctNDM1MC1hMDdhLTg1ZWE1ZTE0NTY1ZCIsIm5iZiI6MTU5NDEyNzY1NCwic3ViIjoiMSIsInR5cCI6ImFjY2VzcyJ9.IcQtTnYuJsv723_KCBmQJWH7MaMdIJZjqKnXI8hpjAi5itZGG-ulwu1asLpuKbY1FlM7ihFsy15amJsbiEFsHQ' \
--header 'Content-Type: application/json' \
--data-raw '{
    "user": {
        "password": "12345678",
        "password_confirmation": "12345678"
    }
}'
```

#### post `/accounts` => Create or update Account;

```
curl --location --request POST 'localhost:4000/api/v1/accounts' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer   eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJiYW5rQWNjb3VudCIsImV4cCI6MTU5NjQ3NDkyMiwiaWF0IjoxNTk0MDU1NzIyLCJpc3MiOiJiYW5rQWNjb3VudCIsImp0aSI6IjE0N2U2NjNmLTlkMWUtNDk5ZC1iMGMwLTAyM2RkODBiZGZkNCIsIm5iZiI6MTU5NDA1NTcyMSwic3ViIjoiMSIsInR5cCI6ImFjY2VzcyJ9.8_oqapNpNdw6EuQ148zasEKTV3TZU_HHxWHHFx3ZnyNKDlCOEYPWS76YpZPvqq7sMCJK3ulM-I8axee5caUgFg' \
--data-raw '{
	"account": {
		"name": "Ricardo da Silva Silveira",
		"cpf": "049.303.460-96",
		"email": "thiago@gmail.com",
		"birth_date": "08/05/1988",
		"gender": "Masculino",
		"city": "Dourados",
		"state": "Mato Grosso do Sul",
		"country": "Brasil"
	}
}'
```

#### get `/accounts/:id` => Show Account and accounts created with `referral_code`:

```
curl --location --request GET 'localhost:4000/api/v1/accounts/1' \
--header 'Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJiYW5rQWNjb3VudCIsImV4cCI6MTU5NjQ3ODczOCwiaWF0IjoxNTk0MDU5NTM4LCJpc3MiOiJiYW5rQWNjb3VudCIsImp0aSI6Ijc2ZGNmNzUxLTcyOTgtNGYwYy1iNjA2LTY5MThiZmNlZmNmYSIsIm5iZiI6MTU5NDA1OTUzNywic3ViIjoiMiIsInR5cCI6ImFjY2VzcyJ9.2Vi_NnMCesWLb-BqYxRIEPb5sivRgFGxVGJ8btB1GLyYATzclMWR5_wODj28pXg4QHtw5nO-qxdl-b0k_RfXag'
```

### 4.Postman

To use [postman](https://www.postman.com/), import this [collection](https://www.getpostman.com/collections/e5fd245bd2f40f692dcf).
Attention to authenticated routes.

