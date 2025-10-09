# 1. Use official Python base image
FROM python:3.10-slim

# 2. Basic environment configuration
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Allow passing PyPI repo URL from GitHub Actions
ARG PYPI_REPO_URL
ENV PIP_EXTRA_INDEX_URL=$PYPI_REPO_URL

# 4. Set working directory
WORKDIR /app

# 5. Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt && \
    echo "\n Installed platform packages:" && \
    pip list | grep platform- || echo "No platform packages found."

# 6. Copy source code
COPY . /app/

# 7. Expose port
EXPOSE 8000

# 8. Run Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
