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
ENV LCMS=lcms2-2.16
RUN curl -O -J -L http://downloads.sourceforge.net/lcms/$LCMS.tar.gz && \
	tar -xzf $LCMS.tar.gz && \
	cd $LCMS && ./configure && \
	make -j$(nproc) && make install && \
	cd .. && rm -rf $LCMS*

# Libtiff library for reading and writing Tagged Image File Format (TIFF) files.
ENV LIBTIFF=tiff-4.0.10
RUN curl -O -J -L http://download.osgeo.org/libtiff/$LIBTIFF.tar.gz && \
  	tar -xzf $LIBTIFF.tar.gz && \
  	cd $LIBTIFF && ./configure && \
  	make -j$(nproc) && make install && \
  	cd .. && rm -rf $LIBTIFF*

# Open-source C-Library for JPEG 2000
ENV OPENJPEG=openjpeg-2.1.0
RUN curl -O -J -L https://sourceforge.net/projects/openjpeg.mirror/files/2.1.0/$OPENJPEG.tar.gz && \
  	tar -xzf $OPENJPEG.tar.gz && \
  	cd $OPENJPEG && mkdir build && \
  	cd build && cmake3 ../ && \
  	make -j$(nproc) && make install && \
  	cd ../.. && rm -rf $OPENJPEG*

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

# Library for reading whole slide image files
# ENV OPENSLIDE=openslide-4.0.0
# RUN curl -O -J -L https://github.com/openslide/openslide/archive/refs/tags/v4.0.0.tar.gz && \
#   	tar -xzf $OPENSLIDE.tar.gz && \
#   	cd $OPENSLIDE && \
#   	./configure && \
#   	make -j$(nproc) && \
#   	make install && \
#   	cd .. && \
#   	rm -rf $OPENSLIDE*
ENV OPENSLIDE=openslide-3.4.1
RUN curl -O -J -L https://github.com/openslide/openslide/releases/download/v3.4.1/$OPENSLIDE.tar.gz && \
  	tar -xzf $OPENSLIDE.tar.gz && \
  	cd $OPENSLIDE && \
  	./configure && \
  	make -j$(nproc) && \
  	make install && \
  	cd .. && \
  	rm -rf $OPENSLIDE*

# OpenCV: Open Source Computer Vision Library

# Set up directories and clone OpenCV repositories
RUN mkdir /tmp/opencv_build && cd /tmp/opencv_build && \
    git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git

# Configure the build
RUN cd /tmp/opencv_build/opencv && mkdir build && cd build && \
    cmake3 -D CMAKE_BUILD_TYPE=RELEASE \
           -D CMAKE_INSTALL_PREFIX=/usr/local \
           -D INSTALL_C_EXAMPLES=ON \
           -D INSTALL_PYTHON_EXAMPLES=ON \
           -D OPENCV_GENERATE_PKGCONFIG=ON \
           -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_build/opencv_contrib/modules \
           -D BUILD_EXAMPLES=ON ..

# Build and install OpenCV
RUN cd /tmp/opencv_build/opencv/build && \
    make -j$(nproc) && \
    make install

# Configure shared libraries and pkg-config
RUN ln -s /usr/local/lib64/pkgconfig/opencv4.pc /usr/share/pkgconfig/ && \
    ldconfig

# Verify the installation
RUN pkg-config --modversion opencv4
# RUN ln -s /usr/local/lib/python*/site-packages/cv2  /usr/lib/python*/site-packages/

# Clean up
RUN rm -rf /tmp/opencv_build

# ITK: Insight Toolkit
# Install development tools and necessary dependencies
RUN yum -y install epel-release && \
    yum -y groupinstall "Development Tools" && \
    yum -y install \
        git \
        cmake3 \
        gcc \
        gcc-c++ \
        python3 \
        python3-devel \
        libX11-devel \
        libXt-devel \
        libXext-devel \
        libjpeg-devel \
        libpng-devel \
        libtiff-devel \
        zlib-devel \
        && yum clean all

# Set environment variables
ENV ITK_VERSION=5.4.1

# Download and extract ITK source code
RUN mkdir -p /tmp/itk_build && \
    cd /tmp/itk_build && \
    curl -O -J -L https://github.com/InsightSoftwareConsortium/ITK/archive/refs/tags/v${ITK_VERSION}.tar.gz && \
    tar -xzf ITK-${ITK_VERSION}.tar.gz

# Create build directory and configure the build with CMake
RUN mkdir -p /tmp/itk_build/ITK-${ITK_VERSION}/build && \
    cd /tmp/itk_build/ITK-${ITK_VERSION}/build && \
    cmake3 -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_INSTALL_PREFIX=/usr/local \
           ..

# Build and install ITK
RUN cd /tmp/itk_build/ITK-${ITK_VERSION}/build && \
    make -j$(nproc) && \
    make install

# Update shared library cache
RUN ldconfig

# Clean up temporary files to reduce image size
RUN rm -rf /tmp/itk_build

# Add data folder
RUN mkdir -p /data/input
RUN mkdir -p /data/output

CMD ["/bin/bash"]
