ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2023.1.0.185.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2022.3.0.606.0
ARG IMAGE=intersystemsdc/iris-community:preview
FROM $IMAGE as builder

WORKDIR /home/irisowner/irisdev/

ARG TESTS=0
ARG MODULE="samples-bi-demo"
ARG NAMESPACE="USER"

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly


FROM $IMAGE as final
ADD --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /home/irisowner/irisdev/copy-data.py
#ADD https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /home/irisowner/irisdev/copy-data.py

RUN --mount=type=bind,source=/,target=/builder/root,from=builder \
    cp -f /builder/root/usr/irissys/iris.cpf /usr/irissys/iris.cpf && \
    python3 /home/irisowner/irisdev/copy-data.py -c /usr/irissys/iris.cpf -d /builder/root/
