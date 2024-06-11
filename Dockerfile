FROM --platform=linux/amd64 python:3.12
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install .
CMD ["python", "run.py"]