

run-prod:
	docker-compose up

run-test:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml up 

build:
	docker-compose build

kill:
	docker-compose kill
