FROM        scratch
MAINTAINER  Jakob Blomer <jblomer@cern.ch>

ARG SFTNIGHT_UID=500
ARG SFTNIGHT_GID=500

ADD         cc7_x86_64.tar.gz /
RUN         yum -y update;    \
	    yum -y install    \
		filesystem    \
		epel-release  \
		yum-plugin-ovl
# see https://github.com/CentOS/sig-cloud-instance-images/issues/15 for `yum-plugin-ovl`
RUN         yum -y install epel-release
RUN         yum -y install                     \
                       cmake                   \
                       curl-devel              \
                       fuse-devel              \
                       fuse3-devel             \
                       gcc                     \
                       gcc-c++                 \
                       git                     \
                       golang                  \
                       hardlink                \
                       libattr-devel           \
                       libcap-devel            \
                       libffi-devel            \
                       libuuid-devel           \
                       make                    \
                       openssl-devel           \
                       policycoreutils-python  \
                       python-devel            \
                       python-setuptools       \
                       rpm-build               \
                       ruby-devel              \
                       selinux-policy-devel    \
                       selinux-policy-targeted \
                       sysvinit-tools          \
                       which                   \
                       valgrind-devel          \
                       voms-devel              \
                       zlib-devel

# necessary to build the documentation
RUN         yum -y install doxygen

RUN  groupadd --gid $SFTNIGHT_GID sftnight && \
        adduser --uid $SFTNIGHT_UID --gid $SFTNIGHT_GID sftnight

# Relieve a bit the version requirement of selinux-policy
RUN yum -y downgrade \
  http://ftp.scientificlinux.org/linux/scientific/7.3/x86_64/os/Packages/selinux-policy-targeted-3.13.1-102.el7.noarch.rpm \
  http://ftp.scientificlinux.org/linux/scientific/7.3/x86_64/os/Packages/selinux-policy-devel-3.13.1-102.el7.noarch.rpm \
  http://ftp.scientificlinux.org/linux/scientific/7.3/x86_64/os/Packages/selinux-policy-3.13.1-102.el7.noarch.rpm

# Fix yum issues with Docker OverlayFS by installing this plugin
RUN yum -y install yum-plugin-ovl

RUN GOPATH=/usr/local go get github.com/jstemmer/go-junit-report

# Necessary for packing stuff
RUN yum -y install http://ecsft.cern.ch/dist/cvmfs/builddeps/togo-2.5-1.noarch.rpm && \
        mkdir -p /home/sftnight/.togo && chown sftnight /home/sftnight/.togo && chmod ugo+rwx /home/sftnight/.togo && \
        touch /home/sftnight/.rpmmacros && chown sftnight /home/sftnight/.rpmmacros && chmod ugo+rw /home/sftnight/.rpmmacros

USER        sftnight

WORKDIR     /home/sftnight
