FROM python:3.12-slim
LABEL authors="DigitalDots <support@digitaldots.ai>"

# Environment setting
ENV DEBIAN_FRONTEND=noninteractive
ENV APP_ENVIRONMENT=production
ENV PIP_USE_PEP517=true
ARG PYPI_REPO_URL

# Software Packages installation
RUN apt-get update -y \
    && apt-get install -y build-essential python3-dev libffi-dev libssl-dev libkrb5-dev wget \
    libgd-dev libssl-dev libxml2 libxml2-dev uuid-dev zlib1g zlib1g-dev \
    g++ gcc git make musl-dev \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Application Setup
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN python3 -m pip install --upgrade --no-cache-dir pip
RUN pip3 install --upgrade --no-cache-dir setuptools wheel

ENV PIP_EXTRA_INDEX_URL=${PYPI_REPO_URL}
RUN pip3 install --no-cache-dir -r requirements.txt && \
    echo "\n Installed platform packages:" && \
    pip list | grep platform- || echo "No platform packages found."

# Copy source code
COPY . /app/

# Expose port
EXPOSE 8000

# 8. Run Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
