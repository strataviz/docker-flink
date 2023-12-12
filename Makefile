.PHONY: build
build: build-1.17-openjdk-11-scala-2.12

.PHONY build-1.17-openjdk-11-scala-2.12:
build-1.17-openjdk-11-scala-2.12:
	@echo "Building flink (openjdk-11, scala-2.12, debian)"
	@docker build \
		--tag strataviz/flink:1.17-openjdk-11-scala-2.12 \
		--build-arg "FLINK_VERSION=1.17.2" \
		--build-arg "SCALA_VERSION=2.12" \
		--build-arg "BASE_IMAGE=openjdk:11-jdk-slim" \
		--file ./1.17/java/Dockerfile \
		./1.17/java
	@docker tag \
		strataviz/flink:1.17-openjdk-11-scala-2.12 \
		strataviz/flink:1.17

.PHONY: push
push: push-1.17-openjdk-11-scala-2.12

.PHONY: push-1.17-openjdk-11-scala-2.12
push-1.17-openjdk-11-scala-2.12:
	@echo "Pushing flink (openjdk-11, scala-2.12, debian)"
	@docker push strataviz/flink:1.17-openjdk-11-scala-2.12
	@docker push strataviz/flink:1.17

.PHONY: build-pyflink-1.17
build-pyflink-1.17:
	@echo "Building pyflink (python 3.7.9, openjdk-11, scala-2.12, debian)"
	@docker build \
		--tag strataviz/pyflink:1.17 \
		--build-arg "PYTHON_VERSION=3.7.9" \
		--file ./1.17/python/Dockerfile \
		--progress plain \
		./1.17/python

.PHONY: push-pyflink-1.17
push-pyflink-1.17:
	@echo "Pushing pyflink (python openjdk-11, scala-2.12, debian)"
	@docker push strataviz/pyflink:1.17
