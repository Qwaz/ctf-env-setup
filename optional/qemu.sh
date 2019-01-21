$INSTALL gdb-multiarch qemu binfmt-support qemu-user-static

update-binfmts --display

echo 0 | sudo tee /proc/sys/vm/mmap_min_addr
echo "vm.mmap_min_addr = 0" | sudo tee /etc/sysctl.d/mmap_min_addr.conf

sudo mkdir -p /etc/qemu-binfmt

# apt-cache search '^libc6-[^-]+-cross'
$INSTALL libc6-arm64-cross libc6-armhf-cross libc6-mips-cross libc6-mipsel-cross

sudo ln -s /usr/aarch64-linux-gnu /etc/qemu-binfmt/aarch64
sudo ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
sudo ln -s /usr/mips-linux-gnu /etc/qemu-binfmt/mips
sudo ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel
