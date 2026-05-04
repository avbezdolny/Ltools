

# windows-lua-luarocks-install-guide
Guide how to install lua and luarocks in window pc

The guide is an updated version of [this guide](https://github.com/d954mas/windows-lua-luarocks-install-guide), with some slight modifications:
1. The build tool changed from `MINGW` to [MINGW64](https://www.mingw-w64.org/), a 64-bit fork of `MINGW`. Do not download from [osdn.net](https://osdn.net/projects/mingw/). The site's security certificate has expired and has been hijacked by some company no longer affiliated with GNU.
2. How to install/compile the [luasql](https://lunarmodules.github.io/luasql/index.html) package on Windows using luarocks. This package requires some extra steps to get working in Windows. 

Credits also to [awesome guide](https://web.archive.org/web/20210724103543/http://www.thijsschreijer.nl/blog/?p=863), the original version.

What will this tutorial be doing;

 1. Install a compiler (MINGW64 (and MSYS2))
 2. Compile and install Lua
 3. Install LuaRocks
 4. Install luasql-odbc, a LuaRocks package

# Installing the compiler

-   Download and install [MSYS2](https://www.msys2.org/). `MSYS2` is a Windows package manager for build tools like `MINGW64`.
-   Open the start menu and type ‘mingw64’, once ‘MYS2 MINGW64’ is found, open it. It will give a shell prompt like this:
![image](https://github.com/Arethusag/windows-lua-luasql-install-guide/assets/101961801/cf1b0a05-049b-4a75-a0c0-972b064c64de)
-   Install the [MINGW64 toolchain](https://packages.msys2.org/groups/mingw-w64-x86_64-toolchain) using Pacman (e.g. pacman -S `mingw-w64-x86_64-toolchain`)

As we will later be using the compiler, we need to make sure that the compiler can be found on the system. To do this, its location must be added to the system path. Here’s how;

-   right-click ‘my computer’ and select ‘properties’, click ‘advanced system settings’, select tab ‘advanced’, click ‘Environment variables…’
-   find the entry ‘PATH’ under ‘system variables’, and add ‘**c:\msys64\mingw64\bin**’ (use a semicolon ‘;’ as a separator) to this variable.

We won’t be adding MSYS to the path, as it has some Unix like utilities that might interfere with the Windows tools.

- **IMPORTANT** The luasql-odbc Makefile expects `mingw32-make` to be in the users path, but the `MINGW64` toolchain has the `x86_64-w64-` prefix on the executable file names, which means that they can't be found. Use something like power rename to remove this prefix from all executables in `c:\msys64\mingw64\bin` so that i.e. `x86_64-w64-mingw32-make.exe` becomes `mingw32-make.exe`.

# Installing Lua

-   [Download Lua source code](http://www.lua.org/ftp/). For this tutorial we’ll be using ‘lua-5.1.5.tar.gz’, but a later version should be easy to use as well.
-   Create a temporary folder ‘c:\temp\’ and store the downloaded file there. Open it and inside there will be a ‘lua-5.1.5’ folder, extract that folder into ‘c:\temp\lua-5.1.5\’.

Now if your system cannot handle ‘.tar.gz’ files (common on Unix, but not on Windows) you can [download 7zip](ttp://www.7-zip.org/), which is a compression utility that handles this format (and many others like .zip and .rar) very well.  
Compiling the Lua core files must be done from the command line. So;

-   open the start menu and type ‘mingw64’, once ‘MYS2 MINGW64’ is found, open it.

We’re all set to build our Lua installation, so type the following commands in the `MYS2-MINGW64` environment prompt (in order; cleanup to make sure we start clean, then compile it using mingw, finally install the resulting binaries);
```
cd /c/temp/lua-5.1.5
mingw32-make clean
mingw32-make mingw
mingw32-make install INSTALL_TOP=c:/temp/lua/5.1 TO_BIN="lua.exe luac.exe lua51.dll"
```

**CRUCIAL** in the last line:

-   the version numbers 5.1 and 51 appear and must be correct (if using another version than 5.1)
-   ‘c:/temp/lua/5.1’ uses **FORWARD** slashes (a Unix convention)

 This should be your result:
```
MINGW64 /c/temp
$ cd /c/temp/lua-5.1.5

MINGW64 /c/temp/lua-5.1.5
$ mingw32-make clean
cd src && C:/msys64/mingw64/bin/mingw32-make.exe clean
mingw32-make[1]: Entering directory 'C:/temp/lua-5.1.5/src'
rm -f liblua.a lua luac lapi.o lcode.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o lobject.o
lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o lundump.o lvm.o lzio.o lauxlib.o lbaselib.o l
dblib.o liolib.o lmathlib.o loslib.o ltablib.o lstrlib.o loadlib.o linit.o lua.o luac.o print.o
mingw32-make[1]: Leaving directory 'C:/temp/lua-5.1.5/src'

MINGW64 /c/temp/lua-5.1.5
$ mingw32-make mingw
cd src && C:/msys64/mingw64/bin/mingw32-make.exe mingw
mingw32-make[1]: Entering directory 'C:/temp/lua-5.1.5/src'
C:/msys64/mingw64/bin/mingw32-make.exe "LUA_A=lua51.dll" "LUA_T=lua.exe" \
"AR=gcc -shared -o" "RANLIB=strip --strip-unneeded" \
"MYCFLAGS=-DLUA_BUILD_AS_DLL" "MYLIBS=" "MYLDFLAGS=-s" lua.exe
mingw32-make[2]: Entering directory 'C:/temp/lua-5.1.5/src'
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lua.o lua.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lapi.o lapi.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lcode.o lcode.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o ldebug.o ldebug.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o ldo.o ldo.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o ldump.o ldump.c
ldump.c: In function 'DumpString':
ldump.c:63:26: warning: the comparison will always evaluate as 'false' for the pointer operand in 's
 + 24' must not be NULL [-Waddress]
   63 |  if (s==NULL || getstr(s)==NULL)
      |                          ^~
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lfunc.o lfunc.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lgc.o lgc.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o llex.o llex.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lmem.o lmem.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lobject.o lobject.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lopcodes.o lopcodes.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lparser.o lparser.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lstate.o lstate.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lstring.o lstring.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o ltable.o ltable.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o ltm.o ltm.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lundump.o lundump.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lvm.o lvm.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lzio.o lzio.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lauxlib.o lauxlib.c
lauxlib.c: In function 'luaL_loadfile':
lauxlib.c:577:4: warning: this 'while' clause does not guard... [-Wmisleading-indentation]
  577 |    while ((c = getc(lf.f)) != EOF && c != LUA_SIGNATURE[0]) ;
      |    ^~~~~
lauxlib.c:578:5: note: ...this statement, but the latter is misleadingly indented as if it were guar
ded by the 'while'
  578 |     lf.extraline = 0;
      |     ^~
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lbaselib.o lbaselib.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o ldblib.o ldblib.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o liolib.o liolib.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lmathlib.o lmathlib.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o loslib.o loslib.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o ltablib.o ltablib.c
ltablib.c: In function 'addfield':
ltablib.c:137:3: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
  137 |   if (!lua_isstring(L, -1))
      |   ^~
ltablib.c:140:5: note: ...this statement, but the latter is misleadingly indented as if it were guar
ded by the 'if'
  140 |     luaL_addvalue(b);
      |     ^~~~~~~~~~~~~
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o lstrlib.o lstrlib.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o loadlib.o loadlib.c
gcc -O2 -Wall -DLUA_BUILD_AS_DLL   -c -o linit.o linit.c
gcc -shared -o lua51.dll lapi.o lcode.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o lobject.o
 lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o lundump.o lvm.o lzio.o lauxlib.o lbaselib.o
ldblib.o liolib.o lmathlib.o loslib.o ltablib.o lstrlib.o loadlib.o linit.o     # DLL needs all obje
ct files
strip --strip-unneeded lua51.dll
gcc -o lua.exe -s lua.o lua51.dll -lm
mingw32-make[2]: Leaving directory 'C:/temp/lua-5.1.5/src'
C:/msys64/mingw64/bin/mingw32-make.exe "LUAC_T=luac.exe" luac.exe
mingw32-make[2]: Entering directory 'C:/temp/lua-5.1.5/src'
gcc -O2 -Wall    -c -o luac.o luac.c
gcc -O2 -Wall    -c -o print.o print.c
ar rcu liblua.a lapi.o lcode.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o lobject.o lopcodes
.o lparser.o lstate.o lstring.o ltable.o ltm.o lundump.o lvm.o lzio.o lauxlib.o lbaselib.o ldblib.o
liolib.o lmathlib.o loslib.o ltablib.o lstrlib.o loadlib.o linit.o      # DLL needs all object files
C:\msys64\mingw64\bin\ar.exe: `u' modifier ignored since `D' is the default (see `U')
ranlib liblua.a
gcc -o luac.exe  luac.o print.o liblua.a -lm
mingw32-make[2]: Leaving directory 'C:/temp/lua-5.1.5/src'
mingw32-make[1]: Leaving directory 'C:/temp/lua-5.1.5/src'

MINGW64 /c/temp/lua-5.1.5
$ mingw32-make install INSTALL_TOP=c:/temp/lua/5.1 TO_BIN="lua.exe luac.exe lua51.dll"
cd src && mkdir -p c:/temp/lua/5.1/bin c:/temp/lua/5.1/include c:/temp/lua/5.1/lib c:/temp/lua/5.1/m
an/man1 c:/temp/lua/5.1/share/lua/5.1 c:/temp/lua/5.1/lib/lua/5.1
cd src && install -p -m 0755 lua.exe luac.exe lua51.dll c:/temp/lua/5.1/bin
cd src && install -p -m 0644 lua.h luaconf.h lualib.h lauxlib.h ../etc/lua.hpp c:/temp/lua/5.1/inclu
de
cd src && install -p -m 0644 liblua.a c:/temp/lua/5.1/lib
cd doc && install -p -m 0644 lua.1 luac.1 c:/temp/lua/5.1/man/man1

```
Completing the setup

-   Now you can close the command window (important, you cannot re-use this instance!)
-   Open the ‘c:\temp’ folder in a Windows explorer window and you can move the complete ‘c:\temp\lua’ directory to ‘c:\program files\’ (or ‘c:\program files (x86)’ on 64bit systems)
-   Open the ‘PATH’ variable again in the ‘environment variables’ dialog box (see ‘installing the compiler’ above), this time adding the location of ‘lua.exe’ to the system path (that would be ‘c:\program files\lua\5.1\bin’ or include the ‘(x86)’ in case of a 64bit system).

Congratulations, you’ve just compiled and installed Lua! Open a pwsh/cmd window and type;

`lua -e "print('hello world')"`

to test it (if it doesn’t work, make sure to open a new command window, because of the change to the PATH variable)

# Installing LuaRocks

-   [Download LuaRocks](http://luarocks.org/releases/).
- I use [luarocks-3.9.2-windows-32.zip](https://luarocks.github.io/luarocks/releases/luarocks-3.3.1-windows-32.zip) (luarocks.exe stand-alone Windows 32-bit binary)
- i recommend to use 32 version. I have problems with some libraries when try 64 bit.
-   Open the downloaded zip file and drag the `luarocks-3.9.2-windows-32’ folder inside to  ‘c:\program files\` 
- Add to PATH `C:\program files\luarocks-3.9.2-windows-32`
- Open pwsh/cmd and type:`luarocks --lua-version 5.1 path`
you will see something like that
```
SET LUA_PATH=[semicolon seperated paths...]
SET LUA_CPATH=[semicolon seperated paths...]
SET PATH=[semicolon seperated paths...]
```
-   Open the window with the ‘environment variables’ again and add the values given to the variables there (only if they are not there already). LUA_PATH and LUA_CPATH (or _5_2 versions) probably do not exist, so you’ll have to create them. This step is crucial for your Lua installation to work properly, so be carefull to get this right!
- Also not existed values to PATH. Example:C:\Users\user\AppData\Roaming/luarocks/bin;

Now close all command windows and open a new one and type
```luarocks help```
to see whether your new LuaRocks installation is found.

# Installing LuaRocks packages

You need to add --lua-version 5.1 to your command.
```
luarocks --lua-version 5.1 install lua-cjson
luarocks --lua-version 5.1 install luautf8
luarocks --lua-version 5.1 install luasocket
luarocks --lua-version 5.1 install bit32
luarocks --lua-version 5.1 install luabitop
```
Congratulations again! you just setup a working package manager. This will allow you to install Lua modules with just a few simple commands, while not having to worry about the technical complexities of the compiler. Obviously only packages intended for Windows can be installed this way, explicit unix packages will not work.

# Installing luasql-odbc (optional)

I will cover the installation of this package, as it needs some extra work to function on windows. See [luasql repository](https://github.com/lunarmodules/luasql) for more info on the package.

1. Dowload and install the microsoft odbc driver from [here](https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver16), this provides the odbc32.lib file that is needed for luasql.

2. Download the rockspec file from the luasql repository as we will have to customize it for a Windows installation. Replace the line that says `libraries = { "odbc" }` with `libraries = { "odbc32" }`, odbc is unix and odbc32 is for windows.

3. Provided that you have completed all of the above steps to get a working mingw64 installation, we can direct the luarocks installer to use the required sql.h header file that is in `c:\msys64\mingw64\include`. Cd into the location of your modified rockspec and run the following command: 

(note that this should be in a pwsh/cmd window, we dont need the MINGW64 environment anymore)

`luarocks install C:\Path\to\rockspec\luasql-odbc-2.6.0-2.rockspec --lua-version=5.1 ODBC_INCDIR=c:\msys64\mingw64\include`
 

