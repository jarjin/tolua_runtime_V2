#!/bin/bash

mkdir -p linux/x86_64
mkdir -p Plugins/x86_64

cd luajit-2.1
make clean
make BUILDMODE=static CC="gcc -m64 -O2" XCFLAGS=-DLUAJIT_ENABLE_GC64

cp src/libluajit.a ../linux/x86_64/libluajit.a
make clean

cd ../pbc/
make clean
make BUILDMODE=static CC="gcc -m64"
cp build/libpbc.a ../linux/x86_64/libpbc.a

cd ..

gcc -m64 -O2 -std=gnu99 -shared \
	int64.c \
	uint64.c \
	tolua.c \
	pb.c \
	lpeg.c \
	struct.c \
	cjson/strbuf.c \
	cjson/lua_cjson.c \
	cjson/fpconv.c \
	luasocket/auxiliar.c \
	luasocket/buffer.c \
	luasocket/except.c \
	luasocket/inet.c \
	luasocket/io.c \
	luasocket/luasocket.c \
	luasocket/mime.c \
	luasocket/options.c \
	luasocket/select.c \
	luasocket/tcp.c \
	luasocket/timeout.c \
	luasocket/udp.c \
	luasocket/wsocket.c \
	sproto.new/sproto.c \
	sproto.new/lsproto.c \
	pbc/binding/lua/pbc-lua.c \
	-o Plugins/linux/x86_64/tolua.so \
	-I./ \
	-Iluajit-2.1/src \
	-Iluasocket \
	-Isproto.new \
	-Ipbc \
	-Icjson \
	-lws2_32 \
	-Wl,--whole-archive \
	linux/x86_64/libluajit.a \
	linux/x86_64/libpbc.a \
	-Wl,--no-whole-archive -static-libgcc -static-libstdc++