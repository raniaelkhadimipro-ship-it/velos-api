FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim AS tests
WORKDIR /app
COPY requirements-test.txt requirements.txt ./
RUN pip install --no-cache-dir -r requirements-test.txt
COPY app.py test_app.py ./
RUN python -m pytest test_app.py -v && touch /tests_ok

FROM python:3.12-slim
RUN useradd --create-home --shell /bin/bash appuser
WORKDIR /app
COPY --from=builder /root/.local /home/appuser/.local
COPY --from=tests /tests_ok /tests_ok
COPY app.py .
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
USER appuser
EXPOSE 8000
CMD ["python", "app.py"]
