FROM alpine:latest

ENV DL_BASIC_PASSWORDS_LIST "https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt"
ENV DL_VULNERABILITIES_LIST "https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv"

WORKDIR /app

RUN apk add --update --no-cache perl perl-doc mariadb-client \
    && adduser --shell /bin/false --disabled-password --gecos "MySQLTunner User" --home "/app" "mysqltunner" \
    && wget http://mysqltuner.pl/ -O /mysqltuner.pl \
    && wget "${DL_BASIC_PASSWORDS_LIST}" -O ./basic_passwords.txt \
    && wget "${DL_VULNERABILITIES_LIST}" -O ./vulnerabilities.csv

USER mysqltunner
ENTRYPOINT ["perl", "/mysqltuner.pl", "--cvefile=./vulnerabilities.csv", "--passwordfile=./basic_passwords.txt"]