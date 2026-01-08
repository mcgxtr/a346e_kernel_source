#!/bin/bash

# 1. Değişken Tanımlamaları
export DEVICE_MODULES_DIR="kernel_device_modules-6.6"
export BUILD_CONFIG="../out/target/product/a34x/obj/KERNEL_OBJ/build.config"
export OUT_DIR="../out/target/product/a34x/obj/KLEAF_OBJ"
export DIST_DIR="../out/target/product/a34x/obj/KLEAF_OBJ/dist"
export DEFCONFIG_OVERLAYS="mt6877_overlay.config mt6877_teegris_5_overlay.config"
export PROJECT="mgk_64_k66"
export MODE="user"

echo "===> Klasör yapılandırması kontrol ediliyor..."

# 2. Gerekli Linklerin Oluşturulması
# Samsung kaynak kodlarının yolu (Sizin sisteminize göre ayarlandı)
SAM_SRC="/home/jack/a34"

# Ana Kernel Linki
if [ ! -L "kernel-6.6" ]; then
    ln -s $SAM_SRC/kernel-6.6 ./kernel-6.6
    echo "[+] kernel-6.6 linklendi."
fi

# Cihaz Modülleri Linki
if [ ! -L "kernel_device_modules-6.6" ]; then
    ln -s $SAM_SRC/kernel/kernel_device_modules-6.6 ./kernel_device_modules-6.6
    echo "[+] kernel_device_modules linklendi."
fi

# Vendor (Mediatek) Linkleri
if [ ! -L "vendor" ]; then
    ln -s $SAM_SRC/vendor ./vendor
    echo "[+] İç vendor linklendi."
fi

if [ ! -L "../vendor" ]; then
    ln -s $SAM_SRC/vendor ../vendor
    echo "[+] Üst vendor linklendi."
fi

# Bazel Kuralları Linki
if [ ! -L "build/bazel_mgk_rules" ]; then
    ln -s $SAM_SRC/kernel/build/bazel_mgk_rules ./build/bazel_mgk_rules
    echo "[+] Bazel kuralları linklendi."
fi

# 3. Çıktı Klasörünü Hazırla
mkdir -p ../out/target/product/a34x/obj/KERNEL_OBJ/

echo "===> Build Config oluşturuluyor..."
python3 kernel_device_modules-6.6/scripts/gen_build_config.py \
  --kernel-defconfig mediatek-bazel_defconfig \
  --kernel-defconfig-overlays "mt6877_overlay.config mt6877_teegris_5_overlay.config" \
  --kernel-build-config-overlays "" \
  -m user -o ../out/target/product/a34x/obj/KERNEL_OBJ/build.config

echo "===> Derleme başlatılıyor..."
chmod +x ./kernel_device_modules-6.6/build.sh
./kernel_device_modules-6.6/build.sh
