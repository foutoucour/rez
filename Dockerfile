FROM centos:6.7

RUN yum -y update && \
    yum -y upgrade && \
    yum -y install epel-release

# cmake is needed to build rez packages
# pip to manage python packages
RUN yum -y install python-pip cmake gcc \
    libffi-devel python-devel openssl-devel

RUN pip install pip --upgrade
RUN pip install setuptools --upgrade

# Where the code of rez's repo will leave
ENV REZ_INSTALL=/opt/.rez_repo
# Where rez will be installed
ENV REZ=/opt/rez
# Folder where the packages will be installed
ENV REZ_BUILD_PACKAGES=/root/packages
ENV REZ_PACKAGES=/root/workspace/rez_packages

WORKDIR $REZ_PACKAGES

# Rez code
ADD . $REZ_INSTALL

# Rez installation
RUN python $REZ_INSTALL/install.py -v $REZ

# Rez environment and setup
ENV PATH=$REZ/bin/rez:$PATH
RUN . $REZ/completion/complete.sh
RUN mkdir $REZ_BUILD_PACKAGES
RUN rez-bind --quickstart
