#
# Set up development tools for segmentation.
#
FROM centos:latest
LABEL maintainer="Tammy DiPrima"

RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

    RUN yum -y update && yum -y install epel-release && \
        yum -y install \
        gcc \
        gcc-c++ \
        make \
        cairo-devel \
        curl \
        gdk-pixbuf2-devel \
        git \
        gtk2-devel \
        libjpeg-turbo-devel \
        libuuid \
        libuuid-devel \
        ncurses-devel \
        pkgconfig \
        python3-devel \
        python3-numpy \
        tbb \
        tbb-devel \
        unzip \
        valgrind \
        valgrind-devel \
        vim \
        wget \
        zip

# Installing for group install "Development Tools"
RUN yum -y groupinstall "Development Tools"

RUN yum -y install libxml2-devel
RUN yum -y install sqlite-devel
RUN yum -y install cmake*

# Install libraries
WORKDIR /tmp/

# Little cms color engine
ENV LCMS=lcms2-2.8
RUN curl -O -J -L http://downloads.sourceforge.net/lcms/$LCMS.tar.gz && \
	tar -xzvf $LCMS.tar.gz && \
	cd $LCMS && ./configure && \
	make -j4 && make install && \
	cd .. && rm -rf $LCMS*

# Libtiff library for reading and writing Tagged Image File Format (TIFF) files.
ENV LIBTIFF=tiff-4.0.6
RUN curl -O -J -L http://download.osgeo.org/libtiff/$LIBTIFF.tar.gz && \
  	tar -xzvf $LIBTIFF.tar.gz && \
  	cd $LIBTIFF && ./configure && \
  	make -j4 && make install && \
  	cd .. && rm -rf $LIBTIFF*

# Open-source C-Library for JPEG 2000
ENV OPENJPEG=openjpeg-2.1.0
RUN curl -O -J -L https://sourceforge.net/projects/openjpeg.mirror/files/2.1.0/$OPENJPEG.tar.gz && \
  	tar -xzvf $OPENJPEG.tar.gz && \
  	cd $OPENJPEG && mkdir build && \
  	cd build && cmake3 ../ && \
  	make -j4 && make install && \
  	cd ../.. && rm -rf $OPENJPEG*

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

# Library for reading whole slide image files
ENV OPENSLIDE=openslide-3.4.1
RUN curl -O -J -L https://github.com/openslide/openslide/releases/download/v3.4.1/$OPENSLIDE.tar.gz && \
  	tar -xzvf $OPENSLIDE.tar.gz && \
  	cd $OPENSLIDE && \
  	./configure && \
  	make -j4 && \
  	make install && \
  	cd .. && \
  	rm -rf $OPENSLIDE*

# TODO: add opencv
# OpenCV: Open Source Computer Vision Library
# ENV OPEN1=2.4.13
# ENV OPEN2=opencv-$OPEN1
# RUN CC=gcc CXX=g++ curl -O -J -L https://github.com/opencv/opencv/archive/$OPEN1.zip && \
#     unzip $OPEN2.zip && \
#     mkdir /tmp/opencv-build && \
#     cd /tmp/opencv-build && \
#     CC=gcc CXX=g++ cmake -D CMAKE_BUILD_TYPE=RELEASE \
#     -D CMAKE_C_COMPILER=/usr/bin/gcc \
#     -D CMAKE_CXX_COMPILER=/usr/bin/g++ \
#     -D BUILD_TESTS=OFF \
#     -D CMAKE_INSTALL_PREFIX=/usr/local \
#     -D CMAKE_CXX_STANDARD=11 \
#     -D BUILD_EXAMPLES=OFF \
#     -D WITH_CUDA=OFF \
#     -D BUILD_DOCS=OFF \
#     -D BUILD_PERF_TESTS=OFF \
#     -D BUILD_opencv_python=OFF \
#     -D BUILD_opencv_java=OFF \
#     ../$OPEN2 && \
#     make -j4 && \
#     make install && \
#     cd /tmp && \
#     rm -rf opencv-build && \
#     rm -rf $OPEN2*

# TODO: add itk
# Insight Toolkit
# ENV ITK=ITK-4.10.0
# RUN curl -O -J -L https://github.com/InsightSoftwareConsortium/ITK/archive/refs/tags/v4.10.0.tar.gz && \
#   	tar -xzvf ITK-4.10.0.tar.gz && \
#   	mkdir -p /tmp/itk-build && \
#   	cd /tmp/itk-build && \
#   	cmake -D BUILD_EXAMPLES:BOOL=OFF -D BUILD_TESTING:BOOL=OFF -D BUILD_TESTS:BOOL=OFF -D Module_ITKVideoBridgeOpenCV:BOOL=ON -D Module_ITKReview:BOOL=ON ../$ITK && \
#   	make -j4 && \
#   	make install && \
#   	cd /tmp && \
#   	rm -rf itk-build && \
#   	rm -rf $ITK*

# Add data folder
RUN mkdir -p /data/input
RUN mkdir -p /data/output

CMD ["/bin/bash"]
