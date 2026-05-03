# Linux Disk Komutları Cheat Sheet

## Diskleri Görüntüleme

```bash
lsblk
lsblk -f
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
sudo fdisk -l
sudo blkid
```

## Disk Kullanımı

```bash
df -h
df -i
du -sh *
sudo du -h --max-depth=1 / | sort -hr | head -20
sudo find / -type f -exec du -h {} + 2>/dev/null | sort -hr | head -20
```

## Partition

```bash
sudo fdisk /dev/sdb
sudo parted /dev/sdb
```

## Filesystem

```bash
sudo mkfs.ext4 /dev/sdb1
sudo mkfs.xfs /dev/sdb1
```

## Mount

```bash
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data
sudo umount /mnt/data
sudo mount -a
```

## UUID

```bash
sudo blkid /dev/sdb1
```

## LVM

```bash
sudo pvcreate /dev/sdb1
sudo vgcreate vg_data /dev/sdb1
sudo lvcreate -L 10G -n lv_appdata vg_data
sudo mkfs.ext4 /dev/vg_data/lv_appdata
sudo mount /dev/vg_data/lv_appdata /appdata
```

## LVM Genişletme

```bash
sudo lvextend -r -L +5G /dev/vg_data/lv_appdata
sudo lvextend -r -l +100%FREE /dev/vg_data/lv_appdata
```

## Swap

```bash
swapon --show
free -h
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

## Disk Sağlığı

```bash
sudo smartctl -H /dev/sda
sudo smartctl -a /dev/sda
```

## Log Temizleme

```bash
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=1G
```

## Docker Disk

```bash
docker system df
docker system prune
docker system prune -a --volumes
```
