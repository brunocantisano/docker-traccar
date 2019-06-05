.PHONY: default build remove rebuild save load tag push publish pull run test clean stop start default

DOCKER_IMAGE_VERSION=3.17
IMAGE_NAME=traccar
OWNER=devcant
PORT=9413
NEXUS_REPO=$(OWNER):$(PORT)
TAG=$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
DOCKER_IMAGE_NAME=$(OWNER)/$(IMAGE_NAME)
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
FILE_TAR = ./$(IMAGE_NAME).tar
FILE_GZ = $(FILE_TAR).gz

UNAME_S        := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    APP_HOST   := localhost
endif
ifeq ($(UNAME_S),Darwin)
    APP_HOST   := $(shell docker-machine ip default)
endif

default:
	build

build:
	docker build -t $(DOCKER_IMAGE_TAGNAME) .

remove:
	docker rmi -f $(DOCKER_IMAGE_TAGNAME)

rebuild: remove build

save:
	docker image save $(DOCKER_IMAGE_TAGNAME) > $(FILE_TAR)
	@[ -f $(FILE_TAR) ] && gzip $(FILE_TAR) || true

load:
	@[ -f $(FILE_GZ) ] && gunzip $(FILE_GZ) || true
	@[ -f $(FILE_TAR) ] && docker load -i $(FILE_TAR) && gzip $(FILE_TAR) || true

tag:
	docker tag $(DOCKER_IMAGE_TAGNAME) $(NEXUS_REPO)/$(TAG)

push:
	docker push $(NEXUS_REPO)/$(TAG)

publish: tag push

pull:
	docker pull $(NEXUS_REPO)/$(TAG)

run:	
	docker run \
	-d --restart always \
	--name $(IMAGE_NAME) \
	--hostname $(IMAGE_NAME) \
	-p 80:8082 \
	-p 5000-5150:5000-5150 \
	-p 5000-5150:5000-5150/udp \
	-v /etc/timezone:/etc/timezone:ro \
	-v /etc/localtime:/etc/localtime:ro \
	-v ~/arquivos/traccar/logs:/opt/traccar/logs:rw \
	-v ~/arquivos/traccar/traccar.xml:/opt/traccar/conf/traccar.xml:ro \
	$(NEXUS_REPO)/$(TAG)

test:
	docker run --rm $(NEXUS_REPO)/$(TAG) /bin/echo "Success."

clean:
	@docker stop $(IMAGE_NAME)
	@docker rm $(IMAGE_NAME) > /dev/null || true

stop:
	@docker stop $(IMAGE_NAME)

start:
	@docker start $(IMAGE_NAME)

default:
	docker run \
    --rm \
    --entrypoint cat \
    $(NEXUS_REPO)/$(TAG) \
    /opt/traccar/conf/traccar.xml > ~/arquivos/traccar/traccar.xml
	
all: build mount run import	