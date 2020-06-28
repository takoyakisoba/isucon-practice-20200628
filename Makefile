
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
	sudo service httpd stop
	sudo supervisorctl stop isucon_go
	sudo service mysql stop

start-services:
	sudo service mysql start
	sudo supervisorctl start isucon_go
	sudo service httpd start

truncate-logs:
	sudo rm -f /var/log/httpd/*
	sudo truncate --size 0 /tmp/isucon.go.log

kataribe:
	cd ~/work/kataribe_work && cat /var/log/httpd/access_log | ./kataribe

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
