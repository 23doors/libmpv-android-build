#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

cpu=armv7-a
[[ "$ndk_triple" == "aarch64"* ]] && cpu=armv8-a
[[ "$ndk_triple" == "x86_64"* ]] && cpu=generic
[[ "$ndk_triple" == "i686"* ]] && cpu="i686 --disable-asm"

cpuflags=
[[ "$ndk_triple" == "arm"* ]] && cpuflags="$cpuflags -mfpu=neon -mcpu=cortex-a8"

../configure \
	--target-os=android --enable-cross-compile --cross-prefix=$ndk_triple- --cc=$CC \
	--arch=${ndk_triple%%-*} --cpu=$cpu --pkg-config=pkg-config \
	--extra-cflags="-I$prefix_dir/include $cpuflags" --extra-ldflags="-L$prefix_dir/lib" \
	--enable-{jni,mediacodec,mbedtls,libdav1d} --disable-vulkan \
	--disable-static --enable-shared --enable-version3 \
	--disable-{stripping,doc,programs} \
	--enable-network \
	--enable-protocol=async \
	--enable-protocol=cache \
	--enable-protocol=data \
	--enable-protocol=ffrtmphttp \
	--enable-protocol=file \
	--enable-protocol=ftp \
	--enable-protocol=hls \
	--enable-protocol=http \
	--enable-protocol=httpproxy \
	--enable-protocol=https \
	--enable-protocol=mmsh \
	--enable-protocol=mmst \
	--enable-protocol=pipe \
	--enable-protocol=rtmp \
	--enable-protocol=rtmps \
	--enable-protocol=rtmpt \
	--enable-protocol=rtmpts \
	--enable-protocol=rtp \
	--enable-protocol=sctp \
	--enable-protocol=srtp \
	--enable-protocol=subfile \
	--enable-protocol=tcp \
	--enable-protocol=tls \
	--enable-protocol=udp \
	--enable-protocol=udplite \
	--enable-protocol=unix \
	--enable-protocol=rist \
	--enable-protocol=srt \
	--enable-protocol=sftp \
	--disable-iconv \
	--disable-bzlib \
	--disable-lzma \
	--disable-sdl2 \
	--disable-schannel \
	--disable-securetransport \
	--disable-xlib \
	--disable-d3d11va \
	--disable-nvenc \
	--disable-dxva2 \
	--disable-bsfs \
	--disable-indevs \
	--disable-outdevs \
	--disable-bsfs \
	--disable-muxers \
	--disable-demuxers \
	--disable-encoders \
	--disable-decoders \
	--disable-filters \
	--disable-parsers \
	--enable-demuxer=image2 \
	--enable-demuxer=aac \
	--enable-demuxer=ac3 \
	--enable-demuxer=aiff \
	--enable-demuxer=ape \
	--enable-demuxer=asf \
	--enable-demuxer=au \
	--enable-demuxer=avi \
	--enable-demuxer=flac \
	--enable-demuxer=flv \
	--enable-demuxer=matroska \
	--enable-demuxer=mov \
	--enable-demuxer=m4v \
	--enable-demuxer=mp3 \
	--enable-demuxer=mpc* \
	--enable-demuxer=ogg \
	--enable-demuxer=pcm* \
	--enable-demuxer=rm \
	--enable-demuxer=shorten \
	--enable-demuxer=tak \
	--enable-demuxer=tta \
	--enable-demuxer=wav \
	--enable-demuxer=wv \
	--enable-demuxer=xwma \
	--enable-demuxer=dsf \
	--enable-demuxer=dts \
	--enable-demuxer=truehd \
	--enable-decoder=aac* \
	--enable-decoder=ac3 \
	--enable-decoder=alac \
	--enable-decoder=als \
	--enable-decoder=ape \
	--enable-decoder=atrac* \
	--enable-decoder=eac3 \
	--enable-decoder=flac \
	--enable-decoder=gsm* \
	--enable-decoder=mp1* \
	--enable-decoder=mp2* \
	--enable-decoder=mp3* \
	--enable-decoder=mpc* \
	--enable-decoder=opus \
	--enable-decoder=ra* \
	--enable-decoder=ralf \
	--enable-decoder=shorten \
	--enable-decoder=tak \
	--enable-decoder=tta \
	--enable-decoder=vorbis \
	--enable-decoder=wavpack \
	--enable-decoder=wma* \
	--enable-decoder=pcm* \
	--enable-decoder=dsd* \
	--enable-decoder=truehd \
	--enable-decoder=mjpeg \
	--enable-decoder=ljpeg \
	--enable-decoder=jpegls \
	--enable-decoder=jpeg2000 \
	--enable-decoder=png \
	--enable-decoder=gif \
	--enable-decoder=bmp \
	--enable-decoder=tiff \
	--enable-decoder=webp \
	--enable-decoder=jpegls \
	--enable-parser=aac* \
	--enable-parser=ac3 \
	--enable-parser=cook \
	--enable-parser=dca \
	--enable-parser=flac \
	--enable-parser=gsm \
	--enable-parser=mpegaudio \
	--enable-parser=tak \
	--enable-parser=vorbis \
	--enable-filter=overlay \
	--enable-filter=equalizer \

make -j$cores
make DESTDIR="$prefix_dir" install

ln -sf "$prefix_dir"/lib/libswresample.so "$native_dir"
ln -sf "$prefix_dir"/lib/libpostproc.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavutil.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavcodec.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavformat.so "$native_dir"
ln -sf "$prefix_dir"/lib/libswscale.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavfilter.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavdevice.so "$native_dir"
