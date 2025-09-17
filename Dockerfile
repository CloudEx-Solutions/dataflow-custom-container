FROM python:3.11-slim

# Set a working directory


WORKDIR /app



# Copy the launcher binary from the first stage into our main image
COPY --from=apache/beam_python3.11_sdk:2.67.0 /opt/apache/beam /opt/apache/beam

COPY --from=gcr.io/dataflow-templates-base/python311-template-launcher-base /opt/google/dataflow/python_template_launcher /opt/google/dataflow/

# Install system-level dependencies like ffmpeg

RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*
    
# Copy all your application code and dependency files
# We'll use a single requirements.txt for simplicity.
COPY requirements.txt .
COPY setup.py .
COPY pyproject.toml .
COPY src src
COPY main.py .

# Pre-install all Python dependencies, including your own package.
# This makes worker startup extremely fast.
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install .
RUN pip check

# Set the environment variable to point to your pipeline's entrypoint file.
ENV FLEX_TEMPLATE_PYTHON_PY_FILE=/app/main.py

# Set the entrypoint to the launcher binary.
ENTRYPOINT ["/opt/apache/beam/boot"]
