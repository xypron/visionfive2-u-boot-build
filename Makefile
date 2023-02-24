# Build U-Boot for StarFive VisionFive 2
.POSIX:

TAG=VF2_v2.8.0
NPROC=${shell nproc}

MK_ARCH="${shell uname -m}"
ifeq ("riscv64", $(MK_ARCH))
	undefine CROSS_COMPILE
else
	export CROSS_COMPILE=riscv64-linux-gnu-
endif
undefine MK_ARCH

all:
	make visionfive2_fw_payload.img
	make u-boot-spl.bin.normal.out

opensbi:
	git clone -v https://github.com/starfive-tech/opensbi.git

u-boot:
	git clone -v https://github.com/starfive-tech/u-boot.git

u-boot.bin: u-boot
	cd u-boot && git fetch origin
	cd u-boot && git checkout JH7110_VisionFive2_devel
	cd u-boot && git reset --hard $(TAG)
	cd u-boot && ../patch/series
	cd u-boot && make mrproper
	cp config/config_$(TAG) u-boot/.config
	echo $(CROSS_COMPILE)
	cd u-boot && make -j $(NPROC)
	cp u-boot/u-boot.bin .

fw_payload.bin: opensbi u-boot.bin
	cd opensbi && git fetch origin
	cd opensbi && git checkout JH7110_VisionFive2_devel
	cd opensbi && git reset --hard $(TAG)
	cd opensbi && rm -rf build/
	cd opensbi && make -j $(NPROC) \
	  PLATFORM=generic \
	  FW_PAYLOAD_PATH=../u-boot.bin \
	  FW_FDT_PATH=../u-boot/arch/riscv/dts/starfive_visionfive2.dtb \
	  FW_TEXT_START=0x40000000
	cp opensbi/build/platform/generic/firmware/fw_payload.bin .

visionfive2_fw_payload.img: fw_payload.bin
	mkimage -f visionfive2-uboot-fit-image.its \
	  -A riscv -O linux -T flat_dt \
	  visionfive2_fw_payload.img

u-boot-spl.bin.normal.out: u-boot.bin
	spl_tool -c -f u-boot/spl/u-boot-spl.bin
	mv u-boot/spl/u-boot-spl.bin.normal.out .

clean:
	rm -f visionfive2_fw_payload.img fw_payload.bin u-boot.bin
