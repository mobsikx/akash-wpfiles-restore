FROM wordpress:latest

RUN apt-get update -qq && apt-get install -y curl gpg zip cron

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install --bin-dir /usr/bin && rm -f awscliv2.zip

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

COPY ./apache2-background /usr/local/bin/apache2-background
RUN chmod +x /usr/local/bin/apache2-background

ENV CMS_DNS_A=hkfdsh.fans
ENV BACKUP_HOST="https://s3.filebase.com"
ENV BACKUP_SCHEDULE="*/15 * * * *"
ENV BACKUP_RETAIN="7 days"

COPY ./crontab /crontab

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-background"]
CMD ["/scripts/run.sh"]
