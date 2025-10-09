# 1. Use official Python base image
FROM python:3.10-slim

# 2. Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Arguments for Azure Artifacts authentication
ARG AZ_USERNAME=sandeepbayyam
ARG AZ_TOKEN=1t1YNF1lTPSenTQCMb2y5sVztc32Rg3aD6jVKyzaTPdpGbwLpFQGJQQJ99BJACAAAAAAAAAAAAAGAZDOiaKn
ARG FEED_URL=https://pkgs.dev.azure.com/sandeepbayyam/_packaging/pypi-internal/pypi/simple/

# 4. Configure pip to use Azure Artifacts feed
ENV PIP_EXTRA_INDEX_URL="https://${AZ_USERNAME}:${AZ_TOKEN}@${FEED_URL}"

# 5. Set working directory inside container
WORKDIR /app

# 6. Copy dependency list and install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt && \
    echo "Internal platform packages:" && \
    pip list | grep platform- || echo "No platform packages found."

# 7. Copy project files into container
COPY . /app/

# 8. Expose port Django will run on
EXPOSE 8000

# 9. Default command — run development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
