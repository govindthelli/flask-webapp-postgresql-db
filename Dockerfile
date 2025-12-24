FROM python:3.11-slim

# -----------------------
# Environment
# -----------------------
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# -----------------------
# System dependencies
# -----------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# -----------------------
# Python dependencies
# -----------------------
COPY requirements.txt .

RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# -----------------------
# Application code
# -----------------------
COPY . .

# -----------------------
# Expose & Run
# -----------------------
EXPOSE 8000

CMD ["gunicorn", "app:app", \
     "--bind", "0.0.0.0:8000", \
     "--workers", "3", \
     "--timeout", "120", \
     "--access-logfile", "-", \
     "--error-logfile", "-"]
