FROM centos:6.7

RUN yum -y install epel-release

RUN yum -y update && \
    yum -y upgrade

# cmake is needed to build rez packages
# pip to manage python packages
RUN yum -y install python-pip cmake gcc \
    libffi-devel python-devel openssl-devel


# required to launch maya
# import maya.standalone
RUN yum -y install mesa-libGL \
    libXp-devel \
    libXmu \
    libXpm \
    libtiff \
    fontconfig \
    libXinerama \
    mesa-libGLU \
    libpng \
    libXrandr \
    libXcomposite \
    libxslt \
    pulseaudio-libs \
    libXi


RUN yum -y install mesa-libGLw libXp libXp-devel gamin audiofile audiofile-devel e2fsprogs-libs

#RUN pip install pip --upgrade
#RUN pip install setuptools --upgrade

# Where the code of rez's repo will live
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
