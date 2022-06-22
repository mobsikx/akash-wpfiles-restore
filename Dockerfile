FROM debian:testing-slim

RUN apt-get update -qq && apt-get install -y tini curl netcat-traditional gpg zip cron sshpass

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install --bin-dir /usr/bin && rm -Rf aws awscliv2.zip

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

COPY ./pass /tmp/pass
RUN chmod 600 /tmp/pass

ENV CMS_HOST=cms
ENV CMS_DNS_A=hkfdsh.fans
ENV BACKUP_HOST="https://s3.filebase.com"
ENV BACKUP_SCHEDULE="*/15 * * * *"
ENV BACKUP_RETAIN="7 days"

COPY ./crontab /crontab
ENTRYPOINT ["/usr/sbin/tini", "--"]
CMD ["/scripts/run.sh"]
