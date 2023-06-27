FROM ubuntu:20.04
LABEL maintainer="theo.durand@cirad.fr"


WORKDIR /opt/seqtk

ARG DEBIAN_FRONTEND=noninteractive

#INSTALL DEPENDENCIES FOR KAT SEQTK AND JELLYFISH 
RUN apt-get update && apt-get install -y \
  git \
  make \
  gcc \
  libz-dev \
  libtool \
  libboost-all-dev \
  python3-dev \
  python3-matplotlib \
  python3-tabulate \
  python3-setuptools \
  libpython3-dev \
  python3-scipy \
  python3-numpy \
  wget \
  curl

#INSTALL SEQTK

RUN git clone https://github.com/lh3/seqtk && cd seqtk && make
RUN mv seqtk/seqtk /usr/bin/


#INSTALL KAT

RUN git clone https://github.com/TGAC/KAT.git && cd KAT && \
 ./build_boost.sh && \
 ./autogen.sh && \
 ./configure && \
 make && \
 make install


#INSTALL Jellyfish

RUN wget -O- https://github.com/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz | \
 tar zx && \
 cd jellyfish-2.3.0 && \
 ./configure --prefix=/usr && \
 make && make install && \
 rm -fr /jellyfish-2.3.0

#INSTALL PERL
RUN wget https://github.com/Perl/perl5/archive/refs/tags/v5.36.1.tar.gz \
  && tar fzx v5.36.1.tar.gz \
  && cd perl5-5.36.1 \
  && ./configure.gnu \
  && make \
  && make install 

RUN apt-get update && apt-get install -y \
  cpanminus \
  pkg-config
  

RUN wget https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.gz \
  && tar zxvf libgd-2.3.3.tar.gz \
  && cd libgd-2.3.3 \
  && ./configure \
  && make \
  && make install \
  && make installcheck \
  && cpanm --force GD::Simple \
  && cpanm --force GD::SVG \
  && cpanm --force Data::Dumper \
  && cpanm --force Getopt::Long

RUN apt-get update && apt-get install -y \
  locales \
  && export LANGUAGE=en_US.UTF-8 \
  && export LANG=en_US.UTF-8 \
  && export LC_ALL=en_US.UTF-8 \
  && locale-gen en_US.UTF-8 \
  && dpkg-reconfigure locales
