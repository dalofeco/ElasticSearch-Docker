FROM openjdk:11-jre-slim
ENV DEBIAN_FRONTEND noninteractive

# Build arguments
ARG version
ARG uid
ARG gid

# Install dependencies and utils
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils wget gnupg

# Install elastic search gpg key and repo, then install it
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list && \
    apt-get update && \
    apt-get install -y elasticsearch=$version && \
    apt-get autoremove -y && \
    apt-get clean -y

# Define working directory
WORKDIR /usr/share/elasticsearch

# Modify elasticsearch user
RUN groupmod --gid $gid elasticsearch && \
    usermod --uid $uid --gid $gid --shell /usr/sbin/nologin --home /usr/share/elasticsearch elasticsearch && \
    chown $uid:$gid /etc/default/elasticsearch && \
    chown -R $uid:$gid /etc/elasticsearch /var/log/elasticsearch /var/lib/elasticsearch

RUN mkdir backups && mkdir data && \
    chown -R $uid:$gid /usr/share/elasticsearch && \
    chown -R $uid:$gid /usr/share/elasticsearch/data /usr/share/elasticsearch/backups

USER elasticsearch:elasticsearch

EXPOSE 9200
EXPOSE 9300

CMD ["bin/elasticsearch"]