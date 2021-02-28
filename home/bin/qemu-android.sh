#!/bin/sh

#qemu-img create -f qcow2 /media/storage/.libvirt/images/android.qcow2 25G
#qemu-android /media/storage/iso/android/android-x86_64-9.0-r2.iso -hda /media/storage/.libvirt/images/android.qcow2 -boot d
#qemu-system-x86_64 -enable-kvm /media/storage/iso/android/android-x86_64-9.0-r2.iso -hda /media/storage/.libvirt/images/android.qcow2 -boot d
#qemu-system-x86_64 -enable-kvm -device ES1370 -net nic -net user -cdrom ${@:-/media/storage/iso/android/android-x86_64-9.0-r2.iso} 

#qemu-img create -f qcow2 /media/storage/.libvirt/images/android.qcow2 20G

#qemu-system-x86_64 \
#-enable-kvm \

qemu-android \
-m 2048 \
-smp 2 \
-cpu host \
-device ES1370 \
-device virtio-mouse-pci -device virtio-keyboard-pci \
-serial mon:stdio \
-device virtio-vga,virgl=on \
-display gtk,gl=on \
-hda /media/storage/.libvirt/images/android.qcow2 \
-cdrom /media/storage/iso/android/android-x86_64-9.0-r2.iso &&

#-enable-kvm \
#-boot menu=on \
#qemu-system-x86_64 \

qemu-android \
-m 2048 \
-smp 2 \
-cpu host \
-device ES1370 \
-device virtio-mouse-pci -device virtio-keyboard-pci \
-serial mon:stdio \
-device virtio-vga,virgl=on \
-display gtk,gl=on \
-hda /media/storage/.libvirt/images/android.qcow2
