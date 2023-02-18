sudo apt install -y pv libguestfs-tools qemu-utils

cd ~
## start a new container and keep it running interactive (-it) but detached (-d) with bash
# docker run -dit --name ubi ubuntu bash   

## attach STDIN and STDOUT to a running container, ^p^q sequence to detach
exit# docker attach ubi

## Executes another process in an already running container
# docker exec -it ubi bash 

## Executes another process in an already running container. A container stop when PID 1 is closed.
# docker start ubi

## Removes all the stopped containers
# docker container prune

## dockersha can help on finding overlay2 folder
dockersha=$(docker run -d --name ubi ubuntu ls)
docker export ubi > $GITHUB_WORKSPACE/base_tarball.tar

git clone https://github.com/StoneyDSP/ubento.git
cd ubento
docker cp etc ubi:/
docker cp root ubi:/

docker export ubi > $GITHUB_WORKSPACE/ubi.tar


## Create drive
cd
truncate -s 1G my.img

## Create filesystem
mkfs.ext4 my.img

## mount
sudo mkdir -p /mnt/img
sudo mount -oloop my.img /mnt/img

## save OS structure
cd /mnt/img
pv  $GITHUB_WORKSPACE/ubi.tar | sudo tar xf - -C .
cd

## unmount
sudo umount /mnt/img

## generate vhdx
e2fsck -f my.img
resize2fs -M my.img
qemu-img convert my.img -O vhdx -o subformat=dynamic img.vhdx





## mount WSL VHDX in linux
sudo mkdir -p /mnt/wsl
sudo guestmount -o allow_other --add ubi.vhdx --rw /mnt/wsl -m /dev/sda
sudo guestunmount /mnt/wsl
## debug
sudo guestfish --rw -a myvhdxfile.vhdx
# run
# list-filesystems
# exit

qemu-img create -f vhdx ubi.vhdx 1024G

sudo modprobe nbd
sudo qemu-nbd -f vhdx -c /dev/nbd0 ubi.vhdx
sudo dd if=my.img of=/dev/nbd0
sudo qemu-nbd -d /dev/nbd0
