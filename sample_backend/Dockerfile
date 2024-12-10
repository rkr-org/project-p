FROM python:3.10.16-slim

RUN mkdir -p my_app
WORKDIR my_app
COPY . .
RUN pip3 install -r requirements.txt
EXPOSE 80
ENTRYPOINT ["fastapi"]
CMD ["run", "app.py", "--port", "80"]