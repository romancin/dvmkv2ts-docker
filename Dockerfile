FROM ubuntu

ENV DOVI_TOOL_VERSION="2.0.3"
ENV TSMUXER_VERSION="nightly-2023-04-13-02-05-26"
ENV MAKEMKV_VERSION="1.17.2"
ENV FFMPEG_VERSION="4.4.4"

RUN apt update && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
	apt install -y git wget unzip ffmpeg ttf-mscorefonts-installer && \
	fc-cache -f && \
    apt install -y gcc build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev

RUN echo "Installing DV applications..." && \
    # Install ffmpeg
    wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
    tar -xjvf ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
    cd ffmpeg-${FFMPEG_VERSION} && \
    ./configure --prefix=/tmp/ffmpeg --enable-gpl --enable-nonfree --enable-static --disable-shared --enable-pic --disable-x86asm --disable-all --disable-autodetect --disable-everything --enable-swresample --enable-avcodec --enable-encoder=flac,aac,ac3,ac3_fixed --enable-decoders && \
    make && \
    make install && \
    cd .. && \
    rm -rf ffmpeg-${FFMPEG_VERSION}.tar.bz2 ffmpeg-${FFMPEG_VERSION} && \
    # Install dovi tool
	wget -c https://github.com/quietvoid/dovi_tool/releases/download/${DOVI_TOOL_VERSION}/dovi_tool-${DOVI_TOOL_VERSION}-x86_64-unknown-linux-musl.tar.gz -O - | tar -xz -C /usr/local/bin && \
    # Install makemkv
    wget -c https://www.makemkv.com/download/makemkv-oss-${MAKEMKV_VERSION}.tar.gz -O makemkv.tar.gz && \
    tar zxvf makemkv.tar.gz && \
    cd makemkv-oss-${MAKEMKV_VERSION} && \
    CFLAGS="-std=gnu++11" PKG_CONFIG_PATH="/tmp/ffmpeg/lib/pkgconfig" ./configure --disable-gui && \
    make && \
    make install && \
    cd .. && \
    rm -rf makemkv.tar.gz makemkv-oss-${MAKEMKV_VERSION} && \
    # Install makemkvcon
    wget -c https://www.makemkv.com/download/makemkv-bin-${MAKEMKV_VERSION}.tar.gz -O makemkv.tar.gz && \
    tar zxvf makemkv.tar.gz && \
    cd makemkv-bin-${MAKEMKV_VERSION} && \
    mkdir tmp && \
    echo "accepted" > tmp/eula_accepted && \
    make && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf makemkv.tar.gz makemkv-bin-${MAKEMKV_VERSION} && \
    # Install TSmuxer
    wget -c https://github.com/justdan96/tsMuxer/releases/download/nightly-2023-01-02-02-15-09/lnx.zip -O /tmp/lnx.zip && \
    unzip /tmp/lnx.zip -d /usr/local/bin && \
    mv /usr/local/bin/bin/lnx/* /usr/local/bin && \
    rm -rf /usr/local/bin/bin/lnx/ && \
    rm /tmp/lnx.zip && \
    cd /usr/local/bin && \
	git clone https://github.com/abakum/tsmuxerCLI.git && \
	mv tsmuxerCLI/* . && \
	chmod 755 * && \
	ln -s tsMuxeR tsmuxer && \
	ln -s /usr/bin/python3 /usr/bin/python

COPY /dvmkv2ts /usr/local/bin

RUN chmod a+x /usr/local/bin/dvmkv2ts

#RUN apt-get remove -y --purge gcc build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev && \
#    apt-get autoremove -y --purge && \
#    apt-get autoclean

VOLUME ["/convert"]

WORKDIR /convert

ENTRYPOINT ["dvmkv2ts"]
