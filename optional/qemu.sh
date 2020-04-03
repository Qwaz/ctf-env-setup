$INSTALL gdb-multiarch qemu binfmt-support qemu-user-static

update-binfmts --display

if [ $KERNEL_OPT -eq 1 ]; then
    echo 0 | $SUDO tee /proc/sys/vm/mmap_min_addr
    echo "vm.mmap_min_addr = 0" | $SUDO tee /etc/sysctl.d/mmap_min_addr.conf
fi

$SUDO mkdir -p /etc/qemu-binfmt

# apt-cache search '^libc6-[^-]+-cross'
$INSTALL libc6-arm64-cross libc6-armhf-cross libc6-mips-cross libc6-mipsel-cross

$SUDO ln -s /usr/aarch64-linux-gnu /etc/qemu-binfmt/aarch64
$SUDO ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
$SUDO ln -s /usr/mips-linux-gnu /etc/qemu-binfmt/mips
$SUDO ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel
