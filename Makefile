DB_URL=postgresql://root:12345678@localhost:5425/bank_db?sslmode=disable

postgres:
	docker run --name postgres12 --network bank-network -p 5425:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=12345678 -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root bank_db

dropdb:
	docker exec -it postgres12 dropdb bank_db

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/ivandomanevsky/bank-app/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 db_docs db_schema sqlc test server mock
