#!/sbin/sh

mount -t ext4 /dev/block/bootdevice/by-name/system /system
mount -t ext4 /dev/block/bootdevice/by-name/persist /persist

asus_prop=$(grep -E 'asus.sku|asus.version' /system/build.prop)

[ -n "$asus_prop" ] && echo "$asus_prop" | sed -e 's/ /\n/' > /persist/asus.prop

if [ -f /persist/asus.prop ]; then
    asus_sku=$(grep sku /persist/asus.prop | cut -d '=' -f 2)
    [ -n "$asus_sku" ] && setprop ro.build.asus.sku "$asus_sku"

    asus_version=$(grep version /persist/asus.prop | cut -d '=' -f 2)
    [ -n "$asus_version" ] && setprop ro.build.asus.version "$asus_version"
fi

umount /persist
umount /system
