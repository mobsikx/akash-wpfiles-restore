FROM debian:testing-slim

RUN apt-get update -qq && apt-get install -y curl netcat-traditional gpg zip cron

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install --bin-dir /usr/bin && rm -Rf aws awscliv2.zip

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

RUN mkdir -p /root/.ssh
COPY ./id_rsa /root/.ssh/id_rsa
COPY ./id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/id_rsa*

ENV CMS_HOST=cms
ENV CMS_DNS_A=hkfdsh.fans
ENV BACKUP_HOST="https://s3.filebase.com"
ENV BACKUP_SCHEDULE="*/15 * * * *"
ENV BACKUP_RETAIN="7 days"

COPY ./crontab /crontab

CMD ["/scripts/run.sh"]
