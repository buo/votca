FROM fedora:latest

RUN dnf -y install make cmake git gcc-c++ gromacs-devel expat-devel fftw-devel gsl-devel boost-devel txt2tags sqlite-devel gromacs tar wget

RUN wget http://ftp.gromacs.org/pub/gromacs/gromacs-2016.1.tar.gz \
    && tar xfz gromacs-2016.1.tar.gz \
    && cd gromacs-2016.1 \
    && mkdir build \
    && cd build \
    && cmake .. -DGMX_GPU=OFF -DGMX_BUILD_OWN_FFTW=OFF -DGMX_USE_RDTSCP=OFF -DREGRESSIONTEST_DOWNLOAD=ON \
    && make \
    && make check \
    && make install

RUN prefix=/usr/local/votca \
    && mkdir -p ${prefix}/src \
    && cd ${prefix}/src \
    && wget https://raw.githubusercontent.com/votca/buildutil/master/build.sh \
    && chmod +x build.sh \
    && ./build.sh --prefix ${prefix} -ud tools csg

RUN useradd -m votca
USER votca
WORKDIR /home/votca

RUN git clone https://github.com/votca/csg-tutorials.git csg-tutorials

RUN echo "source /usr/local/gromacs/bin/GMXRC" | tee -a ~/.bashrc \
    && echo "source /usr/local/votca/bin/VOTCARC.bash" | tee -a ~/.bashrc

CMD [ "bash" ]
