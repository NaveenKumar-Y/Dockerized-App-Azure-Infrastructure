# Import base image python
FROM python:3.11-slim

# Create a non-root user
RUN useradd -m appuser

# Set working directory and copy .py files
WORKDIR /app
COPY *.py /app/

# Install Flask
RUN pip install flask

# Set permissions & switch to non-root user user
RUN chown -R appuser:appuser /app \
    chmod +x /app/*.py
USER appuser

# Expose port and run the application when container is up.
EXPOSE 18630
CMD ["python", "SimpleTimeServiceapp.py"]
