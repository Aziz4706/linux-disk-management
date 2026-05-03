# Linux Disk Management

![Linux](https://img.shields.io/badge/Linux-Disk%20Management-blue)
![Level](https://img.shields.io/badge/Level-Beginner%20to%20Production-success)
![Hands-on](https://img.shields.io/badge/Hands--on-Labs-orange)
![SysAdmin](https://img.shields.io/badge/Target-SysAdmin%20%7C%20DevOps%20%7C%20Cybersecurity-informational)

---

## Amaç

Bu repo, Linux üzerinde disk yönetimini teorik temelden başlayarak gerçek sistem yönetimi senaryolarına kadar öğretmek için hazırlanmıştır.

Amaç, okuyucunun bu rehberi tamamladıktan sonra Linux sistemlerde:

- Diskleri görüntüleyebilmesi
- Partition oluşturabilmesi
- Filesystem yönetebilmesi
- Mount işlemleri yapabilmesi
- `/etc/fstab` ile kalıcı mount tanımı yapabilmesi
- Disk doluluk problemlerini analiz edebilmesi
- LVM kullanabilmesi
- Disk genişletebilmesi
- Swap yönetebilmesi
- Disk sağlığı ve performans kontrollerini yapabilmesi
- Temel troubleshooting süreçlerini rahatça yürütebilmesi

hedeflenmiştir.

Bu doküman sadece komut ezberletmez. Her işlemin sistemde neyi değiştirdiğini ve neden yapıldığını anlatır.

---

## İçindekiler

- [Bu Rehber Kimler İçin?](#bu-rehber-kimler-için)
- [Öğrenme Hedefleri](#öğrenme-hedefleri)
- [Laboratuvar Ortamı](#laboratuvar-ortamı)
- [1. Linux Disk Mantığını Anlamak](#1-linux-disk-mantığını-anlamak)
- [2. Diskleri ve Partitionları Görüntüleme](#2-diskleri-ve-partitionları-görüntüleme)
- [3. Partition Yönetimi](#3-partition-yönetimi)
- [4. Filesystem Kavramı ve Formatlama](#4-filesystem-kavramı-ve-formatlama)
- [5. Mount ve Kalıcı Mount İşlemleri](#5-mount-ve-kalıcı-mount-işlemleri)
- [6. Disk Kullanımını Analiz Etme](#6-disk-kullanımını-analiz-etme)
- [7. LVM ile Esnek Disk Yönetimi](#7-lvm-ile-esnek-disk-yönetimi)
- [8. LVM Disk Genişletme Senaryosu](#8-lvm-disk-genişletme-senaryosu)
- [9. Swap Yönetimi](#9-swap-yönetimi)
- [10. Disk Sağlığı ve Performans Kontrolleri](#10-disk-sağlığı-ve-performans-kontrolleri)
- [11. Disk Temizleme ve Gerçek Hayat Senaryoları](#11-disk-temizleme-ve-gerçek-hayat-senaryoları)
- [12. Troubleshooting Rehberi](#12-troubleshooting-rehberi)
- [13. Komut Cheat Sheet](#13-komut-cheat-sheet)
- [14. Lab Çalışmaları](#14-lab-çalışmaları)
- [15. Production Notları](#15-production-notları)

---

## Bu Rehber Kimler İçin?

Bu rehber aşağıdaki kişiler için uygundur:

- Linux öğrenmeye yeni başlayanlar
- Sistem yöneticileri
- DevOps mühendisleri
- Siber güvenlik mühendisleri
- Uygulama destek ekipleri
- Sunucu üzerinde disk doluluğu, mount, filesystem veya LVM problemleri yaşayan herkes


---

## Öğrenme Hedefleri

Bu rehberi tamamladığınızda şunları yapabilecek seviyeye gelmeniz hedeflenir:

- Linux üzerinde diskleri, partitionları ve mount noktalarını okuyabilmek
- Yeni disk ekleyip kullanıma hazırlayabilmek
- `fdisk`, `parted`, `lsblk`, `blkid`, `df`, `du` gibi temel araçları doğru yorumlayabilmek
- ext4 ve XFS gibi filesystem türlerini ayırt edebilmek
- `/etc/fstab` üzerinden kalıcı mount tanımlayabilmek
- Disk doluluk problemlerini analiz edebilmek
- LVM yapısını anlayıp yeni volume oluşturabilmek
- LVM disk genişletme işlemini güvenli şekilde yapabilmek
- Swap alanı oluşturup yönetebilmek
- Disk performansı ve sağlık durumunu temel seviyede kontrol edebilmek

---

## Laboratuvar Ortamı

Bu rehberi uygulamalı takip etmek için aşağıdaki ortamlardan biri yeterlidir:

- Ubuntu Server
- Debian
- Rocky Linux
- AlmaLinux
- CentOS Stream
- Sanal makine ortamı:
  - VMware
  - VirtualBox
  - Hyper-V
  - Proxmox

> Öneri: Uygulamaları production sunucuda değil, test sanal makinesinde yapın. Disk yönetimi şaka kaldırmaz; yanlış diske işlem yaparsanız sistem gider.
### Örnek Lab Yapısı

Bu rehberde örnek olarak şu disk yapısını kullanacağız:

```bash
/dev/sda    # İşletim sisteminin kurulu olduğu ana disk
/dev/sdb    # Lab için sonradan eklenen boş disk
```

Sizin ortamınızda disk isimleri farklı olabilir:

| Disk Tipi | Örnek |
|---|---|
| SATA/SCSI disk | `/dev/sda`, `/dev/sdb`, `/dev/sdc` |
| NVMe disk | `/dev/nvme0n1`, `/dev/nvme1n1` |
| SATA partition | `/dev/sda1`, `/dev/sdb1` |
| NVMe partition | `/dev/nvme0n1p1` |

---

# 1. Linux Disk Mantığını Anlamak

Linux’ta diskler dosya gibi temsil edilir. Bu dosyalar `/dev` dizini altında bulunur.

Örneğin:

```bash
/dev/sda
/dev/sda1
/dev/sdb
/dev/sdb1
/dev/nvme0n1
/dev/nvme0n1p1
```

Burada dikkat edilmesi gereken ayrım şudur:

| Nesne | Anlamı |
|---|---|
| `/dev/sda` | Fiziksel veya sanal disk |
| `/dev/sda1` | Disk üzerindeki bir partition |
| `/dev/sdb` | İkinci disk |
| `/dev/nvme0n1` | NVMe disk |
| `/dev/nvme0n1p1` | NVMe disk üzerindeki partition |

## Disk, Partition ve Filesystem İlişkisi

Basit mantık şudur:

```text
Disk → Partition → Filesystem → Mount Point
```

Yani bir diski doğrudan kullanmak yerine genellikle şu adımlar izlenir:

1. Disk sisteme eklenir.
2. Disk üzerinde partition oluşturulur.
3. Partition üzerine filesystem oluşturulur.
4. Filesystem bir dizine mount edilir.
5. Gerekirse `/etc/fstab` ile kalıcı hale getirilir.

Örnek:

```text
/dev/sdb        → Disk
/dev/sdb1       → Partition
ext4            → Filesystem
/mnt/data       → Mount point
```

### Checkpoint

Aşağıdaki soruları cevaplayabiliyorsanız bu bölüm tamamdır:

- `/dev/sda` ile `/dev/sda1` arasındaki fark nedir?
- `df -h` neden mount edilmemiş diskleri göstermez?
- Filesystem olmadan partition’a dosya yazılabilir mi?

---

# 2. Diskleri ve Partitionları Görüntüleme

Disk yönetiminde ilk refleks her zaman mevcut durumu okumaktır. Sistemde hangi disk var, hangisi mount edilmiş, hangisi boş, filesystem tipi ne, önce bunu anlamak gerekir.

## 2.1 `lsblk` Komutu

`lsblk`, block device listesini gösterir.

```bash
lsblk
```

Örnek çıktı:

```text
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   50G  0 disk
├─sda1   8:1    0    1G  0 part /boot
└─sda2   8:2    0   49G  0 part /
sdb      8:16   0   20G  0 disk
```

Bu çıktı bize şunu söyler:

- `sda` ana disktir.
- `sda1` ve `sda2` partitionları vardır.
- `/` dizini `sda2` üzerinde çalışmaktadır.
- `sdb` adlı 20 GB disk var ama henüz partition ve mount görünmüyor.

Daha detaylı görmek için:

```bash
lsblk -f
```

Örnek:

```text
NAME   FSTYPE FSVER LABEL UUID                                 MOUNTPOINTS
sda
├─sda1 ext4         boot  1111-2222                            /boot
└─sda2 ext4         root  3333-4444                            /
sdb
```

Burada `FSTYPE`, `UUID` ve `MOUNTPOINTS` alanları özellikle önemlidir.

## 2.2 `df` Komutu

`df`, mounted filesystemlerin disk kullanımını gösterir.

```bash
df -h
```

Örnek:

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        49G   18G   29G  39% /
/dev/sda1       974M  150M  758M  17% /boot
```

Burada önemli nokta şudur:

`df` sadece mount edilmiş alanları gösterir. Sisteme takılı ama mount edilmemiş diskleri `df` ile göremezsiniz.

## 2.3 `fdisk` ile Diskleri Listeleme

```bash
sudo fdisk -l
```

Bu komut disklerin partition table bilgisini gösterir.

Özellikle yeni disk eklediğinizde diskin sistem tarafından görülüp görülmediğini kontrol etmek için kullanışlıdır.

## 2.4 `blkid` ile UUID Görme

```bash
sudo blkid
```

Örnek:

```text
/dev/sda2: UUID="3333-4444" TYPE="ext4"
/dev/sdb1: UUID="aaaa-bbbb" TYPE="ext4"
```

UUID, özellikle `/etc/fstab` içinde kullanılır. Disk ismi değişebilir ama UUID sabit kalır. Bu yüzden kalıcı mount tanımlarında `/dev/sdb1` yerine UUID kullanmak daha güvenlidir.

---

# 3. Partition Yönetimi

Yeni bir diski kullanmadan önce genellikle partition oluşturmak gerekir.

> Uyarı: Partition işlemleri veri kaybına neden olabilir. Hangi diskte işlem yaptığınızı kesin olarak doğrulamadan devam etmeyin.

## 3.1 Boş Diski Tespit Etme

```bash
lsblk
```

Örnek:

```text
sdb      8:16   0   20G  0 disk
```

Burada `/dev/sdb` üzerinde partition görünmüyorsa disk boştur veya henüz yapılandırılmamıştır.

## 3.2 `fdisk` ile Partition Oluşturma

```bash
sudo fdisk /dev/sdb
```

Açılan ekranda sırasıyla:

```text
n       # yeni partition oluştur
p       # primary partition
1       # partition numarası
Enter   # başlangıç sektörü varsayılan
Enter   # bitiş sektörü varsayılan, tüm diski kullan
w       # değişiklikleri yaz ve çık
```

Sonra kontrol edin:

```bash
lsblk
```

Beklenen çıktı:

```text
sdb      8:16   0   20G  0 disk
└─sdb1   8:17   0   20G  0 part
```

Artık `/dev/sdb1` isminde bir partition oluştu.

## 3.3 `parted` ile GPT Partition Oluşturma

Büyük disklerde veya modern sistemlerde GPT tercih edilir.

```bash
sudo parted /dev/sdb
```

Parted içinde:

```text
mklabel gpt
mkpart primary ext4 1MiB 100%
quit
```

Kontrol:

```bash
lsblk
```

### Mini Lab

Yeni eklenen `/dev/sdb` diski için:

1. Diskin boş olduğunu doğrulayın.
2. GPT partition table oluşturun.
3. Tüm diski kaplayan bir partition oluşturun.
4. `lsblk` ile doğrulayın.

---

# 4. Filesystem Kavramı ve Formatlama

Partition oluşturmak tek başına yeterli değildir. Dosya yazabilmek için partition üzerinde filesystem oluşturulmalıdır.

Yaygın filesystem türleri:

| Filesystem | Kullanım Alanı |
|---|---|
| ext4 | Genel amaçlı, stabil, yaygın |
| XFS | Büyük dosyalar ve yüksek performanslı sistemler |
| btrfs | Snapshot ve gelişmiş özellikler |
| vfat | EFI partition veya taşınabilir uyumluluk |

## 4.1 ext4 Filesystem Oluşturma

```bash
sudo mkfs.ext4 /dev/sdb1
```

## 4.2 XFS Filesystem Oluşturma

```bash
sudo mkfs.xfs /dev/sdb1
```

> Not: XFS küçültülemez, sadece büyütülebilir. Bu yüzden production planlamasında dikkatli olunmalıdır.

## 4.3 Filesystem Kontrolü

```bash
lsblk -f
```

Örnek:

```text
sdb
└─sdb1 ext4  1.0  aaaa-bbbb
```

---

# 5. Mount ve Kalıcı Mount İşlemleri

Filesystem oluşturduktan sonra bu alanı Linux dizin ağacına bağlamamız gerekir. Bu işleme mount denir.

## 5.1 Mount Point Oluşturma

```bash
sudo mkdir -p /mnt/data
```

## 5.2 Manuel Mount

```bash
sudo mount /dev/sdb1 /mnt/data
```

Kontrol:

```bash
df -h
```

veya:

```bash
lsblk
```

## 5.3 Test Dosyası Oluşturma

```bash
touch /mnt/data/test.txt
ls -l /mnt/data
```

Eğer dosya oluşuyorsa mount başarılıdır.

## 5.4 Unmount İşlemi

```bash
sudo umount /mnt/data
```

Eğer `target is busy` hatası alırsanız, o dizini kullanan bir process vardır.

Kontrol:

```bash
sudo lsof +D /mnt/data
```

veya:

```bash
fuser -vm /mnt/data
```

## 5.5 Kalıcı Mount: `/etc/fstab`

Manuel mount reboot sonrası kaybolur. Kalıcı hale getirmek için `/etc/fstab` dosyasına eklenmelidir.

Önce UUID öğrenilir:

```bash
sudo blkid /dev/sdb1
```

Örnek:

```text
/dev/sdb1: UUID="aaaa-bbbb" TYPE="ext4"
```

`/etc/fstab` dosyasını açın:

```bash
sudo nano /etc/fstab
```

Aşağıdaki satırı ekleyin:

```fstab
UUID=aaaa-bbbb /mnt/data ext4 defaults 0 2
```

Kaydettikten sonra test edin:

```bash
sudo mount -a
```

Eğer hata yoksa tanım doğrudur.

> Kritik not: `/etc/fstab` hatalı yazılırsa sistem reboot sonrası açılışta problem yaşayabilir. Bu yüzden reboot atmadan önce mutlaka `mount -a` ile test edin.

---

# 6. Disk Kullanımını Analiz Etme

Linux sistemlerde en sık karşılaşılan sorunlardan biri disk doluluğudur. Disk dolduğu zaman servisler log yazamaz, veritabanları hata verir, uygulamalar beklenmedik şekilde durabilir.

## 6.1 Genel Disk Kullanımı

```bash
df -h
```

Örnek:

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        49G   47G  1.2G  98% /
```

Burada `/` filesystemi %98 dolu. Bu kritik bir durumdur.

## 6.2 Hangi Dizin Büyük?

```bash
sudo du -h --max-depth=1 / | sort -hr | head -20
```

Örnek:

```text
20G /var
12G /opt
5G  /usr
2G  /home
```

Bu durumda `/var` ve `/opt` incelenmelidir.

## 6.3 `/var` Altını İnceleme

```bash
sudo du -h --max-depth=1 /var | sort -hr | head -20
```

Örnek:

```text
15G /var/log
3G  /var/lib
```

## 6.4 En Büyük Dosyaları Bulma

```bash
sudo find / -type f -size +500M -exec ls -lh {} \; 2>/dev/null
```

Daha okunabilir:

```bash
sudo find / -type f -exec du -h {} + 2>/dev/null | sort -hr | head -20
```

## 6.5 Inode Doluluğu

Bazen disk alanı dolu görünmez ama sistem dosya oluşturamaz. Bunun nedeni inode doluluğu olabilir.

```bash
df -i
```

Eğer `IUse%` değeri %100 ise çok fazla küçük dosya vardır.

---

# 7. LVM ile Esnek Disk Yönetimi

LVM, Linux sistemlerde disk alanını daha esnek yönetmek için kullanılır.

Klasik yapıda:

```text
Disk → Partition → Filesystem → Mount
```

LVM yapısında:

```text
Disk/Partition → Physical Volume → Volume Group → Logical Volume → Filesystem → Mount
```

## 7.1 LVM Kavramları

| Kavram | Açıklama |
|---|---|
| PV | Physical Volume. LVM’e dahil edilen disk veya partition |
| VG | Volume Group. PV’lerden oluşan disk havuzu |
| LV | Logical Volume. VG içinden ayrılan mantıksal disk alanı |

## 7.2 LVM Paket Kontrolü

Ubuntu/Debian:

```bash
sudo apt install lvm2 -y
```

RHEL/Rocky/AlmaLinux:

```bash
sudo dnf install lvm2 -y
```

## 7.3 Physical Volume Oluşturma

```bash
sudo pvcreate /dev/sdb1
```

Kontrol:

```bash
sudo pvs
```

## 7.4 Volume Group Oluşturma

```bash
sudo vgcreate vg_data /dev/sdb1
```

Kontrol:

```bash
sudo vgs
```

## 7.5 Logical Volume Oluşturma

```bash
sudo lvcreate -L 10G -n lv_appdata vg_data
```

Kontrol:

```bash
sudo lvs
```

## 7.6 Filesystem Oluşturma

```bash
sudo mkfs.ext4 /dev/vg_data/lv_appdata
```

## 7.7 Mount Etme

```bash
sudo mkdir -p /appdata
sudo mount /dev/vg_data/lv_appdata /appdata
```

Kontrol:

```bash
df -h /appdata
```

---

# 8. LVM Disk Genişletme Senaryosu

Bu bölüm gerçek hayatta en çok ihtiyaç duyulan işlemlerden biridir.

Senaryo:

- `/appdata` dizini LVM üzerinde çalışıyor.
- Alan dolmak üzere.
- Volume Group içinde boş alan var.
- Logical Volume büyütülecek.

## 8.1 Mevcut Durumu Kontrol Etme

```bash
df -h /appdata
sudo vgs
sudo lvs
```

## 8.2 LV Alanını Büyütme

5 GB eklemek için:

```bash
sudo lvextend -L +5G /dev/vg_data/lv_appdata
```

Tüm boş alanı vermek için:

```bash
sudo lvextend -l +100%FREE /dev/vg_data/lv_appdata
```

## 8.3 Filesystem Büyütme

Eğer filesystem ext4 ise:

```bash
sudo resize2fs /dev/vg_data/lv_appdata
```

Eğer filesystem XFS ise:

```bash
sudo xfs_growfs /appdata
```

## 8.4 Tek Komutla Büyütme

Bazı durumlarda `-r` parametresi hem LV hem filesystem büyütür:

```bash
sudo lvextend -r -L +5G /dev/vg_data/lv_appdata
```

Kontrol:

```bash
df -h /appdata
```

---

# 9. Swap Yönetimi

Swap, RAM yetersiz kaldığında diskin bir kısmının geçici bellek gibi kullanılmasını sağlar. RAM yerine geçmez ama sistemin tamamen çökmesini önlemeye yardımcı olabilir.

## 9.1 Swap Durumunu Görme

```bash
swapon --show
free -h
```

## 9.2 Swap File Oluşturma

Örnek 2 GB swap file:

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

Kontrol:

```bash
swapon --show
free -h
```

## 9.3 Kalıcı Swap Tanımı

`/etc/fstab` içine eklenir:

```fstab
/swapfile none swap sw 0 0
```

## 9.4 Swap Kapatma

```bash
sudo swapoff /swapfile
sudo rm /swapfile
```

---

# 10. Disk Sağlığı ve Performans Kontrolleri

## 10.1 Disk Modeli ve Bilgileri

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
```

## 10.2 SMART Durumu

SMART, diskin sağlık bilgilerini okumak için kullanılır.

Paket kurulumu:

```bash
sudo apt install smartmontools -y
```

Disk kontrolü:

```bash
sudo smartctl -a /dev/sda
```

Kısa sağlık kontrolü:

```bash
sudo smartctl -H /dev/sda
```

## 10.3 Basit Yazma Testi

```bash
dd if=/dev/zero of=/tmp/testfile bs=1G count=1 oflag=direct
```

> Uyarı: `dd` dikkatli kullanılmalıdır. Yanlış `of=` parametresiyle disk üzerine veri yazıp sistemi bozabilirsiniz.

## 10.4 `fio` ile Performans Testi

Kurulum:

```bash
sudo apt install fio -y
```

Rastgele okuma/yazma testi:

```bash
fio --name=random-rw-test --size=1G --rw=randrw --bs=4k --numjobs=1 --runtime=60 --time_based --group_reporting
```

---

# 11. Disk Temizleme ve Gerçek Hayat Senaryoları

## Senaryo 1: `/var/log` Çok Büyümüş

Kontrol:

```bash
sudo du -h --max-depth=1 /var/log | sort -hr
```

Journal log alanı:

```bash
journalctl --disk-usage
```

Journal logları 7 güne düşürmek:

```bash
sudo journalctl --vacuum-time=7d
```

Belirli boyuta düşürmek:

```bash
sudo journalctl --vacuum-size=1G
```

## Senaryo 2: Docker Disk Alanı Tüketiyor

```bash
docker system df
```

Kullanılmayan objeleri temizleme:

```bash
docker system prune
```

Daha agresif temizlik:

```bash
docker system prune -a --volumes
```

> Uyarı: Bu komut kullanılmayan image, container, network ve volume objelerini silebilir. Production ortamda çalıştırmadan önce etkisini anlayın.

## Senaryo 3: Silinen Dosya Alanı Geri Vermiyor

Bazen büyük bir log dosyası silinir ama disk alanı düşmez. Bunun nedeni dosyanın bir process tarafından hala açık tutulmasıdır.

Kontrol:

```bash
sudo lsof | grep deleted
```

Örnek:

```text
java  1234  app  5w REG  8,1  10G /var/log/app.log (deleted)
```

Bu durumda process restart edilmeden alan geri gelmeyebilir.

## Senaryo 4: `/tmp` Alanı Şişmiş

```bash
sudo du -h --max-depth=1 /tmp | sort -hr | head
```

Eski dosyaları bulma:

```bash
sudo find /tmp -type f -mtime +7 -ls
```

Silme:

```bash
sudo find /tmp -type f -mtime +7 -delete
```

---

# 12. Troubleshooting Rehberi

## Problem: Yeni Disk Görünmüyor

Kontrol:

```bash
lsblk
sudo fdisk -l
dmesg | tail -50
```

Sanal ortamdaysanız disk ekledikten sonra rescan gerekebilir:

```bash
echo "- - -" | sudo tee /sys/class/scsi_host/host0/scan
```

Birden fazla host varsa:

```bash
for host in /sys/class/scsi_host/host*; do echo "- - -" | sudo tee $host/scan; done
```

## Problem: Mount Edilemiyor

Kontrol:

```bash
lsblk -f
sudo blkid
sudo dmesg | tail -50
```

Filesystem bozuk olabilir. ext4 için:

```bash
sudo fsck /dev/sdb1
```

> Uyarı: Mounted filesystem üzerinde `fsck` çalıştırmayın. Önce unmount edin.

## Problem: Disk Dolu Ama Büyük Dosya Bulamıyorum

Kontrol sırası:

```bash
df -h
sudo du -h --max-depth=1 / | sort -hr
sudo lsof | grep deleted
df -i
```

Muhtemel nedenler:

- Silinmiş ama açık tutulan dosyalar
- Inode doluluğu
- Başka filesystem üzerine mount edildiği için gizlenen eski dosyalar
- Docker volume veya overlay alanları
- Journal log büyümesi

## Problem: `/etc/fstab` Sonrası Sistem Açılmıyor

Muhtemel nedenler:

- Yanlış UUID
- Yanlış filesystem tipi
- Yanlış mount point
- Diskin boot sırasında hazır olmaması

Önlemek için her değişiklikten sonra:

```bash
sudo mount -a
```

Ayrıca kritik olmayan disklerde `nofail` kullanılabilir:

```fstab
UUID=aaaa-bbbb /mnt/data ext4 defaults,nofail 0 2
```

---

# 13. Komut Cheat Sheet

## Diskleri Görme

```bash
lsblk
lsblk -f
sudo fdisk -l
sudo blkid
```

## Disk Kullanımı

```bash
df -h
df -i
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

## Log Temizleme

```bash
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=1G
```

## Docker Disk Temizliği

```bash
docker system df
docker system prune
docker system prune -a --volumes
```

---

# 14. Lab Çalışmaları

Bu repo içinde ayrıca uygulamalı lab dosyaları bulunmaktadır:

| Dosya | Açıklama |
|---|---|
| [`labs/01-disk-discovery.md`](labs/01-disk-discovery.md) | Diskleri ve partitionları görüntüleme labı |
| [`labs/02-partition-format-mount.md`](labs/02-partition-format-mount.md) | Partition, format ve mount labı |
| [`labs/03-lvm-basics.md`](labs/03-lvm-basics.md) | LVM oluşturma labı |
| [`labs/04-lvm-extend.md`](labs/04-lvm-extend.md) | LVM disk genişletme labı |
| [`labs/05-disk-full-troubleshooting.md`](labs/05-disk-full-troubleshooting.md) | Disk doluluk troubleshooting labı |

---

# 15. Production Notları

- Production sunucuda işlem yapmadan önce mutlaka disk adını doğrulayın.
- `mkfs`, `fdisk`, `parted`, `pvcreate` gibi komutlar veri kaybına neden olabilir.
- `/etc/fstab` değişikliğinden sonra reboot atmadan önce mutlaka `mount -a` çalıştırın.
- LVM genişletmeden önce mümkünse snapshot veya backup alın.
- XFS filesystem küçültülemez.
- ext4 filesystem büyütme için genellikle `resize2fs`, XFS için `xfs_growfs` kullanılır.
- Silinen dosya alanı geri vermiyorsa `lsof | grep deleted` kontrol edilmelidir.
- Docker kullanılan sistemlerde `/var/lib/docker` düzenli izlenmelidir.
- Elasticsearch, MongoDB, PostgreSQL gibi servislerde disk doluluğu servis kesintisine neden olabilir.
- Disk yönetimi sırasında komutları kopyala-yapıştır yapmayın; önce hedef diski anlayın.

---

