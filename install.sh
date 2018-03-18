#!/bin/bash

# sm64tools installation script

if [[ $EUID -ne 0 ]]; then
   echo "This installation script must be run as root"
   exit 1
fi

echo "=================================="
echo "====== Installing sm64tools ======"
echo "=================================="

echo "This script will install the following tools"
echo -e "\tCapstone disassembler development libraries"
echo -e "\tSTB single-file public domain libraries for C/C++."
echo -e "\tGit, if for whatever reason you don't have it already"
echo -e "\tYaml development libraries"
echo
read -r -p "Are you cool with this? [y/N]" response
case "$response" in
    [yY][eE][sS]|[yY])
        :
        ;;
    *)
        exit 1
        ;;
esac

# The following bracketed commands are collectively a way to
# figure out what package manager needs to be used
{
    apt > /dev/null
    pkgmngr="apt"
} || {
    yum > /dev/null
    pkgmngr="yum"
} || {
    echo "Unsupported package manager."
    exit 1
}

echo "Installing capstone disassembler"
${pkgmngr} install libcapstone-dev

echo "Installing stb single-file public domain libraries for C/C++."
# Now we're checking for a git installation, or installing it.
# stb does not have a Debian package, so we just add it to our included files.
{
    git > /dev/null
} || {
    ${pkgmngr} install git
}
git clone https://github.com/nothings/stb.git
mv stb /usr/local/include

echo "Installing libyaml-dev"
${pkgmngr} install libyaml-dev

make
echo
echo "=================================="

if [[ $? == 0 ]]; then
    echo "The installation has failed or is already made."
    echo "If this is an error please post your output on the github page."
    echo "https://github.com/queueRAM/sm64tools"
else
    echo "The installation is complete!"
    echo "Here are the tools and their purpose:"
    echo -e "\tn64strip - Splitter and build system. Probably start here."
    echo -e "\tsm64extend - ROM extender."
    echo -e "\tsm64extend - ROM extender."
    echo -e "\tsm64compress - EXPERIMENTAL ROM alignment and compression tool."
    echo -e "\tn64cksum - standalone n64 checksum generator."
    echo -e "\tn64graphics - Converts PNG files to n64 usable data."
    echo -e "\tn64geo - Standalone sm64 geometry layout decoder."
    echo
    echo "Have fun!"
fi
echo "=================================="
