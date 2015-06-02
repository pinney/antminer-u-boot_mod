export BUILD_TOPDIR=$(PWD)
export STAGING_DIR=$(BUILD_TOPDIR)/tmp

export MAKECMD=make ARCH=mips CROSS_COMPILE=mips-openwrt-linux-uclibc-
export PATH:=$(BUILD_TOPDIR)/toolchain/bin/:$(PATH)

# boot delay (time to autostart boot command)
export CONFIG_BOOTDELAY=2

# uncomment following line, to disable output in U-Boot console
#export DISABLE_CONSOLE_OUTPUT=1

# uncomment following line, to build RAM version images (without low level initialization)
#export CONFIG_SKIP_LOWLEVEL_INIT=1

antminer:	export UBOOT_FILE_NAME=uboot_for_antminer
antminer:	export CONFIG_MAX_UBOOT_SIZE_KB=64
ifndef CONFIG_SKIP_LOWLEVEL_INIT
antminer:	export COMPRESSED_UBOOT=1
endif
antminer:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) antminer_config
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	@make --no-print-directory show_size

tplink_wr703n:	export UBOOT_FILE_NAME=uboot_for_tp-link_tl-wr703n
tplink_wr703n:	export CONFIG_MAX_UBOOT_SIZE_KB=64
ifndef CONFIG_SKIP_LOWLEVEL_INIT
tplink_wr703n:	export COMPRESSED_UBOOT=1
endif
tplink_wr703n:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) wr703n_config
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	@make --no-print-directory show_size

tplink_wr720n_v3_CH:	export UBOOT_FILE_NAME=uboot_for_tp-link_tl-wr720n_v3_CH
tplink_wr720n_v3_CH:	export CONFIG_MAX_UBOOT_SIZE_KB=64
ifndef CONFIG_SKIP_LOWLEVEL_INIT
tplink_wr720n_v3_CH:	export COMPRESSED_UBOOT=1
endif
tplink_wr720n_v3_CH:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) wr720n_v3_CH_config
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	@make --no-print-directory show_size

tplink_wr710n:	export UBOOT_FILE_NAME=uboot_for_tp-link_tl-wr710n
tplink_wr710n:	export CONFIG_MAX_UBOOT_SIZE_KB=64
ifndef CONFIG_SKIP_LOWLEVEL_INIT
tplink_wr710n:	export COMPRESSED_UBOOT=1
endif
tplink_wr710n:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) wr710n_config
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	@make --no-print-directory show_size

tplink_wr740n_v4:	export UBOOT_FILE_NAME=uboot_for_tp-link_tl-wr740n_v4
tplink_wr740n_v4:	export CONFIG_MAX_UBOOT_SIZE_KB=64
ifndef CONFIG_SKIP_LOWLEVEL_INIT
tplink_wr740n_v4:	export COMPRESSED_UBOOT=1
endif
tplink_wr740n_v4:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) wr740n_v4_config
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	@make --no-print-directory show_size

dlink_dir505:	export UBOOT_FILE_NAME=uboot_for_d-link_dir-505
dlink_dir505:	export CONFIG_MAX_UBOOT_SIZE_KB=64
ifndef CONFIG_SKIP_LOWLEVEL_INIT
dlink_dir505:	export COMPRESSED_UBOOT=1
endif
dlink_dir505:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) dir505_config
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	@make --no-print-directory show_size

gs-oolite_v1_dev:	export UBOOT_FILE_NAME=uboot_for_gs-oolite_v1_dev
gs-oolite_v1_dev:	export CONFIG_MAX_UBOOT_SIZE_KB=64
ifndef CONFIG_SKIP_LOWLEVEL_INIT
gs-oolite_v1_dev:	export COMPRESSED_UBOOT=1
endif
gs-oolite_v1_dev:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) gs_oolite_v1_dev_config
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	@make --no-print-directory show_size

ifdef CONFIG_SKIP_LOWLEVEL_INIT
  ifdef DISABLE_CONSOLE_OUTPUT
show_size:	export UBOOT_FILE_NAME_SUFFIX=__SILENT-CONSOLE__RAM
  else
show_size:	export UBOOT_FILE_NAME_SUFFIX=__RAM
  endif
else
  ifdef DISABLE_CONSOLE_OUTPUT
show_size:	export UBOOT_FILE_NAME_SUFFIX=__SILENT-CONSOLE
  endif
endif
show_size:
ifdef COMPRESSED_UBOOT
	@cp $(BUILD_TOPDIR)/u-boot/tuboot.bin $(BUILD_TOPDIR)/bin/temp.bin
else
	@cp $(BUILD_TOPDIR)/u-boot/u-boot.bin $(BUILD_TOPDIR)/bin/temp.bin
endif
	@/bin/echo -ne "\e[32m"
ifndef CONFIG_SKIP_LOWLEVEL_INIT
	@echo "> Preparing $(CONFIG_MAX_UBOOT_SIZE_KB)KB file filled with 0xFF..."
	@`tr "\000" "\377" < /dev/zero | dd ibs=1k count=$(CONFIG_MAX_UBOOT_SIZE_KB) of=$(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).bin 2> /dev/null`
	@echo "> Copying U-Boot image..."
	@`dd if=$(BUILD_TOPDIR)/bin/temp.bin of=$(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).bin conv=notrunc 2> /dev/null`
	@`rm $(BUILD_TOPDIR)/bin/temp.bin`
else
	@echo "> Copying U-Boot image..."
	@`mv $(BUILD_TOPDIR)/bin/temp.bin $(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).bin`
endif
	@echo "> U-Boot image ready, size:" `wc -c < $(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).bin`" bytes"
	@`md5sum $(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).bin | awk '{print $$1}' | tr -d '\n' > $(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).md5`
	@`echo ' *'$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).bin >> $(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).md5`
# Do not check image size for RAM version
ifndef CONFIG_SKIP_LOWLEVEL_INIT
	@if [ "`wc -c < $(BUILD_TOPDIR)/bin/$(UBOOT_FILE_NAME)$(UBOOT_FILE_NAME_SUFFIX).bin`" -gt "`/bin/echo '$(CONFIG_MAX_UBOOT_SIZE_KB)*1024' | bc`" ]; then \
			/bin/echo -e "\e[31m\n**************************************************"; \
			/bin/echo "*     WARNING: U-BOOT IMAGE SIZE IS TOO BIG!     *"; \
			/bin/echo -e "**************************************************"; \
	fi;
endif
	@/bin/echo -ne "\e[0m"

clean:
	@cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) --no-print-directory distclean
	@rm -f $(BUILD_TOPDIR)/u-boot/httpd/fsdata.c

clean_all:	clean
	@/bin/echo -e "\e[32m> Removing all binary images...\e[0m"
	@rm -f $(BUILD_TOPDIR)/bin/*.bin
	@rm -f $(BUILD_TOPDIR)/bin/*.md5
