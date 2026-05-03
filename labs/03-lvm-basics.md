# Lab 03 - LVM Temelleri

## Amaç

LVM kullanarak logical volume oluşturmak.

## Kavramlar

```text
Physical Volume → Volume Group → Logical Volume
```

## Adım 1 - LVM Paketini Kurma

Ubuntu/Debian:

```bash
sudo apt install lvm2 -y
```

RHEL/Rocky/AlmaLinux:

```bash
sudo dnf install lvm2 -y
```

## Adım 2 - Physical Volume Oluşturma

```bash
sudo pvcreate /dev/sdb1
```

Kontrol:

```bash
sudo pvs
```

## Adım 3 - Volume Group Oluşturma

```bash
sudo vgcreate vg_data /dev/sdb1
```

Kontrol:

```bash
sudo vgs
```

## Adım 4 - Logical Volume Oluşturma

```bash
sudo lvcreate -L 5G -n lv_appdata vg_data
```

Kontrol:

```bash
sudo lvs
```

## Adım 5 - Filesystem ve Mount

```bash
sudo mkfs.ext4 /dev/vg_data/lv_appdata
sudo mkdir -p /appdata
sudo mount /dev/vg_data/lv_appdata /appdata
df -h /appdata
```

## Checkpoint

- `pvs` ne gösterir?
- `vgs` ne gösterir?
- `lvs` ne gösterir?
