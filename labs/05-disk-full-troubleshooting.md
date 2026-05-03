# Lab 05 - Disk Doluluk Troubleshooting

## Amaç

Disk doluluk problemlerinde sistematik analiz yapmayı öğrenmek.

## Adım 1 - Genel Doluluk Kontrolü

```bash
df -h
```

## Adım 2 - Inode Kontrolü

```bash
df -i
```

## Adım 3 - Kök Dizinden Büyük Alanları Bulma

```bash
sudo du -h --max-depth=1 / | sort -hr | head -20
```

## Adım 4 - Büyük Dosyaları Bulma

```bash
sudo find / -type f -exec du -h {} + 2>/dev/null | sort -hr | head -20
```

## Adım 5 - Silinmiş Ama Açık Dosyaları Bulma

```bash
sudo lsof | grep deleted
```

## Adım 6 - Journal Log Kontrolü

```bash
journalctl --disk-usage
```

Temizleme örnekleri:

```bash
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=1G
```

## Adım 7 - Docker Alan Kontrolü

```bash
docker system df
```

## Troubleshooting Sırası

```text
df -h
↓
df -i
↓
du ile büyük dizinleri bul
↓
find ile büyük dosyaları bul
↓
lsof deleted kontrolü yap
↓
journalctl ve Docker alanını kontrol et
```
