# Maintainer: sehaxe <sehaxe@proton.me>
# Based on: https://github.com/Diegiwg/PrismLauncher-Cracked

pkgname=prismlauncher-cracked
pkgver=11.0.2.r1.g0c20d44
pkgrel=1
pkgdesc="Unofficial fork of PrismLauncher for offline Minecraft gameplay"
arch=('x86_64' 'aarch64')
url="https://github.com/Diegiwg/PrismLauncher-Cracked"
license=('GPL3')
depends=('qt6-base' 'qt6-imageformats' 'qt6-networkauth' 'qt6-svg'
         'cmark' 'libarchive' 'mesa' 'qrencode'
         'tomlplusplus' 'zlib' 'jdk17-openjdk'
         'hicolor-icon-theme' 'shared-mime-info' 'desktop-file-utils')
makedepends=('base-devel' 'cmake' 'ninja' 'extra-cmake-modules'
             'pkg-config' 'scdoc' 'git' 'vulkan-headers' 'gamemode')
optdepends=('glxinfo: OpenGL runtime information'
            'pciutils: hardware detection at runtime')
provides=('prismlauncher')
conflicts=('prismlauncher' 'prismlauncher-git' 'multimc')

source=("${pkgname}::git+https://github.com/Diegiwg/PrismLauncher-Cracked.git#branch=main")
noextract=("${pkgname}")
sha256sums=('SKIP')

pkgver() {
    cd "${pkgname}"
    git describe --long --tags --abbrev=7 2>/dev/null | \
        sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g' || \
        echo "0.0.0.r$(git rev-list --count HEAD).g$(git rev-parse --short HEAD)"
}

prepare() {
    cd "${pkgname}"
    # Initialize and update Git submodules (required for compilation)
    git submodule update --init --recursive
}

build() {
    cd "${pkgname}"
    
    cmake -S . -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DENABLE_LTO=ON \
        -DENABLE_UPDATER=OFF \
        -DCMAKE_CXX_FLAGS="-Wno-error -Wno-sfinae-incomplete"
        
    cmake --build build
}

package() {
    cd "${pkgname}"
    
    # Install files into the package directory
    cmake --install build --prefix="${pkgdir}/usr"
    
    # Install license file
    if [[ -f LICENSE ]]; then
        install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
    fi
}
