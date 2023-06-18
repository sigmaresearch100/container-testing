FROM rocker/tidyverse

ADD src /usr/src/local/src
RUN chmod 777 /usr/src/local/src/setup.sh         && \
    ./usr/src/local/src/setup.sh                  && \
    rm -rf /usr/src/local/src

ENV PATH="/opt/TinyTeX/bin/x86_64-linux:${PATH}"

# extra metadata
LABEL author="Anderson A. Anderson <sigmaresearch100@gmail.com>"
LABEL description="sigmaresearch100/testing container."
