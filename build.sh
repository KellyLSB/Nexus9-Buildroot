BUILD_PATH="$(dirname $0)"
BUILD_CORES="$(( $(nproc) - 1))"

# Set Architecture and Cross Compiler
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

# Install Required Build Dependencies
# Designed to run on Debian (stretch/sid)
sudo apt-get install \
	gcc g++ git \
	gcc-5-aarch64-linux-gnu \
	g++-5-aarch64-linux-gnu \
	libncurses5-dev

# Get/Update BuildRoot & Tegra Repositories
git submodule update --init --checkout --remote

# Copy the default BuildRoot configuration
if [[ ! -f "${BUILD_PATH}/buildroot/.config" ]]; then
	cp "${BUILD_PATH}/buildroot.config" \
	   "${BUILD_PATH}/buildroot/.config"
fi

# Copy the default Tegra Kernel configuration
if [[ ! -f "${BUILD_PATH}/tegra/.config" ]]; then
	cp "${BUILD_PATH}/tegra.config" \
	   "${BUILD_PATH}/tegra/.config"
fi

# Make BuildRoot
cp "${BUILD_PATH}/buildroot"
echo "Loading BuildRoot MenuConfig..."
echo "Just exit if you don't want to make any modifications."
sleep 2
make menuconfig
make -j ${BUILD_CORES}

# Make Tegra Kernel
cp "${BUILD_PATH}/tegra"
echo "Loading Tegra Kernel MenuConfig..."
echo "Just exit if you don't want to make any modifications."
sleep 2
make menuconfig
make -j ${BUILD_CORES}
