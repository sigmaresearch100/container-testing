#!/bin/bash

set -e

## build ARGs
NCPUS=${NCPUS:--1}

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

# personal apt packages
apt_install        \
    git            \
    wget           \
    parallel       \
    vim            \
    nnn            \
    tmux           \
    curl           \
    less           \
    bat            \
    rsync          \
    openssh-server \
    neofetch

# radian
apt_install python3-pip
pip3 install -U radian

# development packages and cran packages
install2.r --error --skipinstalled -n "$NCPUS" \
    covr           \
    devtools       \
    distro         \
    ggplot2        \
    knitr          \
    lintr          \
    magick         \
    microbenchmark \
    pdftools       \
    pkgdown        \
    ragg           \
    remotes        \
    rmarkdown      \
    rprojroot      \
    styler         \
    testthat       \
    tidyverse      \
    qpdf           \
    semmcci        \
    betaDelta      \
    betaSandwich   \
    betaNB         \
    betaMC

# development packages from GitHub
R -e "remotes::install_github(  \
    c(                          \
        'rstudio/tinytex',      \
        'r-lib/cli',            \
        'r-lib/devtools',       \
        'r-hub/rhub'            \
    )                           \
)"
R -e "remotes::install_github(      \
    c(                              \
        'jeksterslab/rProject',     \
        'jeksterslab/semmcci',      \
        'jeksterslab/betaDelta',    \
        'jeksterslab/betaSandwich', \
        'jeksterslab/betaNB',       \
        'jeksterslab/betaMC'        \
    )                               \
)"
R -e "tinytex::install_tinytex( \
    bundle = 'TinyTeX',         \
    force = TRUE,               \
    dir =  '/opt/TinyTeX'       \
)"

## build details
echo "$(git ls-remote https://github.com/jeksterslab/docker-rocker.git main)" > /etc/profile.d/container_init.sh
awk '{print $1 > "/etc/profile.d/container_init.sh"}' /etc/profile.d/container_init.sh
CONTAINER_RELEASE=$(cat /etc/profile.d/container_init.sh)
echo "export CONTAINER_RELEASE=$CONTAINER_RELEASE" > /etc/profile.d/container_init.sh
CONTAINER_RELEASE_MSG="\"This release is based on the commit $CONTAINER_RELEASE.\""
echo "export CONTAINER_RELEASE_MSG=$CONTAINER_RELEASE_MSG" >> /etc/profile.d/container_init.sh
mkdir -p /srv/build
cd /srv/build
touch CONTAINER_RELEASE_MSG
touch CONTAINER_RELEASE
echo "$CONTAINER_RELEASE_MSG" > CONTAINER_RELEASE_MSG
sed -i s/\"//g CONTAINER_RELEASE_MSG
echo "$CONTAINER_RELEASE" > CONTAINER_RELEASE

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

# Installation information
echo -e "Session information...\n"
R -q -e "sessionInfo()"
echo -e "Installed packages...\n"
R -q -e "unname(installed.packages()[, 1])"
echo -e "\n$CONTAINER_RELEASE_MSG"
echo -e "\nBuild done!"
