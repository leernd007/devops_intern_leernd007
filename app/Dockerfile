FROM python:3.11 as BASE_IMAGE

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

RUN chmod +x ./start.sh
CMD ["./start.sh"]

