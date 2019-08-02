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

gcc -std=gnu99 -O2 -Wall -Wextra strbuf.o -c -o cjson/strbuf.c
gcc -std=gnu99 -O2 -Wall -Wextra lua_cjson.o -c -o cjson/lua_cjson.c
gcc -std=gnu99 -O2 -Wall -Wextra fpconv.o -c -o cjson/fpconv.c

gcc -std=gnu99 -O2 -Wall -Wextra auxiliar.o -c -o luasocket/auxiliar.c
gcc -std=gnu99 -O2 -Wall -Wextra buffer.o -c -o luasocket/buffer.c
gcc -std=gnu99 -O2 -Wall -Wextra except.o -c -o luasocket/except.c
gcc -std=gnu99 -O2 -Wall -Wextra inet.o -c -o luasocket/inet.c
gcc -std=gnu99 -O2 -Wall -Wextra io.o -c -o luasocket/io.c
gcc -std=gnu99 -O2 -Wall -Wextra luasocket.o -c -o luasocket/luasocket.c
gcc -std=gnu99 -O2 -Wall -Wextra mime.o -c -o luasocket/mime.c
gcc -std=gnu99 -O2 -Wall -Wextra options.o -c -o luasocket/options.c
gcc -std=gnu99 -O2 -Wall -Wextra select.o -c -o luasocket/select.c
gcc -std=gnu99 -O2 -Wall -Wextra tcp.o -c -o luasocket/tcp.c
gcc -std=gnu99 -O2 -Wall -Wextra timeout.o -c -o luasocket/timeout.c
gcc -std=gnu99 -O2 -Wall -Wextra udp.o -c -o luasocket/udp.c
gcc -std=gnu99 -O2 -Wall -Wextra usocket.o -c -o luasocket/usocket.c

gcc -std=gnu99 -O2 -Wall -Wextra sproto.o -c -o sproto.new/sproto.c
gcc -std=gnu99 -O2 -Wall -Wextra lsproto.o -c -o sproto.new/lsproto.c
gcc -std=gnu99 -O2 -Wall -Wextra pbc-lua.o -c -o pbc/binding/lua/pbc-lua.c

gcc tolua.o int64.o uint64.o pb.o lpeg.o struct.o strbuf.o lua_cjson.o fpconv.o auxiliar.o buffer.o except.o inet.o io.o \
	luasocket.o mime.o options.o select.o tcp.o timeout.o udp.o usocket.o sproto.o lsproto.o pbc-lua.o  \
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