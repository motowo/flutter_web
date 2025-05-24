# Stage 1: Base Python image
FROM python:3.10-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Optional: Install system dependencies if needed by any Python package
# RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev gcc

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p /app/staticfiles /app/media && \
    chown -R nobody:nogroup /app/media && \
    chmod -R 775 /app/media

# Ensure STATIC_ROOT is defined in settings.py before running collectstatic
# Example: STATIC_ROOT = BASE_DIR / "staticfiles"
RUN python manage.py collectstatic --noinput

EXPOSE 8000
USER nobody
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "card_project_backend.wsgi:application"]
