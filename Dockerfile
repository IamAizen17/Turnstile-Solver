FROM mcr.microsoft.com/playwright/python:v1.48.0-jammy

# Install all system dependencies Playwright browsers require
RUN apt-get update && apt-get install -y \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libasound2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python deps
RUN pip install --no-cache-dir playwright

# Install Playwright browsers (Chromium, Firefox, WebKit)
RUN playwright install --with-deps

# Copy your solver script
WORKDIR /app
COPY async_solver.py /app/async_solver.py

# Default command: run async_solver.py with headless and useragent
CMD ["python3", "async_solver.py", "--headless", "True", "--useragent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.9508.139 Safari/537.36"]
