FROM rocker/tidyverse

ADD src /usr/src/local/src
RUN chmod 777 /usr/src/local/src/setup.sh         && \
    ./usr/src/local/src/setup.sh                  && \
    rm -rf /usr/src/local/src

ENV PATH="/opt/TinyTeX/bin/x86_64-linux:${PATH}"
RUN /bin/bash -l -c 'echo export GH="$(git ls-remote https://github.com/mhunter1/dynr.git master)" > /etc/profile.d/docker_init.sh'