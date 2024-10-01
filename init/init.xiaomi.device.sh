#!/vendor/bin/sh

# Function to set audio calibration file properties
set_acdb_path_props() {
	i=0
	for f in /vendor/etc/acdbdata/${1}/*.*; do
		[ -f "$f" ] && setprop "persist.vendor.audio.calfile${i}" "$f"
		i=$((i + 1))
	done
}

# Read the codename from the mi439 mach once.
codename="$(cat /sys/xiaomi-sdm439-mach/codename)"

# Set device and series properties based on the codename
case "$codename" in
	"pine")
		setprop ro.vendor.xiaomi.device pine
		setprop ro.vendor.xiaomi.series pine
		# Audio
		set_acdb_path_props pine
		;;
	"olive"|"olivelite"|"olivewood")
		setprop ro.vendor.xiaomi.device "$codename"
		setprop ro.vendor.xiaomi.series olive
		# Audio
		set_acdb_path_props olive
		# Charger
		setprop persist.vendor.ctm.disallowed true
		;;
	*)
		exit 0
		;;
esac

# Camera
if [ "$codename" = "olive" ]; then
	setprop persist.vendor.camera.aec.sync 1
	setprop persist.vendor.camera.awb.sync 2
fi

# Camera
case "$codename" in
	"olive"|"olivewood")
		setprop persist.vendor.camera.expose.aux 1
		;;
esac

exit 0
