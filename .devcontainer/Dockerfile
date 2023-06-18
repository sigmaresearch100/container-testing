FROM sigmaresearch100/testing

ADD src /usr/src/local/src
RUN chmod 777 /usr/src/local/src/setup.sh         && \
    ./usr/src/local/src/setup.sh                  && \
    rm -rf /usr/src/local/src

# extra metadata
LABEL author="Anderson A. Anderson <sigmaresearch100@gmail.com>"
LABEL description="sigmaresearch100/testing container."
