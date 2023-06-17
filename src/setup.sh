#!/bin/bash

# based on https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_tidyverse.sh

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

apt_install                    \
    libxml2-dev                \
    libcairo2-dev              \
    libgit2-dev                \
    default-libmysqlclient-dev \
    libpq-dev                  \
    libsasl2-dev               \
    libsqlite3-dev             \
    libssh2-1-dev              \
    libxtst6                   \
    libcurl4-openssl-dev       \
    libharfbuzz-dev            \
    libfribidi-dev             \
    libfreetype6-dev           \
    libpng-dev                 \
    libtiff5-dev               \
    libjpeg-dev                \
    unixodbc-dev

# personal apt packages
apt_install        \
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

install2.r --error --skipinstalled -n "$NCPUS" \
    tidyverse   \
    devtools    \
    rmarkdown   \
    BiocManager \
    vroom       \
    gert

# development packages and cran packages
install2.r --error --skipinstalled -n "$NCPUS" \
    covr           \
    devtools       \
    distro         \
    ggplot2        \
    knitr          \
    languageserver \
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

## dplyr database backends
install2.r --error --skipmissing --skipinstalled -n "$NCPUS" \
    arrow        \
    dbplyr       \
    DBI          \
    dtplyr       \
    duckdb       \
    nycflights13 \
    Lahman       \
    RMariaDB     \
    RPostgres    \
    RSQLite      \
    fst

## a bridge to far? -- brings in another 60 packages
# install2.r --error --skipinstalled -n "$NCPUS" tidymodels

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

# Directories
DEFAULT_USER=${DEFAULT_USER:-"rstudio"}

## working directory folder
mkdir -p /home/${DEFAULT_USER}/working-dir
cd /home/${DEFAULT_USER}/working-dir
wget https://raw.githubusercontent.com/jeksterslab/template/main/project.Rproj
echo "session-default-working-dir=/home/${DEFAULT_USER}/working-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/working-dir"

## project folder
mkdir -p /home/${DEFAULT_USER}/project-dir
cd /home/${DEFAULT_USER}/project-dir
echo "session-default-new-project-dir=/home/${DEFAULT_USER}/project-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/project-dir"

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

## Strip binary installed libraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so

# Installation information
echo -e "Session information...\n"
R -q -e "sessionInfo()"
echo -e "Installed packages...\n"
R -q -e "unname(installed.packages()[, 1])"
echo -e "\n$CONTAINER_RELEASE_MSG"
echo -e "\nBuild done!"
