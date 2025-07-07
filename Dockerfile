FROM python:3.11-slim
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:securepassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitTunnel no/PermitTunnel yes/' /etc/ssh/sshd_config
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
ENV PYTHONUNBUFFERED=1
CMD service ssh start && gunicorn --bind 0.0.0.0:$PORT --timeout 300 main:app