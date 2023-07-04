#!/bin/bash -e

## Dependency versions

v_sdk=9123335_latest
v_ndk=25.1.8937393
v_sdk_build_tools=33.0.1

v_lua=5.2.4
v_mbedtls=3.3.0
v_libplacebo=5.229.2
v_dav1d=1.1.0
v_ffmpeg=5.1.2
v_mpv=0.35.1


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_dav1d=()
dep_ffmpeg=(mbedtls dav1d)
dep_lua=()
dep_shaderc=()
dep_libplacebo=(shaderc)
dep_mpv=(ffmpeg lua libplacebo)
dep_mpv_android=(mpv)

