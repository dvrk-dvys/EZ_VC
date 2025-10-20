# Multi-stage build for EZ_RVC with NumPy compatibility fixes
FROM python:3.10-slim as base

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    ffmpeg \
    libsndfile1 \
    libsndfile1-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better Docker layer caching
COPY requirements.txt .

# CRITICAL: Install exact versions to prevent NumPy 2.x compatibility issues
# Install core numeric stack first with exact versions
RUN pip install --no-cache-dir \
    numpy==1.26.4 \
    scipy==1.11.4 \
    numba==0.58.1 \
    llvmlite==0.41.1

# Install PyAnnote with specific versions to avoid np.NaN errors
RUN pip install --no-cache-dir --no-deps \
    pyannote.audio==3.0.1 \
    pyannote.core==5.0.0 \
    pyannote.pipeline==3.0.1

# Install remaining dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install HuggingFace Hub CLI for authentication
RUN pip install --no-cache-dir huggingface_hub[cli]

# Copy application code
COPY . .

# Copy .env file and authenticate with HuggingFace
COPY .env .
RUN export $(cat .env | xargs) && echo $hugging_face_token | huggingface-cli login --token $hugging_face_token

# Create necessary directories
RUN mkdir -p /app/data /app/logs /app/models

# Expose port for FastAPI
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
  CMD python -c "import numpy, pyannote.audio; print('Health check passed')" || exit 1

# Default command
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
