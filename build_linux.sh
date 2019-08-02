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

gcc -std=gnu99 -O2 -Wall -Wextra tolua.o -c -o tolua.c
gcc -std=gnu99 -O2 -Wall -Wextra int64.o -c -o int64.c
gcc -std=gnu99 -O2 -Wall -Wextra uint64.o -c -o uint64.c
gcc -std=gnu99 -O2 -Wall -Wextra pb.o -c -o pb.c
gcc -std=gnu99 -O2 -Wall -Wextra lpeg.o -c -o lpeg.c
gcc -std=gnu99 -O2 -Wall -Wextra struct.o -c -o struct.c

cd ./cjson
gcc -std=gnu99 -O2 -Wall -Wextra strbuf.o -c -o strbuf.c
gcc -std=gnu99 -O2 -Wall -Wextra lua_cjson.o -c -o lua_cjson.c
gcc -std=gnu99 -O2 -Wall -Wextra fpconv.o -c -o fpconv.c
cd ..

cd ./luasocket
gcc -std=gnu99 -O2 -Wall -Wextra auxiliar.o -c -o auxiliar.c
gcc -std=gnu99 -O2 -Wall -Wextra buffer.o -c -o buffer.c
gcc -std=gnu99 -O2 -Wall -Wextra except.o -c -o except.c
gcc -std=gnu99 -O2 -Wall -Wextra inet.o -c -o inet.c
gcc -std=gnu99 -O2 -Wall -Wextra io.o -c -o io.c
gcc -std=gnu99 -O2 -Wall -Wextra luasocket.o -c -o luasocket.c
gcc -std=gnu99 -O2 -Wall -Wextra mime.o -c -o mime.c
gcc -std=gnu99 -O2 -Wall -Wextra options.o -c -o options.c
gcc -std=gnu99 -O2 -Wall -Wextra select.o -c -o select.c
gcc -std=gnu99 -O2 -Wall -Wextra tcp.o -c -o tcp.c
gcc -std=gnu99 -O2 -Wall -Wextra timeout.o -c -o timeout.c
gcc -std=gnu99 -O2 -Wall -Wextra udp.o -c -o udp.c
gcc -std=gnu99 -O2 -Wall -Wextra usocket.o -c -o usocket.c
cd ..

cd ./sproto.new
gcc -std=gnu99 -O2 -Wall -Wextra sproto.o -c -o sproto.c
gcc -std=gnu99 -O2 -Wall -Wextra lsproto.o -c -o lsproto.c
gcc -std=gnu99 -O2 -Wall -Wextra pbc-lua.o -c -o pbc-lua.c
cd ..

gcc tolua.o int64.o uint64.o pb.o lpeg.o struct.o cjson/strbuf.o cjson/lua_cjson.o cjson/fpconv.o luasocket/auxiliar.o luasocket/buffer.o luasocket/except.o luasocket/inet.o luasocket/io.o \
	luasocket/luasocket.o luasocket/mime.o luasocket/options.o luasocket/select.o luasocket/tcp.o luasocket/timeout.o luasocket/udp.o luasocket/usocket.o \
	sproto.new/sproto.o sproto.new/lsproto.o pbc/binding/lua/pbc-lua.o  \
	-I./ \
	-Iluajit-2.1/src \
	-Iluasocket \
	-Isproto.new \
	-Ipbc \
	-Icjson \
	-lws2_32 \
	-Wl,--whole-archive \
	linux/x86_64/libluajit.a \
	-o ./Plugins/x86_64/tolua.so -shared -fPIC

make clean