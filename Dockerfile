FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

ENV FLAME_GRAPH_TRUSTED_COMMIT 1b1c6deede9c33c5134c920bdb7a44cc5528e9a7

RUN apt-get update && \
    apt-get install -y \
      git \
    && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin

RUN git clone https://github.com/brendangregg/FlameGraph.git && \
    cd /FlameGraph && \
    git checkout $FLAME_GRAPH_TRUSTED_COMMIT && \
    [[ $(git rev-parse HEAD) == $FLAME_GRAPH_TRUSTED_COMMIT ]]

WORKDIR /FlameGraph
