DB_URL=postgresql://root:9G1VipKc0H38CCE1IRqk@go-bank.c967qpaovd69.us-west-2.rds.amazonaws.com:5432/simple_bank

postgres:
	docker run --name postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
	
createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank
	
migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1
	
migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1
	
sqlc:
	docker run --rm -v $(shell pwd):/src -w /src sqlc/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/TerenceCui/go_bank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server

