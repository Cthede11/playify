
FROM python:3.11-slim
WORKDIR /app

# Create non-root user for security
RUN groupadd -r playify && useradd -r -g playify playify

# Install FFmpeg and Playwright dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    git \
    chromium && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Install playwright and its dependencies
RUN pip install playwright && playwright install-deps && playwright install

COPY . .

# Change ownership to non-root user
RUN chown -R playify:playify /app

# Switch to non-root user
USER playify

CMD ["python", "playify.py"]
