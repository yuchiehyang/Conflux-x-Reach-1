REACH = reach

.PHONY: clean
clean:
	rm -rf build/*.main.mjs

build/%.main.mjs: %.rsh
	$(REACH) compile $^

.PHONY: build
build: build/index.main.mjs
	docker build -f Dockerfile --tag=reachsh/reach-app-32c147a7f390d889d70007cb506c2e363a8a5da1d6db4e7c64ec8be8bfeedb35:latest .

.PHONY: run
run:
	$(REACH) run index

.PHONY: run-target
run-target: build
	docker-compose -f "docker-compose.yml" run --rm reach-app-32c147a7f390d889d70007cb506c2e363a8a5da1d6db4e7c64ec8be8bfeedb35-$${REACH_CONNECTOR_MODE} $(ARGS)

.PHONY: down
down:
	docker-compose -f "docker-compose.yml" down --remove-orphans

.PHONY: run-live
run-live:
	docker-compose run --rm reach-app-tut-8-ETH-live


.PHONY: run
run: build check

.PHONY: check
check: docker-compose..yml docker-compose.ETH.yml docker-compose.ALGO.yml docker-compose.CFX.yml
	./check.sh

docker-compose..yml: docker-compose.yml
	cp $^ $@

docker-compose.ETH.yml: docker-compose.yml
	cp $^ $@

docker-compose.ALGO.yml: docker-compose.yml
	sed -e '34s/ &default-app//' -e '54s/:/: \&default-app/' $^ > $@

docker-compose.CFX.yml: docker-compose.yml
	sed -e '34s/ &default-app//' -e '65s/:/: \&default-app/' $^ > $@

.PHONY: run-alice
run-alice:
	docker-compose run --rm alice

.PHONY: run-bob
run-bob:
	docker-compose run --rm bob