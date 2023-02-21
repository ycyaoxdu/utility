#!/bin/sh

if [ ! $GO_VERSION ] ; then
    echo "GO_VERSION should be set"
    exit 1
fi

OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
    "Linux")
        case $ARCH in
        "x86_64")
            ARCH=amd64
            ;;
        "aarch64")
            ARCH=arm64
            ;;
        .*386.*)
            ARCH=386
            ;;
        esac
        PLATFORM="linux-$ARCH"
    ;;
    "Darwin")
          case $ARCH in
          "x86_64")
              ARCH=amd64
              ;;
          "arm64")
              ARCH=arm64
              ;;
          esac
        PLATFORM="darwin-$ARCH"
    ;;
esac

if [ -z "$PLATFORM" ]; then
    echo "Your operating system is not recognized by the script."
    exit 1
fi

PACKAGE=go${GO_VERSION}.${PLATFORM}.tar.gz

echo "Downloading $PACKAGE ..."
curl -o "${PACKAGE}" -L https://go.dev/dl/$PACKAGE
if [ $? -ne 0 ]; then
    echo "Download failed! Exiting."
    exit 1
fi

GO_INSTALL_PATH=${GO_INSTALL_PATH:-"/usr/local"}

sudo rm -rf "$GO_INSTALL_PATH/go" && sudo tar -C $GO_INSTALL_PATH -xzf $PACKAGE

echo "done"
echo ""