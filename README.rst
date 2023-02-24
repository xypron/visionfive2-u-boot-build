Build U-Boot for VisionFive2 board
==================================

Here I add some patches I missed in the vendor's U-Boot.

Build dependencies
------------------

On Ubuntu the following packages are required:

.. code-block:: bash

    sudo apt-get install bison build-essential flex libssl-dev

Building
--------

.. code-block:: bash

    make clean
    make

Installing on SPI flash
-----------------------

Updating U-Boot is described in
https://doc-en.rvspace.org/VisionFive2/PDF/VisionFive2_QSG.pdf,
chapter 4.3. "Updating SPL and U-Boot".

Firmware images built by StarFive are available at
https://github.com/starfive-tech/VisionFive2/releases/ and called

* u-boot-spl.bin.normal.out - U-Boot SPL
* visionfive2_fw_payload.img - OpenSBI and main U-Boot

Copy the files to the SD-card. In U-Boot execute:

.. code-block:: bash

   sf probe
   load mmc 1:f $kernel_addr_r fw/u-boot-spl.bin.normal.out
   sf update $kernel_addr_r 0 $filesize
   load mmc 1:f $kernel_addr_r fw/visionfive2_fw_payload.img
   sf update $kernel_addr_r 0x100000 $filesize

Installing on SD-card
---------------------

The SD-card must be GPT partitioned.

* copy visionfive2_fw_payload.img to partion 2
* copy u-boot-spl.bin.normal.out to a partition with partion type GUID
  2E54B353-1271-4842-806F-E436D6AF6985

License
-------

GPLv2, see `COPYING <./COPYING>`_
