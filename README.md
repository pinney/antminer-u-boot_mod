U-Boot 1.1.4 modification for Antminer S1 & S3
==========
Forked from pepe2k's u-boot_mod @ commit 056fbad307bd67b62e7141f6b5e2ab68752f8972

Supported devices
-----------------

Currently supported devices:

- **Atheros AR9331**:
  - Bitmain Antminer S1 and S3
  - Onion Omega
  - GS-Oolite/Elink EL-M150 module
  - TP-Link TL-WR703N v1
  - TP-Link TL-WR720N v3 (version for Chinese market)
  - TP-Link TL-WR710N v1 (version for European market
  - TP-Link TL-WR740N v4 (and similar, like TL-WR741ND v4)
	The Antminer shipped with hacked code from OpenWrt based on the WR741ND v4 and WR743ND

- **Atheros AR1311 (similar to AR9331)**
  - D-Link DIR-505 H/W ver. A1

I tested this uboot along with OpenWrt trunk firmware on my S1.
Flashing the bootloader is risky.
If you like expensive bricks proceed without caution.

More information about supported devices:

| Model | SoC | FLASH | RAM | U-Boot image | U-Boot env |
|:--- | :--- | ---: | ---: | ---: | ---: |
| [Bitmain Antminer] | AR9331 | 8 MiB | 64 MiB DDR2 | 64 KiB, LZMA | RO |
| [Onion Omega] | AR9331 | 16 MiB | 64 MiB DDR2 | 64 KiB, LZMA | RO |
| [TP-Link TL-WR703N] | AR9331 | 4 MiB | 32 MiB DDR1 | 64 KiB, LZMA | RO |
| [TP-Link TL-WR720N v3] | AR9331 | 4 MiB | 32 MiB DDR1 | 64 KiB, LZMA | RO |
| [TP-Link TL-WR710N v1] | AR9331 | 8 MiB | 32 MiB DDR1 | 64 KiB, LZMA | RO |
| [TP-Link TL-WR740N v4] | AR9331 | 4 MiB | 32 MiB DDR1 | 64 KiB, LZMA | RO |
| GS-Oolite/Elink EL-M150 module | AR9331 | 4/8/16 MiB | 64 MiB DDR2 | 64 KiB, LZMA | RO |
| [D-Link DIR-505 H/W ver. A1] | AR1311 | 8 MiB | 64 MiB DDR2 | 64 KiB, LZMA | RO |

*(LZMA) - U-Boot binary image is compressed with LZMA.*  
*(R/W) - environment exists in separate FLASH block which allows you to save it and keep after power down.*
*(RO) - environment is read only, you can change and add new variables only during runtime.*

Known issues
------------
NONE

Modifications, changes
----------------------

### Web server

The most important change is an inclusion of a web server, based on **[uIP 0.9 TCP/IP stack](http://www.gaisler.com/doc/net/uip-0.9/doc/html/main.html)**. It allows to upgrade **firmware**, **U-Boot** and **ART** (Atheros Radio Test) images, directly from your web browser, without need to access serial console and running a TFTP server. You can find similar firmware recovery mode, also based on uIP 0.9 TCP/IP stack, in **D-Link** routers.

Web server contains 7 pages:

1. index.html (allows to upgrade firmware image, screenshot below)
2. uboot.html (allows to upgrade U-Boot image)
3. art.html (allows to upgrade ART image)
4. flashing.html
5. 404.html
6. fail.html
7. style.css

### Network Console

Second, very useful modification is a network console (it is a part of original U-Boot sources, but none of the manufacturers included it). It allows you to communicate with U-Boot console over the Ethernet, using UDP protocol (default UDP port: 6666, router IP: 192.168.1.1).

Use netcat in Linux:
```
# nc -u -p 6666 192.168.1.1 6666
```

### Other

Moreover:

- Faster boot up
- Unnecessary information from boot up sequence were removed
- FLASH chip is automatically recognized (using JEDEC ID)
- Ethernet MAC is set from FLASH (no more "No valid address in FLASH. Using fixed address")
- Automatic kernel booting can be interrupted using any key
- Press and hold reset button to run:
  - Web server (min. 3 seconds)
  - U-Boot serial console (min. 5 seconds)
  - U-Boot network console (min. 7 seconds)
- Additional commands (in comparison to the default version; availability depends on router model):
  -  httpd
  -  printmac
  -  setmac
  -  printmodel
  -  printpin
  -  startnc
  -  startsc
  -  eraseenv
  -  ping
  -  dhcp
  -  sntp
  -  iminfo
- Overclocking and underclocking possibilities (for now, only routers with AR9331)

### Supported FLASH chips

FLASH type detection may be very useful for people who has exchanged the FLASH chip in their routers. You will not need to recompile U-Boot sources, to have access to overall FLASH space in U-Boot console.

If you use FLASH type which is not listed below, this version of U-Boot will use default size for your router and, in most supported models, updating the ART image will not be available.

Currently supported FLASH types:

**4 MiB**:

- Spansion S25FL032P (4 MiB, JEDEC ID: 01 0215)*
- Atmel AT25DF321 (4 MiB, JEDEC ID: 1F 4700)
- EON EN25Q32 (4 MiB, JEDEC ID: 1C 3016)*
- EON EN25F32 (4 MiB, JEDEC ID: 1C 3116)*
- Micron M25P32 (4 MiB, JEDEC ID: 20 2016)
- Windbond W25Q32 (4 MiB, JEDEC ID: EF 4016)
- Macronix MX25L320 (4 MiB, JEDEC ID: C2 2016)

**8 MiB**:
- GigaDevice GD25Q64B (8 MiB, JEDEC ID:0xc84017)
- Spansion S25FL164K (8 MiB, JEDEC ID:0x014017)
- Spansion S25FL064P (8 MiB, JEDEC ID: 01 0216)
- Atmel AT25DF641 (8 MiB, JEDEC ID: 1F 4800)
- EON EN25Q64 (8 MiB, JEDEC ID: 1C 3017)*
- Micron M25P64 (8 MiB, JEDEC ID: 20 2017)
- Windbond W25Q64 (8 MiB, JEDEC ID: EF 4017)*
- Macronix MX25L64 (8 MiB, JEDEC ID: C2 2017, C2 2617)

**16 MiB**:

- Winbond W25Q128 (16 MB, JEDEC ID: EF 4018)*
- Macronix MX25L128 (16 MB, JEDEC ID: C2 2018, C2 2618)
- Spansion S25FL127S (16 MB, JEDEC ID: 01 2018)*

(*) tested

How to install it?
------------------

### Cautions, backups

**You do so at your own risk!**   
**If you make any mistake or something goes wrong during upgrade, in worst case, your router will not boot again!**

It is a good practice to backup your original U-Boot image/partition **before** you make any changes.
For example, using OpenWrt (TP-Link TL-WR703N with 16 MiB FLASH):

```
cat /proc/mtd
```

This command will show you all **MTD** (Memory Technology Device) partitions:

```
dev:    size   erasesize  name
mtd0: 00020000 00010000 "u-boot"
mtd1: 000eeb70 00010000 "kernel"
mtd2: 00ee1490 00010000 "rootfs"
mtd3: 00c60000 00010000 "rootfs_data"
mtd4: 00010000 00010000 "art"
mtd5: 00fd0000 00010000 "firmware"
```

As you can see, `u-boot` partition size is **0x20000** (128 KiB) and my image for this model has size of **0x10000** (64 KiB) - it is a very important difference! 
You should remember about this if you want to use `mtd` utility, to change U-Boot.

To backup `u-boot` partition in RAM, run:

```
cat /dev/mtd0 > /tmp/uboot_backup.bin
```

And then connect to your router using `SCP protocol` and download from `/tmp` the `uboot_backup.bin` file.

### Using external programmer

If you have an external FLASH programmer (all supported devices have **SPI NOR FLASH** chips), you probably know how to use it. Download package with prebuilt images or compile the code, choose right file for your device and put it on FLASH at the beginning (offset `0x00000`). Remember to first erase block(s) - with high probability, if you use some kind of automatic mode, the programmer will do it for you.

All prebuilt images are padded with 0xFF, so their size will always be a **multiple of 64 KiB block** and they will not be bigger than the original versions. For example, **TP-Link** uses only first **64 KiB** block to store compressed U-Boot image (in most of their modern devices). In the second 64 KiB block they store additional information like MAC address, model number and WPS pin number.

On the other hand, U-Boot image in **Carambola 2** from **8devices** may have up to **256 KiB** (4x 64 KiB block), they use uncompressed version and environment stored in FLASH. Immediately after the Carambola 2 U-Boot partition is an area which contains U-Boot environment variables (1x 64 KiB block), called `u-boot-env`:

```
dev:    size   erasesize  name
mtd0: 00040000 00010000 "u-boot"
mtd1: 00010000 00010000 "u-boot-env"
mtd2: 00f90000 00010000 "firmware"
mtd3: 00e80000 00010000 "rootfs"
mtd4: 00cc0000 00010000 "rootfs_data"
mtd5: 00010000 00010000 "nvram"
mtd6: 00010000 00010000 "art"
```

### Using UART, U-Boot console and TFTP server

It is probably the most common method to change firmware in case of any problems. Main disadvantage of this approach is the need to connect with device using a serial port (this does not apply to Carambola 2 with development board, which already has a built-in USB-UART adapter, based on FTDI FT232RQ).

#### Important notice!

All these devices have an UART interface integrated inside the SoC, which operates at TTL 3.3 V (in fact, GPIO pins can work at this voltage, but their real range is < 3 V)!

Please, **do not** connect any RS232 +/- 12 V cable or any adapter without logic level converter, because it may damage your device. It would be the best if you use any USB to UART adapter with integrated 3.3 V logic level converter. And please, remember that **you should connect only RX, TX and GND signals**. **DO NOT** connect together 3.3 V signals from router and from adapter if you do not know what are you doing, because you may burn out your adapter and/or router! Connect the adapter using USB port in your PC and router with original power supply.

For a long time I have been using without any problems a small and very cheap (about 1-2 USD) **CP2102** based adapter. Go to [Serial Console article in OpenWrt Wiki](http://wiki.openwrt.org/doc/hardware/port.serial) for more, detailed information.

#### Step by step instruction for Linux users.

1. Install and configure a TFTP server 

2. Set a fixed IP address on your PC (in this tutorial we will use **192.168.1.2** for the PC and **192.168.1.1** for the router) and connect it to the router, using RJ45 network cable (in most case you will need to use one of the available LAN ports, but WAN port should also work).

3. Connect USB to UART adapter to the router.

user$ screen /dev/ttyUSB0 115200  

4. Power on the router, wait for a line like one of the following and interrupt the process of loading a kernel:

  `Autobooting in 1 seconds` (for most **TP-Link** routers, you should enter `tpl` at this point)   
  `Hit ESC key to stop autoboot:  1` (for **8devices Carambola 2**, use `ESC` key)   
  `Hit any key to stop autoboot:  1` (for **D-Link DIR-505**, use any key)

5. Set `ipaddr` and `serverip` environment variables:

  ```
  hornet> setenv ipaddr 192.168.1.1
  hornet> setenv serverip 192.168.1.2
  ```
6. Check the changes:

  ```
  hornet> printenv ipaddr
  ipaddr=192.168.1.1
  hornet> printenv serverip
  serverip=192.168.1.2
  ```

7. Download and store in RAM proper image for your router, using `tftpboot` command in U-Boot console (in this example, for **TP-Link TL-MR3020**):

  ```
  tftpboot 0x80800000 uboot_for_tp-link_tl-mr3020.bin

  eth1 link down
  Using eth0 device
  TFTP from server 192.168.1.2; our IP address is 192.168.1.1
  Filename 'uboot_for_tp-link_tl-mr3020.bin'.
  Load address: 0x80800000
  Loading: #############
  done
  Bytes transferred = 65536 (10000 hex)
  hornet>
  ```

8. Next step is very risky! You are going to delete existing U-Boot image from FLASH in your device and copy from RAM the new one. If something goes wrong (for example, a power failure), your router, without bootloader, will not boot again!

  You should also note the size of downloaded image. For supported **TP-Link** and **D-Link** routers it will be always **0x10000** (64 KiB), but for Carambola 2 image size is different: **0x40000** (256 KiB). In all cases, the start address of FLASH is **0x9F000000** and for RAM: **0x80000000** (as you may noticed, I did not use start address of RAM to store image and you should follow this approach).

  Please, do not make any mistake with offsets and sizes during next steps!

9. Erase appropriate FLASH space for new U-Boot image (this command will remove default U-Boot image!):

  ```
  uboot> erase 0x9F000000 +0x10000   

  First 0x0 last 0x0 sector size 0x10000
  0
  Erased 1 sectors
  ```

10. Now your router does not have U-Boot, so do not wait and copy to FLASH the new one, stored earlier in RAM:

  ```
  uboot> cp.b 0x80800000 0x9F000000 0x10000   

  Copy to Flash... write addr: 9f000000
  done
  ```

11. If you want, you can check content of the newly written FLASH and compare it to the image on your PC (or better also do such a "legit memory content" comparison prior to writing!), using `md` command in U-Boot console, which prints indicated memory area (press only ENTER after first execution of this command to move further in memory):

  ```
  uboot> md 0x9F000000

9F000000: 100000FF 00000000 100000FD 00000000    ................
9F000010: 1000018E 00000000 1000018C 00000000    ................
9F000020: 1000018A 00000000 10000188 00000000    ................
9F000030: 10000186 00000000 10000184 00000000    ................
9F000040: 10000182 00000000 10000180 00000000    ................
9F000050: 1000017E 00000000 1000017C 00000000    ...~.......|....
9F000060: 1000017A 00000000 10000178 00000000    ...z.......x....
9F000070: 10000176 00000000 10000174 00000000    ...v.......t....
9F000080: 10000172 00000000 10000170 00000000    ...r.......p....
9F000090: 1000016E 00000000 1000016C 00000000    ...n.......l....
9F0000A0: 1000016A 00000000 10000168 00000000    ...j.......h....
9F0000B0: 10000166 00000000 10000164 00000000    ...f.......d....
9F0000C0: 10000162 00000000 10000160 00000000    ...b.......`....
9F0000D0: 1000015E 00000000 1000015C 00000000    ...^.......\....
9F0000E0: 1000015A 00000000 10000158 00000000    ...Z.......X....
9F0000F0: 10000156 00000000 10000154 00000000    ...V.......T....

  ```

12. If you are sure that everything went OK, you may reset the board:

  ```
  uboot> reset
  ```

### Using OpenWrt

1. Compile and flash OpenWrt with an unlocked U-Boot partition.
  - This is done by removing the `MTD_WRITEABLE` from the `mask_flags` of the `u-boot` partition.
  - To put it simply, for TP-Link products, just remove [this line](https://dev.openwrt.org/browser/trunk/target/linux/ar71xx/files/drivers/mtd/tplinkpart.c?rev=41580#L152), compile and flash the image as usual. 
2. Find out which mtd partition is the `u-boot` partition:

  ```
  root@OpenWrt:/tmp/uboot-work# cat /proc/mtd
  dev:    size   erasesize  name
  mtd0: 00020000 00010000 "u-boot"
  mtd1: 000feba0 00010000 "kernel"
  mtd2: 002d1460 00010000 "rootfs"
  mtd3: 00100000 00010000 "rootfs_data"
  mtd4: 00010000 00010000 "art"
  mtd5: 003d0000 00010000 "firmware"
  ```

3. Transfer the new U-Boot image to the device:

  ```
  me@laptop:~# scp uboot_for_antminer.bin root@192.168.1.1:/tmp/
  uboot_for_antminer.bin            100%   64KB  64.0KB/s   00:00
  ```

4. Verify the MD5 sum of the image:

  ```
  me@laptop:~# md5sum uboot_for_antminer.bin
  cefad12aa9fbd04291652dae3eb7650c  uboot_for_antminer.bin

  root@OpenWrt:/tmp# md5sum uboot_for_tp-link_antminer.bin
  cefad12aa9fbd04291652dae3eb7650c  uboot_for_antminer.bin
  ```

5. Take a backup of the current u-boot partition (`mtd0`):

  ```
  root@OpenWrt:/tmp# dd if=/dev/mtd0 of=uboot_orig.bin
  256+0 records in
  256+0 records out
  ```

6. Transfer the backup off the device and to a safe place:

  ```
  me@laptop:~# scp root@192.168.1.1:/tmp/uboot_orig.bin .
  uboot_orig.bin                                100%  128KB 128.0KB/s   00:00
  ```

7. **Beware**: This step may differ for other devices. I'm using TP-Link TL-MR3220v2 and it uses the first 64 KiB block to store compressed U-Boot image. In the second 64 KiB block they store additional information like MAC address, model number and WPS pin number. This means the old backup is bigger than the new one we're going to flash. To store the old settings we're going to modify only the compressed U-Boot image and leave the additional information intact. To do that, take a copy of the original file, and copy the new image over it without truncating the leftover bytes:

  ```
  root@OpenWrt:/tmp# cp uboot_orig.bin uboot_new.bin
  root@OpenWrt:/tmp# dd if=uboot_for_tp-link_tl-mr3220_v2.bin of=uboot_new.bin conv=notrunc
  128+0 records in
  128+0 records out
  ```

9. **Danger**: This is the point of no return, if you have any errors or problems, please revert the original image at any time using:

  ```
  root@OpenWrt:/tmp# mtd write uboot_orig.bin "u-boot"
  Unlocking u-boot ...

  Writing from uboot_orig.bin to u-boot ...
  ```

10. Now, to actually flash the new image, run:

  ```
  root@OpenWrt:/tmp# mtd write uboot_new.bin "u-boot"
  Unlocking u-boot ...

  Writing from uboot_new.bin to u-boot ...
  ```

11. To verify that the image was flashed correctly, you should verify it:

  ```
  root@OpenWrt:/tmp# mtd verify uboot_new.bin "u-boot"
  Verifying u-boot against uboot_new.bin ...
  a80c3a8683345a3fb311555c5d4194c5 - u-boot
  a80c3a8683345a3fb311555c5d4194c5 - uboot_new.bin
  Success
  ```

12. To restart with the new bootloader, reboot the router:

  ```
  root@OpenWrt:/tmp# reboot
  ```

How to compile the code?
------------------------

To build image, run `make model` inside top dir, for example, command:

```
make antminer
```

will start building U-Boot image for the Bitmain Antminer.

FAQ
---

#### 1. My device is not supported, but has the same hardware as one in the list, can I use this modification?

*It could be dangerous! I know that a lot of routers uses the same hardware - for example, TP-Link has a battery powered routers set, which contains: TL-MR10U, TL-MR11U (TL-MR3040 in Europe) TL-MR12U and TL-MR13U. All of them has the same platform: Atheros AR9331 with 32 MiB of DDR RAM and 4 MiB of SPI NOR FLASH. But, there may exist a slight difference, like GPIO pin number for reset button or LED(s), that may cause problems.*

*You can try, but remember that you are doing this only at your own risk!*

#### 2. I want to overclock my router, how can I do this?

*Currently, this option is available only for routers with Atheros AR9331 (please, look at [ap121.h](u-boot/include/configs/ap121.h) file which contains all information about PLL register configuration and an untypical clocks for CPU, RAM and AHB). What more, you will need to compile the code yourself, because I will not publish images with non-default clocks.*

*And again, remember that you are doing this only at your own risk!*

#### 3. Do you test all prebuilt images before you publish them?

*No, because I do not have all supported devices, only few of them. But, I make tests for every supported SoC types.*

#### 4. I would like you to add support for device X.

*You can do it yourself and send me a pull request or a patch. If you do not want to, or do not know how to do it, please contact with me directly.*

#### 5. My device does not boot after upgrade!

*I told you... bootloader, in this case U-Boot, is the most important piece of code inside your device. It is responsible for hardware initialization and booting an OS (kernel in this case), i.e. it's the bridge head for delegating to / flashing kernel and rootfs images. So, if during the upgrade something went wrong, your device will not boot any more. The only way to recover from such a situation in a mild way is via a JTAG adapter connection. In case of a lack of JTAG connection, you would even need to remove the FLASH chip, load proper image using an external programmer and solder it back.*

License, outdated sources etc.
------------------------------

**[U-Boot](http://www.denx.de/wiki/U-Boot/WebHome "U-Boot")** project is Free Software, licensed under version 2 of the **GNU General Public License**. All information about license, contributors etc., are included with sources, inside *u-boot* folder.

You should know, that most routers, especially those based on Atheros SoCs, uses very old versions of U-Boot (1.1.4 is from 2005/2006). So, *these sources are definitely outdated* (do not even try to merge them with official release), but it was easier for me to modify them, than move TP-Link/Atheros changes to the current version. Moreover, lot of unnecessary code fragments and source files were removed for ease of understanding the code.

Credits
-------
I stand upon the shoulders of giants.

https://www.fsf.org/

https://kernel.org/

http://www.denx.de/wiki/U-Boot/

https://openwrt.org/
