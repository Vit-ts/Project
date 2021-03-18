FROM python:3.7-alpine
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev \
    && apk add jpeg-dev zlib-dev libjpeg
RUN pip install -r requirements.txt
COPY . /code/

RUN apk del build-deps
RUN chmod ugo+x init.sh
ENTRYPOINT ["sh","init.sh"]
EXPOSE 80