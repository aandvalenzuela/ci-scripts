FROM        scratch
MAINTAINER  Jakob Blomer <jblomer@cern.ch>

ADD         ubuntu1404_x86_64.tar.gz /
RUN         apt-get -y update && apt-get -y upgrade
RUN         apt-get -y update && apt-get -y install                        \
                                              autotools-dev                \
                                              cmake                        \
                                              cpio                         \
                                              debhelper                    \
                                              devscripts                   \
                                              gdb                          \
                                              git                          \
                                              libattr1-dev                 \
                                              libcap-dev                   \
                                              libfuse-dev                  \
                                              libssl-dev                   \
                                              pkg-config                   \
                                              python-dev                   \
                                              python-setuptools            \
                                              unzip                        \
                                              uuid-dev                     \
                                              valgrind
