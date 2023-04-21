ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2023.1.0.185.0-zpm
FROM $IMAGE

WORKDIR /home/irisowner/irisdev

# copy files
COPY  Installer.cls .
COPY src src
COPY  module.xml .
COPY iris.script /tmp/iris.script
COPY dsw/irisapp.json dsw/irisapp.json

# run iris and script
RUN --mount=type=bind,src=src,dst=src \
    iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly

