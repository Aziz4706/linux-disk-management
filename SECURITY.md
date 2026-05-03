# Security Notes

Bu repo eğitim amaçlıdır.

Disk yönetimi komutları veri kaybına neden olabilir. Özellikle aşağıdaki komutları production sistemlerde çalıştırmadan önce hedef diski doğrulayın:

- `fdisk`
- `parted`
- `mkfs`
- `pvcreate`
- `vgcreate`
- `lvremove`
- `dd`
- `wipefs`

Öneri:

- Önce test sanal makinesinde deneyin.
- Production ortamda snapshot veya backup alın.
- Komutları kopyala-yapıştır yapmadan önce hedef device bilgisini doğrulayın.
