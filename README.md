# Docker Base Image for Image Segmentation

This Dockerfile sets up a CentOS-based environment with essential tools and libraries for software development, image processing, and data analysis. Below is an overview of what it installs:

## Installed Tools and Libraries

1. **Development Tools**:
   - `gcc`, `gcc-c++`, `make`, `cmake`
   - Group install of "Development Tools"

2. **Image Processing Libraries**:
   - **Little CMS** (lcms2-2.16) for color management
   - **libtiff** (tiff-4.0.10) for TIFF image format support
   - **OpenJPEG** (openjpeg-2.1.0) for JPEG 2000 support
   - **OpenSlide** (openslide-3.4.1) for whole slide image support
   - **OpenCV** (opencv-4x) for computer vision and image processing tasks
   - **Insight Toolkit** (ITK-5.4.1) for medical image analysis and registration

3. **Other Utilities**:
   - `vim`, `wget`, `curl`, `git`, `zip`, `unzip`
   - Python 3 development tools and `numpy`

4. **System Libraries**:
   - `libxml2-devel`, `sqlite-devel`, `ncurses-devel`

<br>
