# Lab 02 - Partition Oluşturma, Formatlama ve Mount Etme

## Amaç

Yeni eklenen boş bir diski kullanıma hazırlamak.

## Uyarı

Bu labda disk üzerinde değişiklik yapılır. Production sistemde çalıştırmayın.

Örnek disk: `/dev/sdb`

## Adım 1 - Disk Kontrolü

```bash
lsblk
```

Boş diski doğrulayın.

## Adım 2 - Partition Oluşturma

```bash
sudo fdisk /dev/sdb
```

Sırasıyla:

```text
n
p
1
Enter
Enter
w
```

## Adım 3 - Partition Kontrolü

```bash
lsblk
```

Beklenen:

```text
sdb
└─sdb1
```

## Adım 4 - Filesystem Oluşturma

```bash
sudo mkfs.ext4 /dev/sdb1
```

## Adım 5 - Mount Point Oluşturma

```bash
sudo mkdir -p /mnt/data
```

## Adım 6 - Mount Etme

```bash
sudo mount /dev/sdb1 /mnt/data
```

## Adım 7 - Test

```bash
touch /mnt/data/test.txt
ls -l /mnt/data
df -h /mnt/data
```

## Adım 8 - Kalıcı Mount

UUID öğrenin:

```bash
sudo blkid /dev/sdb1
```

`/etc/fstab` içine örnek satır:

```fstab
UUID=YOUR-UUID /mnt/data ext4 defaults 0 2
```

Test:

```bash
sudo mount -a
```
