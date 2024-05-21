FROM python:3.10-slim-buster
# Set up the working directory
WORKDIR /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Copy a custom entrypoint script into the container
COPY ollama_start.sh /
RUN chmod +x /ollama_start.sh
CMD ["ollama_start.sh"]

# Set the working directory
WORKDIR /app
# Copy requirements file
COPY requirements.txt requirements.txt
# Create a virtual environment
RUN python -m venv venv

# Set the PATH to use the virtual environment
ENV PATH="/app/venv/bin:$PATH"

# Update package list and install necessary packages in a single step
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libffi-dev \
    cmake \
    libcurl4-openssl-dev \
    tini \
    systemd && \
    apt-get clean

# Upgrade pip and install dependencies
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh


RUN which ollama
# Expose the port the application uses (replace 11434 with the actual port)
EXPOSE 11434

# Copy the entire application
COPY . .

# Set proper permissions for the translations directory
RUN chmod -R 777 translations


# Copy the init script
COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

# Define the command to run the init script
CMD ["/bin/bash", "/app/init.sh"]
