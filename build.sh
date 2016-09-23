set -eu

ARCH=$1
PKG_DIR=$2
PKGS=$3
QUIET=${4-}
FEED_NAME=custom

for dir in /home/openwrt/sdk/staging_dir/*; do
    ln -snf /home/openwrt/.ccache $dir/ccache
done

cd /home/openwrt/sdk
rm -rf bin
cp feeds.conf.default feeds.conf
echo src-link $FEED_NAME /work >> feeds.conf
./scripts/feeds update -a
./scripts/feeds install $PKGS
make defconfig

# To bypass travis-ci 10 minutes build timeout
[[ -n "$QUIET" ]] && while true; do echo "..."; sleep 60; done &

for pkg in $PKGS; do
    echo make package/$pkg/compile V=s
    make package/$pkg/compile V=s >> /work/build.log 2>&1
done

[[ -n "$QUIET" ]] && kill %1

ls -laR bin
mkdir -p /work/pkgs-for-bintray /work/pkgs-for-github
if [ -e "$PKG_DIR/$FEED_NAME" ] ; then
    cd $PKG_DIR/$FEED_NAME
    for file in *; do
        cp $file /work/pkgs-for-bintray
        cp $file /work/pkgs-for-github/${ARCH}-${file}
    done
    ls -la /work/pkgs-for-bintray /work/pkgs-for-github
fi
