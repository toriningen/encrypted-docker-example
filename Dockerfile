FROM python:3.9

# some dependency
RUN pip3 install pychalk

COPY app /app
WORKDIR /app
CMD ["python3", "./main.py"]
