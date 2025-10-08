# 1. Use official Python base image
FROM python:3.10-slim

# 2. Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# 3. Set working directory inside container
WORKDIR /app

# 4. Copy dependency list and install
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy project files into container
COPY . /app/

# 6. Expose port Django will run on
EXPOSE 8000

# 7. Default command — run development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
