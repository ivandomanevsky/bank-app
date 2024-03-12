postgres:
	docker run --name postgres12 -p 5425:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=12345678 -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root bank_db

dropdb:
	docker exec -it postgres12 dropdb bank_db

migrateup:
	migrate -path db/migration -database "postgresql://root:12345678@localhost:5425/bank_db?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:12345678@localhost:5425/bank_db?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server
