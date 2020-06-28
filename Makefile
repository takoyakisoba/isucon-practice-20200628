
.PHONY: gogo pull build stop-services start-services truncate-logs kataribe
gogo: stop-services pull build truncate-logs start-services

pull:
	git pull origin master

build:
	make -C go setup
	cd ./go && go build -o ./app app.go

run:
	cd ./go && ./app

stop-services:
	sudo service nginx stop
	sudo supervisorctl stop isucon_go
	sudo service mysql stop

start-services:
	sudo service mysql start
	sudo supervisorctl start isucon_go
	sudo service nginx start

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /tmp/isucon.go.log

kataribe:
	cd ~/work/kataribe_work && sudo cat /var/log/nginx/access.log | ./kataribe

benchmark:
	sudo ~/qualifier_bench/qualifier_bench benchmark --init ~/webapp/init/init.sh --workload 1

# 開発用
.PHONY: up down mysql
up:
	docker-compose up -d --build

down:
	docker-compose down

exec:
	docker-compose run --rm app sh

logs:
	docker-compose logs -f

mysql:
	docker-compose exec db mysql -u root
