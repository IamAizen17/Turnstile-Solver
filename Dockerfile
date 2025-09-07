FROM mcr.microsoft.com/playwright/python:v1.48.0-jammy

# Install required system dependencies for browsers
RUN apt-get update && apt-get install -y --no-install-recommends \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libasound2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
        fastapi \
        uvicorn[standard] \
        asyncio \
        argparse \
        patchright \
        "camoufox[geoip]"

# Install Playwright browsers (Chromium only for solving Turnstile)
RUN playwright install --with-deps chromium

# Expose FastAPI port
EXPOSE 7860

# Run FastAPI app
CMD ["uvicorn", "rias:app", "--host", "0.0.0.0", "--port", "7860"]
