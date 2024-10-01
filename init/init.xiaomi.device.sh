#!/vendor/bin/sh

# Function to set audio calibration file properties
set_acdb_path_props() {
	i=0
	for f in /vendor/etc/acdbdata/${1}/*.*; do
		[ -f "$f" ] && setprop "persist.vendor.audio.calfile${i}" "$f"
		i=$((i + 1))
	done
}

# Read the codename from the mi439 mach once
codename="$(cat /sys/xiaomi-sdm439-mach/codename)"
setprop ro.vendor.xiaomi.device "$codename"

# Set properties based on codename
case "$codename" in
	"pine")
		setprop ro.vendor.xiaomi.series pine
		set_acdb_path_props pine
		;;
	"olive"|"olivelite"|"olivewood")
		setprop ro.vendor.xiaomi.series olive
		set_acdb_path_props olive
		setprop persist.vendor.ctm.disallowed true
		[ "$codename" = "olive" ] && {
			setprop persist.vendor.camera.aec.sync 1
			setprop persist.vendor.camera.awb.sync 2
		}
		setprop persist.vendor.camera.expose.aux 1
		;;
	*) exit 0 ;;
esac

exit 0
