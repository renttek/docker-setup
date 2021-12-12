FROM docker.elastic.co/elasticsearch/elasticsearch-oss:7.9.3

LABEL maintainer="juliann@renttek.de"

ENV discovery.type=single-node

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic; \
    /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu

