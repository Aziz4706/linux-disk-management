#!/usr/bin/env bash

set -euo pipefail

echo "=============================="
echo " Linux Disk Usage Report"
echo " Generated: $(date)"
echo "=============================="
echo

echo "[1] Filesystem usage:"
df -h | grep -v tmpfs || true
echo

echo "[2] Inode usage:"
df -i | grep -v tmpfs || true
echo

echo "[3] Block devices:"
lsblk -f || true
echo

echo "[4] Top-level directory usage:"
sudo du -h --max-depth=1 / 2>/dev/null | sort -hr | head -20 || true
echo

echo "[5] Journal usage:"
journalctl --disk-usage 2>/dev/null || true
echo

echo "[6] Deleted but open files:"
sudo lsof 2>/dev/null | grep deleted | head -20 || true
echo

echo "Report completed."
