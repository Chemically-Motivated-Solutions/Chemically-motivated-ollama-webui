#!/bin/bash

# Start Ollama in the background.
/bin/ollama serve &
# Record Process ID.
pid=$!

# Pause for Ollama to start.
sleep 5

echo "🔴 Retrieve LLAMA3 model..."
/bin/ollama pull llama3
echo "🟢 Done!"
# Wait for Ollama process to finish.
wait $pid
# Start the Python application
echo "Starting Python application..."
python ./run.py


