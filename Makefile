SHELL := /bin/bash # Use bash syntax
# Install paths for the generated images
SCUMMVM_PATH = "../scummvm"
BACKGROUND = "\#cc6600"

REPOSITORY_IMAGES = \
	$(foreach icon, scummvm_icon scummvm_tools_icon, $(foreach size, 16 32 64 128 256 512 1024, $(icon)_$(size).png)) \
	scummvm_icon.png \
	scummvm_icon.xpm \
	scummvm_icon.ico \
	scummvm_icon_16.ico \
	scummvm_icon_32.ico \
	scummvm_tools_icon.ico \
	scummvm_logo.pdf

PORTS_IMAGES = \
	$(foreach size, 18 26 40 48 50 72 74 96 144 192 304, ports/scummvm_icon_$(size).png) \
	ports/scummvm_icon_dc.h \
	ports/scummvm_icon_dc.ico \
	ports/scummvm_icon_moto32.png \
	ports/scummvm_icon_moto48.png \
	$(foreach size, 16 18 32 40 64, ports/scummvm_icon_symbian$(size).bmp ports/scummvm_icon_symbian$(size)m.bmp) \
	$(foreach size, 29 58 60 72 87 40 80 114 120 180 76 152 167, ports/scummvm_iphone_icon_$(size).png) \
	$(foreach size, 58 60 72 87 40 80 114 120 180 76 152 167 128 136 192 1024, ports/scummvm_iphone_icon_$(size).png) \
	$(foreach size, 58 60 72 87 40 80 114 120 180 76 152 167 128 136 192 1024, ports/scummvm_iphone_tinted_icon_$(size).png) \
	$(foreach size, 58 60 72 87 40 80 114 120 180 76 152 167 128 136 192 1024, ports/scummvm_iphone_dark_icon_$(size).png) \
	ports/scummvm_iphone_loading.png \
	$(foreach size, 640x1136 750x1334 768x1024 828x1792 1024x768 1125x2436 1242x2208 1242x2688 1536x2048 1792x828 2048x1536 2208x1242 2436x1125 2688x1242, ports/scummvm_ios7_$(size).png) \
	ports/scummvm_logo_psp.png \
	ports/scummvm_logo_wii.png \
	ports/scummvm_wince_bar.bmp \
	ports/scummvm_wince_bar.png \
	ports/scummvm_logo_android.png \
	ports/scummvm_icon_android_tv.png \
	ports/scummvm_icon_ouya.png \
	ports/scummvm_icon_gph.png \
	ports/scummvm_banner_3ds.png \
	ports/scummvm_icon_3ds.png \
	ports/scummvm_icon_ps3.png \
	ports/scummvm_bg_vita.png \
	ports/scummvm_startup_vita.png \
	ports/scummvm_banner_ds.png \
	ports/scummvm_icon_ds.bmp \
	$(foreach letter, A B C D E F G H I J K, ports/scummvm_icon_ds_$(letter).bmp) \
	$(foreach size, 480x800 240x400, ports/scummvm_bada_$(size).png)


ICON_BIG = 512

all: $(REPOSITORY_IMAGES)

# REPOSITORY IMAGES

scummvm_icon.png: originals/scummvm_icon.png
	cp $^ $@

scummvm_icon_%.png: scummvm_icon.png
	magick $< -size $*x$* $@

scummvm_icon_%.ico: scummvm_icon.png
	magick $< -size $*x$* $@

scummvm_icon.xpm: scummvm_icon.png
	magick $< -size 32x32 -depth 4 xpm:- | sed -e 's/static /static const /' -e 's/xpm__/scummvm_icon/' > $@

scummvm_icon.ico: scummvm_icon.png
	magick $< \
		\( -clone 0 -size 32x32 -depth 4 -colors 15 -alpha on \) \
		\( -clone 0 -size 16x16 -depth 4 -colors 15 -alpha on \) \
		\( -clone 0 -size 48x48 -depth 8 \) \
		\( -clone 0 -size 32x32 -depth 8 \) \
		\( -clone 0 -size 16x16 -depth 8 \) \
		\( -clone 0 -size 256x256 \) \
		\( -clone 0 -size 48x48 \) \
		\( -clone 0 -size 32x32 \) \
		\( -clone 0 -size 16x16 \) \
		-delete 0 \
		$@

scummvm_tools_icon.png: scummvm_icon.png derivate/scummvm_tools_badge.svg
	magick -background none -gravity SouthEast -composite $^ $@

scummvm_tools_icon.ico: scummvm_tools_icon.png
	magick $< \
		\( -clone 0 -size 32x32 -depth 4 -colors 15 -alpha on \) \
		\( -clone 0 -size 16x16 -depth 4 -colors 15 -alpha on \) \
		\( -clone 0 -size 48x48 -depth 8 \) \
		\( -clone 0 -size 32x32 -depth 8 \) \
		\( -clone 0 -size 16x16 -depth 8 \) \
		\( -clone 0 -size 256x256 \) \
		\( -clone 0 -size 48x48 \) \
		\( -clone 0 -size 32x32 \) \
		\( -clone 0 -size 16x16 \) \
		-delete 0 \
		$@

scummvm_logo.png: originals/scummvm_logo.png
	cp $^ $@

scummvm_logo.pdf: scummvm_logo.png
	magick $< $@

# TOOLS ICON

scummvm_tools_icon_%.png: scummvm_tools_icon.png
	magick $< -size $*x$* $@

# Mac
# The legacy icns generated with iconutil doesn't actually work properly on Mac OS X 10.5 (see bug #11261)
# Instead it needs to be generated with Icon Composer on an old Mac (but the scummvm_icon_legacy.iconset
# rule below can be used to generate the source png images for Icon Composer).
#mac: scummvm_icon.icns scummvm_icon_legacy.icns scummvm_tools_icon.icns
mac: scummvm_icon.icns scummvm_tools_icon.icns

scummvm_icon.iconset: scummvm_icon_mac.png
	mkdir $@
	$(foreach size, 16 32 128 256 512, sips -z $(size) $(size) $< --out $@/icon_$(size)x$(size).png;)
	$(foreach size, 32 64 256 512 1024, sips -z $(size) $(size) $< --out $@/icon_$(size)x$(size)@2x.png;)

scummvm_icon_legacy.iconset: scummvm_icon.png
	mkdir $@
	$(foreach size, 16 32 128 256 512, sips -z $(size) $(size) $< --out $@/icon_$(size)x$(size).png;)

scummvm_tools_icon.iconset: scummvm_tools_icon.png
	mkdir $@
	$(foreach size, 16 32 128 256 512, sips -z $(size) $(size) $< --out $@/icon_$(size)x$(size).png;)
	$(foreach size, 32 64 256 512 1024, sips -z $(size) $(size) $< --out $@/icon_$(size)x$(size)@2x.png;)

scummvm_icon.icns: scummvm_icon.iconset
	iconutil -c icns $<
	rm -rf $<

scummvm_icon_legacy.icns: scummvm_icon_legacy.iconset
	iconutil -c icns $<
	rm -rf $<

scummvm_tools_icon.icns: scummvm_tools_icon.iconset
	iconutil -c icns $<
	rm -rf $<

# PORT SPECIFIC IMAGES
ports/scummvm_icon_%.png: scummvm_icon.png
	magick $< -size $*x$* $@

ports/scummvm_ios7_%.png: scummvm_logo.png
	magick $< -size 640 -gravity Center -background $(BACKGROUND) -extent $* $@

ports/scummvm_icon_dc.h: ports/scummvm_icon_dc.ico
	echo "static const unsigned char scummvm_icon[] = {" > $@
	xxd -i < $< >> $@
	echo "};" >> $@

#TODO: Validate that this works on DC
ports/scummvm_icon_dc.ico: scummvm_icon.png
	magick $< -size 32x32 -colors 15 -depth 4 -alpha on $@

ports/scummvm_icon_moto32.png: scummvm_icon.png
	magick $< -size 32x24 -gravity Center -background none -extent 32x24 $@

ports/scummvm_icon_moto48.png: scummvm_icon.png
	magick $< -size 48x32 -gravity Center -background none -extent 48x32 $@

ports/scummvm_icon_symbian16.bmp: scummvm_icon.png
	magick $< -size 16x16 -background black -flatten ppm:- | ppmtobmp - -bpp 24 > $@

ports/scummvm_icon_symbian16m.bmp: scummvm_icon.png
	magick $< -size 16x16 -alpha extract -threshold 0 -negate ppm:- | ppmtobmp - -bpp 4 > $@

ports/scummvm_icon_symbian18.bmp: scummvm_icon.png
	magick $< -size 18x18 -background black -flatten ppm:- | ppmtobmp - -bpp 24 > $@

ports/scummvm_icon_symbian18m.bmp: scummvm_icon.png
	magick $< -size 18x18 -alpha extract -threshold 0 ppm:- | ppmtobmp - -bpp 4 > $@

ports/scummvm_icon_symbian32.bmp: scummvm_icon.png
	magick $< -size 32x32 -background black -flatten -colors 256 ppm:- | ppmtobmp - -bpp 8 > $@

ports/scummvm_icon_symbian32m.bmp: scummvm_icon.png
	magick $< -size 32x32 -alpha extract -threshold 0 -negate ppm:- | ppmtobmp - -bpp 4 > $@

ports/scummvm_icon_symbian40.bmp: scummvm_icon.png
	magick $< -size 40x40 -background white -flatten ppm:- | ppmtobmp - -bpp 24 > $@

ports/scummvm_icon_symbian40m.bmp: scummvm_icon.png
	magick $< -size 40x40 -alpha extract -threshold 0 ppm:- | ppmtobmp - -bpp 4 > $@

ports/scummvm_icon_symbian64.bmp: scummvm_icon.png
	magick $< -size 64x64 -background white -flatten ppm:- | ppmtobmp - -bpp 24 > $@

ports/scummvm_icon_symbian64m.bmp: scummvm_icon.png
	magick $< -size 64x64 -alpha extract -threshold 0 ppm:- | ppmtobmp - -bpp 4 > $@

ports/scummvm_iphone_icon_%.png: derivate/scummvm_iphone_icon.svg scummvm_icon.png
	inkscape -o $@ -w $* -h $* $<

ports/scummvm_iphone_tinted_icon_%.png: derivate/scummvm_ios7_tinted_icon.svg
	inkscape -o $@ -w $* -h $* $<

ports/scummvm_iphone_dark_icon_%.png: derivate/scummvm_ios7_dark_icon.svg scummvm_icon.png
	inkscape -o $@ -w $* -h $* $<

ports/scummvm_iphone_loading.png: scummvm_logo.png
	magick $< -size 320 -gravity Center -background $(BACKGROUND) -extent 320x460 $@

ports/scummvm_logo_psp.png: scummvm_logo.png
	magick $< -size 150 $@

ports/scummvm_logo_wii.png: scummvm_logo.png
	magick $< -size 128x48 -gravity center -background none -extent 128x48 $@

ports/scummvm_wince_bar.bmp: ports/scummvm_wince_bar.png
	@#TODO: Can 'magick' write indexed BMPs directly?
	magick $< -colors 256 ppm:- | ppmtobmp - -bpp 8 > $@

ports/scummvm_wince_bar.png: derivate/scummvm_wince_bar.svg
	inkscape -o $@ $<

ports/scummvm_logo_android.png: scummvm_logo.png
	magick $< -size 351 $@

ports/scummvm_icon_android_tv.png: scummvm_logo.png
	magick $< -size 300 -gravity center -background $(BACKGROUND) -extent 320x180 $@

ports/scummvm_icon_ouya.png: scummvm_logo.png
	magick $< -size 732 -gravity center -background white -extent 732x214 $@
	magick $@ -gravity center -background none -extent 732x412 $@

ports/scummvm_icon_gph.png: scummvm_logo.png
	magick $< -size x57 -gravity center -background $(BACKGROUND) -extent 305x57 $@

ports/scummvm_banner_3ds.png: scummvm_logo.png
	magick $< -size 256 -gravity center -background none -extent 256x128 $@

ports/scummvm_icon_3ds.png: scummvm_icon.png
	magick $< -size 48 -background $(BACKGROUND) -flatten $@

ports/scummvm_icon_ps3.png: scummvm_logo.png
	magick $< -size 320 -gravity center -background none -extent 320x176 $@

ports/scummvm_bg_vita.png: scummvm_logo.png
	magick $< -size 800 -gravity center -background $(BACKGROUND) -extent 840x500 $@

ports/scummvm_startup_vita.png: scummvm_logo.png
	magick $< -size 270 -gravity center -background $(BACKGROUND) -extent 280x158 $@

ports/scummvm_banner_ds.png: scummvm_logo.png
	magick $< -size 200 -gravity center -background $(BACKGROUND) -extent 256x192 $@

ports/scummvm_icon_ds.bmp: scummvm_icon.png
	magick $< -size 32 -background "#AED769" -flatten -type Palette BMP3:$@

ports/scummvm_icon_ds_%.bmp: scummvm_icon.png derivate/ds_overlay.png
	magick $< -trim -size x32 -background white -gravity west -extent 32x32 $@
	convert -background none -gravity SouthEast -composite $@ $(word 2,$^) $@
	convert $@ -background none +antialias -pointsize 8 label:$* -trim -geometry +1+1 -gravity SouthEast -composite -type Palette BMP3:$@

ports/scummvm_bada_%.png: scummvm_logo.png
	magick $< -size $*\> -gravity center -background $(BACKGROUND) -extent $* $@

ports: scummvm_icon.ico scummvm_icon.xpm scummvm_icon_16.ico scummvm_icon_32.ico scummvm_icon_32.png $(PORTS_IMAGES)

update: ports
# Android
	cp scummvm_icon_64.png               $(SCUMMVM_PATH)/dists/android/res/drawable/scummvm.png
	cp ports/scummvm_logo_android.png    $(SCUMMVM_PATH)/dists/android/res/drawable/scummvm_big.png
	cp ports/scummvm_icon_android_tv.png $(SCUMMVM_PATH)/dists/android/res/drawable-xhdpi/leanback_icon.png
	cp ports/scummvm_icon_ouya.png       $(SCUMMVM_PATH)/dists/android/res/drawable-xhdpi/ouya_icon.png
	cp ports/scummvm_icon_72.png         $(SCUMMVM_PATH)/dists/android/res/mipmap-hdpi/scummvm.png
	cp ports/scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/android/res/mipmap-mdpi/scummvm.png
	cp ports/scummvm_icon_96.png         $(SCUMMVM_PATH)/dists/android/res/mipmap-xhdpi/scummvm.png
	cp ports/scummvm_icon_144.png        $(SCUMMVM_PATH)/dists/android/res/mipmap-xxhdpi/scummvm.png
	cp ports/scummvm_icon_192.png        $(SCUMMVM_PATH)/dists/android/res/mipmap-xxxhdpi/scummvm.png
	cp scummvm_icon_128.png              $(SCUMMVM_PATH)/dists/androidsdl/scummvm/icon.png
	cp ports/scummvm_icon_android_tv.png $(SCUMMVM_PATH)/dists/androidsdl/scummvm/banner.png

# BADA
	cp ports/scummvm_bada_480x800.png    $(SCUMMVM_PATH)/dists/bada/icons/splash1.png
	cp ports/scummvm_bada_240x400.png    $(SCUMMVM_PATH)/dists/bada/icons/splash2.png

# GCW0
	cp scummvm_icon_32.png               $(SCUMMVM_PATH)/dists/gcw0/scummvm.png

# GPH
	cp scummvm_icon_32.png               $(SCUMMVM_PATH)/dists/gph/scummvm.png
	cp ports/scummvm_icon_gph.png        $(SCUMMVM_PATH)/dists/gph/scummvmb.png

# DC
	cp ports/scummvm_icon_dc.h           $(SCUMMVM_PATH)/backends/platform/dc/deficon.h

# 3ds
	cp ports/scummvm_banner_3ds.png      $(SCUMMVM_PATH)/backends/platform/3ds/app/banner.png
	cp ports/scummvm_icon_3ds.png        $(SCUMMVM_PATH)/backends/platform/3ds/app/icon.png

# PSP
	cp ports/scummvm_logo_psp.png        $(SCUMMVM_PATH)/backends/platform/psp/icon0.png

# Dingux
	cp scummvm_icon_32.png               $(SCUMMVM_PATH)/backends/platform/dingux/scummvm.png

# DS
	cp ports/scummvm_banner_ds.png       $(SCUMMVM_PATH)/backends/platform/ds/gfx/banner.png
	cp ports/scummvm_icon_ds.bmp         $(SCUMMVM_PATH)/backends/platform/ds/logo.bmp
	cp ports/scummvm_icon_ds_A.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logoa.bmp
	cp ports/scummvm_icon_ds_B.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logob.bmp
	cp ports/scummvm_icon_ds_C.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logoc.bmp
	cp ports/scummvm_icon_ds_D.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logod.bmp
	cp ports/scummvm_icon_ds_E.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logoe.bmp
	cp ports/scummvm_icon_ds_F.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logof.bmp
	cp ports/scummvm_icon_ds_G.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logog.bmp
	cp ports/scummvm_icon_ds_H.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logoh.bmp
	cp ports/scummvm_icon_ds_I.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logoi.bmp
	cp ports/scummvm_icon_ds_J.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logoj.bmp
	cp ports/scummvm_icon_ds_K.bmp       $(SCUMMVM_PATH)/backends/platform/ds/logok.bmp

# Symbian
	cp ports/scummvm_icon_symbian16.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/ScummS.bmp
	cp ports/scummvm_icon_symbian16m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummSm.bmp
	cp ports/scummvm_icon_symbian18.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/ScummSmall.bmp
	cp ports/scummvm_icon_symbian18m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummSmallMask.bmp
	cp ports/scummvm_icon_symbian32.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/scummL.bmp
	cp ports/scummvm_icon_symbian32m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummLm.bmp
	cp ports/scummvm_icon_symbian40.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/scummLarge.bmp
	cp ports/scummvm_icon_symbian40m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummLargeMask.bmp
	cp ports/scummvm_icon_symbian64.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/scummxLarge.bmp
	cp ports/scummvm_icon_symbian64m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummxLargeMask.bmp

# WinCE
	cp ports/scummvm_wince_bar.bmp       $(SCUMMVM_PATH)/backends/platform/wince/images/panelbig.bmp
	cp scummvm_icon_32.ico               $(SCUMMVM_PATH)/backends/platform/wince/images/scumm_icon.ico

# iOS 7
	cp ports/scummvm_iphone_icon_40.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-20@2x.png
	cp ports/scummvm_iphone_icon_60.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-20@3x.png
	cp ports/scummvm_iphone_icon_58.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-29@2x.png
	cp ports/scummvm_iphone_icon_87.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-29@3x.png
	cp ports/scummvm_iphone_icon_76.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-38@2x.png
	cp ports/scummvm_iphone_icon_114.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-38@3x.png
	cp ports/scummvm_iphone_icon_80.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-40@2x.png
	cp ports/scummvm_iphone_icon_120.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-40@3x.png
	cp ports/scummvm_iphone_icon_120.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-60@2x.png
	cp ports/scummvm_iphone_icon_180.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-60@3x.png
	cp ports/scummvm_iphone_icon_128.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-64@2x.png
	cp ports/scummvm_iphone_icon_192.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-64@3x.png
	cp ports/scummvm_iphone_icon_152.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-76@2x.png
	cp ports/scummvm_iphone_icon_167.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-83.5@2x.png
	cp ports/scummvm_iphone_icon_136.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-136.png
	cp ports/scummvm_iphone_icon_1024.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-1024.png
	cp ports/scummvm_iphone_dark_icon_40.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-20@2x.png
	cp ports/scummvm_iphone_dark_icon_60.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-20@3x.png
	cp ports/scummvm_iphone_dark_icon_58.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-29@2x.png
	cp ports/scummvm_iphone_dark_icon_87.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-29@3x.png
	cp ports/scummvm_iphone_dark_icon_76.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-38@2x.png
	cp ports/scummvm_iphone_dark_icon_114.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-38@3x.png
	cp ports/scummvm_iphone_dark_icon_80.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-40@2x.png
	cp ports/scummvm_iphone_dark_icon_120.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-40@3x.png
	cp ports/scummvm_iphone_dark_icon_120.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-60@2x.png
	cp ports/scummvm_iphone_dark_icon_180.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-60@3x.png
	cp ports/scummvm_iphone_dark_icon_128.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-64@2x.png
	cp ports/scummvm_iphone_dark_icon_192.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-64@3x.png
	cp ports/scummvm_iphone_dark_icon_152.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-76@2x.png
	cp ports/scummvm_iphone_dark_icon_167.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-83.5@2x.png
	cp ports/scummvm_iphone_dark_icon_136.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-136.png
	cp ports/scummvm_iphone_dark_icon_1024.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-dark-1024.png
	cp ports/scummvm_iphone_tinted_icon_40.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-20@2x.png
	cp ports/scummvm_iphone_tinted_icon_60.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-20@3x.png
	cp ports/scummvm_iphone_tinted_icon_58.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-29@2x.png
	cp ports/scummvm_iphone_tinted_icon_87.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-29@3x.png
	cp ports/scummvm_iphone_tinted_icon_76.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-38@2x.png
	cp ports/scummvm_iphone_tinted_icon_114.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-38@3x.png
	cp ports/scummvm_iphone_tinted_icon_80.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-40@2x.png
	cp ports/scummvm_iphone_tinted_icon_120.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-40@3x.png
	cp ports/scummvm_iphone_tinted_icon_120.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-60@2x.png
	cp ports/scummvm_iphone_tinted_icon_180.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-60@3x.png
	cp ports/scummvm_iphone_tinted_icon_128.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-64@2x.png
	cp ports/scummvm_iphone_tinted_icon_192.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-64@3x.png
	cp ports/scummvm_iphone_tinted_icon_152.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-76@2x.png
	cp ports/scummvm_iphone_tinted_icon_167.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-83.5@2x.png
	cp ports/scummvm_iphone_tinted_icon_136.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-136.png
	cp ports/scummvm_iphone_tinted_icon_1024.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/AppIcon.appiconset/icon4-tinted-1024.png
	cp ports/scummvm_ios7_640x1136.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-640x1136-1.png
	cp ports/scummvm_ios7_750x1334.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-750x1334.png
	cp ports/scummvm_ios7_768x1024.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-768x1024.png
	cp ports/scummvm_ios7_828x1792.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-828x1792.png
	cp ports/scummvm_ios7_1024x768.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1024x768.png
	cp ports/scummvm_ios7_1125x2436.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1125x2436.png
	cp ports/scummvm_ios7_1242x2208.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1242x2208.png
	cp ports/scummvm_ios7_1242x2688.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1242x2688.png
	cp ports/scummvm_ios7_1536x2048.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1536x2048.png
	cp ports/scummvm_ios7_1792x828.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1792x828.png
	cp ports/scummvm_ios7_2048x1536.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2048x1536.png
	cp ports/scummvm_ios7_2208x1242.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2208x1242.png
	cp ports/scummvm_ios7_2436x1125.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2436x1125.png
	cp ports/scummvm_ios7_2688x1242.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2688x1242.png

# Maemo
	cp ports/scummvm_icon_26.png         $(SCUMMVM_PATH)/dists/maemo/scummvm26.png
	cp ports/scummvm_icon_40.png         $(SCUMMVM_PATH)/dists/maemo/scummvm40.png
	cp ports/scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/maemo/scummvm48.png
	cp scummvm_icon_64.png               $(SCUMMVM_PATH)/dists/maemo/scummvm64.png
	cp ports/scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/maemo/am-icon-48.png
	cp scummvm_icon_512.png              $(SCUMMVM_PATH)/dists/maemo/scummvm.png

# Miyoo Mini
	cp ports/scummvm_icon_74.png         $(SCUMMVM_PATH)/dists/miyoo/scummvm-miyoomini.png

# Moto
	cp ports/scummvm_icon_moto48.png     $(SCUMMVM_PATH)/dists/motoezx/scummvm.png
	cp ports/scummvm_icon_moto32.png     $(SCUMMVM_PATH)/dists/motoezx/scummvm-sm.png
	cp ports/scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/motomagx/mgx/icon.png
	cp ports/scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/motomagx/mpkg/scummvm_usr.png
	cp scummvm_icon_32.png               $(SCUMMVM_PATH)/dists/motomagx/pep/scummvm_big_usr.png
	cp ports/scummvm_icon_18.png         $(SCUMMVM_PATH)/dists/motomagx/pep/scummvm_small_usr.png

# OpenPandora
	cp scummvm_icon_32.png               $(SCUMMVM_PATH)/dists/openpandora/icon/scummvm.png

# OS2
# TODO: What format .ico is this?

# PS3
	cp ports/scummvm_icon_ps3.png        $(SCUMMVM_PATH)/dists/ps3/ICON0.PNG

# PS Vita
# PS Vita icons and livearea images have to be processed with pngquant. Otherwise installation fails.
	pngquant scummvm_icon_128.png --force --output $(SCUMMVM_PATH)/dists/psp2/icon0.png
	pngquant ports/scummvm_bg_vita.png --force --output $(SCUMMVM_PATH)/dists/psp2/bg.png
	pngquant ports/scummvm_startup_vita.png --force --output $(SCUMMVM_PATH)/dists/psp2/startup.png

# Redhat
	cp ports/scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/redhat/scummvm48.png

# Samsung TV
	cp ports/scummvm_icon_304.png        $(SCUMMVM_PATH)/dists/samsungtv/scummvm.png

# WebOS
	cp ports/scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/webos/mojo/icon.png

# Wii
	cp ports/scummvm_logo_wii.png        $(SCUMMVM_PATH)/dists/wii/icon.png

# PC
	cp scummvm_icon.ico                  $(SCUMMVM_PATH)/icons/scummvm.ico
	cp originals/scummvm_icon.svg        $(SCUMMVM_PATH)/icons/scummvm.svg
	cp scummvm_icon.xpm                  $(SCUMMVM_PATH)/icons/scummvm.xpm

# Win32
# TODO: Various installer images

clean:
	rm -f $(PORTS_IMAGES)

clean-all: clean
	rm -f $(REPOSITORY_IMAGES)
	rm -f scummvm_icon.icns
	rm -f scummvm_tools_icon.icns

.PHONY: all clean clean-all update
