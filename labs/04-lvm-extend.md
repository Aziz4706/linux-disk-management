# Lab 04 - LVM Disk Genişletme

## Amaç

Mevcut bir logical volume alanını büyütmek.

## Senaryo

`/appdata` dizini `/dev/vg_data/lv_appdata` üzerinden mount edilmiş olsun.

## Adım 1 - Mevcut Durumu Kontrol Etme

```bash
df -h /appdata
sudo vgs
sudo lvs
```

## Adım 2 - Logical Volume Büyütme

5 GB eklemek için:

```bash
sudo lvextend -L +5G /dev/vg_data/lv_appdata
```

## Adım 3 - Filesystem Büyütme

ext4 için:

```bash
sudo resize2fs /dev/vg_data/lv_appdata
```

XFS için:

```bash
sudo xfs_growfs /appdata
```

## Alternatif: Tek Komut

```bash
sudo lvextend -r -L +5G /dev/vg_data/lv_appdata
```

## Kontrol

```bash
df -h /appdata
```
