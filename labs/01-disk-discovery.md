# Lab 01 - Diskleri ve Partitionları Keşfetme

## Amaç

Bu labda Linux sistemde mevcut diskleri, partitionları, filesystemleri ve mount noktalarını görüntülemeyi öğreneceksiniz.

## Gereksinimler

- Linux test makinesi
- Root veya sudo yetkisi

## Adım 1 - Block Device Listesini Görüntüleme

```bash
lsblk
```

Dikkat edin:

- Hangi satırlar disk?
- Hangi satırlar partition?
- Hangi partition hangi mount point üzerinde?

## Adım 2 - Filesystem Bilgisiyle Görüntüleme

```bash
lsblk -f
```

Kontrol edin:

- `FSTYPE` alanı dolu mu?
- `UUID` bilgisi var mı?
- Mount point neresi?

## Adım 3 - Mounted Filesystemleri Görme

```bash
df -h
```

Not: `df`, sadece mount edilmiş filesystemleri gösterir.

## Adım 4 - UUID Bilgilerini Görme

```bash
sudo blkid
```

## Checkpoint

Aşağıdaki soruları cevaplayın:

1. Sistemde kaç disk var?
2. Root filesystem hangi partition üzerinde?
3. Boşta görünen disk var mı?
4. UUID neden önemlidir?
