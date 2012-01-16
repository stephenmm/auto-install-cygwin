@ECHO OFF
REM Author: Stephen Meckley
REM Initial Date: 1/13/2012
REM Synopsis: Batch file to automate setup of Cygwin from the command line
REM Description:
REM    This batch file is meant to be kept in a Dropbox folder so that on
REM    a new machine we can run one script and a very very usable cygwin
REM    installation is available after a few minutes with minimal
REM    interaction from the user.
REM Features:
REM    - Auto start after instal and after windows starts
REM    - Creates a softlinks to Dropbox linux files (~/.vimrc ~/.bashrc ~/bin etc.)
REM    - Installs apt-cyg which is a very easy to use command line package management tool.
REM    - Sets up for ssh access out of the box.
REM Dependecies:
REM    - Internet connection
REM    - Dropbox pre-installed in the default windows location c:\Dropbox
REM    - cygwin-startup.bat
REM    - getWebFile1.vbs
REM    - install-cygwin.bat

ECHO --------------------------------------------------------------------------
ECHO                       Automated cygwin setup
ECHO --------------------------------------------------------------------------

SETLOCAL
  FOR /F %%D in ("%CD%") DO SET DRIVE=%%~dD

  SET DFLTSITE=http://mirror.csclub.uwaterloo.ca/cygwin/

  SET DFLTLOCALDIR=c:/Temp/cygwindownload
  SET DFLTROOTDIR=%DRIVE%/cygwin

  SET SITE=-s %DFLTSITE%
  SET LOCALDIR=-l %DFLTLOCALDIR%
  SET ROOTDIR=-R %DFLTROOTDIR%

if exist c:\Dropbox (
   echo Found Dropbox installation
) else (
   echo ERROR: Could not find Dropbox installation
   echo Please install Dropbox in the default directory before running this script
   goto end
)

ECHO [INFO] Downloading cygwin setup.exe
mkdir C:\Temp\cygwindownload\
Cscript.exe getWebFile1.vbs "http://www.cygwin.com/setup.exe" "C:\Temp\cygwindownload\setup.exe"
if exist C:\Temp\cygwindownload\setup.exe (
   echo [INFO]: Cygwin setup was downloaded
) else (
   echo [FATAL]: Cygwin setup was not downloaded
   goto end
)


REM --------------------------------------------------------------
REM Here's where I keep track of which packages I've loaded for
REM different types of work

REM C development: gcc4-core make readline
SET PACKAGES=-P gcc4-core,make,readline,binutils

REM General : diffutils ctags
SET PACKAGES=%PACKAGES%,diffutils,ctags

REM Packaging : cygport
SET PACKAGES=%PACKAGES%,cygport

REM Packages : Taken from a previous cygwin install
SET PACKAGES=%PACKAGES%,X-start-menu-icons,_update-info-dir,alternatives,base-cygwin,base-files,bash,bzip2,coreutils,crypt,csih,ctags,cygrunsrv,cygutils,cygwin,cygwin-doc,dash,dbus,diffutils,dos2unix,editrights,file,findutils,font-adobe-dpi75,font-alias,font-encodings,font-misc-misc,fontconfig,gamin,gawk,gettext,gnome-icon-theme,grep,groff,gsettings-desktop-schemas,gvim,gzip,hicolor-icon-theme,ipc-utils,kbproto,less,libGL1,libICE6,libSM6,libX11-devel,libX11-xcb-devel,libX11-xcb1,libX11_6,libXau-devel,libXau6,libXaw7,libXcomposite1,libXcursor1,libXdamage1,libXdmcp-devel,libXdmcp6,libXext6,libXfixes3,libXft2,libXi6,libXinerama1,libXmu6,libXmuu1,libXpm4,libXrandr2,libXrender1,libXt6,libapr1,libaprutil1,libatk1.0_0,libattr1,libblkid1,libbz2_1,libcairo2,libdatrie1,libdb4.5,libdbus1_3,libedit0,libexpat1,libfam0,libffi4,libfontconfig1,libfontenc1,libfreetype6,libgcc1,libgcrypt11,libgdbm4,libgdk_pixbuf2.0_0,libglib2.0_0,libgmp3,libgnutls26,libgpg-error0,libgtk2.0_0,libiconv2,libidn11,libintl8,libjasper1,libjbig2,libjpeg7,libjpeg8,liblzma5,liblzo2_2,libncurses10,libncursesw10,libneon27,libopenldap2_3_0,libopenssl098,libpango1.0_0,libpcre0,libpixman1_0,libpng14,libpopt0,libpq5,libproxy1,libpthread-stubs,libreadline7,libsasl2,libserf0_1,libserf1_0,libsigsegv2,libsqlite3_0,libssp0,libstdc++6,libtasn1_3,libthai0,libtiff5,libuuid1,libwrap0,libxcb-devel,libxcb-glx0,libxcb-render0,libxcb-shm0,libxcb1,libxkbfile1,libxml2,login,luit,man,minires,mintty,mkfontdir,mkfontscale,nano,openssh,pbzip2,perl,rebase,run,sed,shared-mime-info,subversion,tar,tcltk,terminfo,texinfo,tzcode,util-linux,vim-common,wget,which,x11perf,xauth,xcursor-themes,xinit,xkbcomp,xkeyboard-config,xmodmap,xorg-server,xproto,xrdb,xterm,xxd,xz,zlib,zlib-devel,zlib

REM Do the actual cygwin install
ECHO [INFO] C:\Temp\cygwindownload\setup.exe -q -n -D -L %SITE% %LOCALDIR% %PACKAGES%
C:\Temp\cygwindownload\setup.exe -q -n -D -L %SITE% %LOCALDIR% %PACKAGES%

ECHO [INFO] Cygwin installation is complete

ECHO [INFO] Cygwin custom configuration

echo [INFO] Create link from the default c:\Dropbox to ~/Dropbox.
c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/mkdir /home/%USERNAME%"
c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s /cygdrive/c/Dropbox /home/%USERNAME%/Dropbox"

if exist c:\cygwin\home\%USERNAME%\Dropbox (
   REM TODO - May want to move these lines to a seperate bash script that gets called here so that I
   REM        can use the same script here and in a regular linux enviorenment setup.
   echo [INFO] Create the symbolic links from the Dropbox HOME directory files
   c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s ~/Dropbox/HOME/hlp /home/%USERNAME%/hlp"
   c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s ~/Dropbox/HOME/bin /home/%USERNAME%/bin"
   c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s ~/Dropbox/HOME/.bashrc /home/%USERNAME%/.bashrc"
   c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s ~/Dropbox/HOME/.bash_profile /home/%USERNAME%/.bash_profile"
   c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s ~/Dropbox/HOME/.vimrc /home/%USERNAME%/.vimrc"
   c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s ~/Dropbox/HOME/.vim /home/%USERNAME%/.vim"
   c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/ln -s ~/Dropbox/HOME/.vimperatorrc /home/%USERNAME%/.vimperatorrc"
) else (
   echo "ERROR: The symbolic link to Dropbox was not created in /cygdrive/home/%USERNAME%"
   goto install_apt_cyg
)

:install_apt_cyg

echo [INFO] Installing the apt-cyg stuff as it has to be installed seperatly
c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/svn --force export http://apt-cyg.googlecode.com/svn/trunk/ /bin/"
c:\cygwin\bin\bash.exe --norc --noprofile -c "/usr/bin/chmod +x /bin/apt-cyg"

c:\cygwin\bin\bash.exe --login -i -c '/usr/bin/mkpasswd --local > /etc/passwd'
c:\cygwin\bin\bash.exe --login -i -c '/usr/bin/mkgroup --local > /etc/group'
c:\cygwin\bin\bash.exe --login -i -c '/usr/bin/ssh-keygen'
c:\cygwin\bin\bash.exe --login -i -c '/usr/bin/ssh-host-config --yes'

echo [INFO] Start an instance of xwin
C:\cygwin\bin\run.exe /usr/bin/bash.exe -l -c /usr/bin/startxwin.exe

echo [INFO] Startup X/cygwin every time windows is started
copy "C:\Dropbox\install-cygwin\cygwin-startup.bat" "C:\Users\smeckley\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

REM Could not get the installation of CPAN modules to happen automatically
echo [INFO] Must run the following command in an xterm:
echo [INFO]    PERL_MM_USE_DEFAULT=1 /usr/bin/perl -MCPAN -e 'install Spreadsheet::ParseExcel'
REM echo [INFO] Installing CPAN modules
REM c:\cygwin\bin\bash.exe --norc --noprofile -c "PERL_MM_USE_DEFAULT=1 /usr/bin/perl -MCPAN -e 'install Spreadsheet::ParseExcel'"
REM --- Did not work --- c:\cygwin\bin\bash.exe --norc --noprofile -c " ~/Dropbox/install-cygwin/install-cpan.pl Spreadsheet::ParseExcel"

:end

ENDLOCAL

EXIT /B 0




