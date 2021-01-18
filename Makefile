ROOT_DIR=$(PWD)
PG_USER=postgres
PG_PASSWORD=postgres123
PG_CONTAINER=postgres-container
PG_PORT=5432
PG_DATABASE=postgres
PG_ADMIN_PORT=5050
PG_MOUNT_DATA_DIR=$(ROOT_DIR)/postgres/pgdata:/var/lib/postgresql/data
PG_MOUNT_SQL_DIR=$(ROOT_DIR)/sql:/var/sql
GUEST_SQL_DIR=/var/sql

help:
	@echo make docker-run
	@echo make docker-ps
	@echo make docker-run-pg-admin
	@echo make docker-exec-psql
	@echo make docker-list-tables
	@echo make list-tables
	@echo ""
	@echo make clean-db
	@echo make clean

docker-run:
	docker run \
		-d \
		--name $(PG_CONTAINER) \
		-p $(PG_PORT):$(PG_PORT) \
		-e POSTGRES_PASSWORD=$(PG_PASSWORD)\
		-v $(PG_MOUNT_SQL_DIR) \
		-v $(PG_MOUNT_DATA_DIR) postgres

docker-ps:
	docker ps -a

docker-run-pg-admin:
	docker run --rm -p $(PG_ADMIN_PORT):$(PG_ADMIN_PORT) thajeztah/pgadmin4

# NAA
# - find running container id
# - CID := $(shell docker ps -a | grep postgres | awk '{print $$1}')
docker-exec-psql:
	docker exec -it  \
		$(shell docker ps -a | grep postgres | awk '{print $$1}') \
	 	psql -U $(PG_USER)

run_psql: run_psql.sh

docker-list-tables:
	docker exec -it  \
		$(shell docker ps -a | grep postgres | awk '{print $$1}') \
	 	psql -U $(PG_USER) -f $(GUEST_SQL_DIR)/list_tables.sql

# NAA.
# - use underscore for external .sql file invocations
list_tables: run_psql
	./run_psql list_tables

clean-db:
	sudo rm -fr pgdata

clean:
	rm run_psql

