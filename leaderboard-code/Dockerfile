FROM python:3.9

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create directory for MiniZinc
RUN mkdir -p /opt/minizinc

# Download and extract MiniZinc bundle
RUN wget https://github.com/MiniZinc/MiniZincIDE/releases/download/2.9.0/MiniZincIDE-2.9.0-bundle-linux-x86_64.tgz && \
    tar xzf MiniZincIDE-2.9.0-bundle-linux-x86_64.tgz -C /opt/minizinc --strip-components=1 && \
    rm MiniZincIDE-2.9.0-bundle-linux-x86_64.tgz

# Add MiniZinc bin to system PATH
ENV PATH="/opt/minizinc/bin:$PATH"

# Create necessary directories for data persistence
RUN mkdir -p /app/submissions /app/results
RUN chmod 777 /app/submissions /app/results

# Set up non-root user
RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:/opt/minizinc/bin:$PATH"
ENV HOME="/home/user"

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY --chown=user ./requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy application files
COPY --chown=user . /app

# Make script executable
RUN chmod +x evaluation_script.py

# Command to run the Gradio app
CMD ["python", "app.py"]