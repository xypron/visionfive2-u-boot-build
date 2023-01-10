Build U-Boot for VisionFive2 board
==================================

Here I add some patches I missed in the vendor's U-Boot.

Building
--------

.. code-block:: bash

    make clean
    make

Installing U-Boot on SPI flash
------------------------------

Updating U-Boot is described in
https://doc-en.rvspace.org/VisionFive2/PDF/VisionFive2_QSG.pdf,
chapter 4.3. "Updating SPL and U-Boot".

Firmware images are available at
https://github.com/starfive-tech/VisionFive2/releases/ and called

* u-boot-spl.bin.normal.out
* visionfive2_fw_payload.img - main U-Boot

Copy the files to the SD-card. In U-Boot execute:

.. code-block:: bash

   load mmc 1:f $kernel_addr_r fw/u-boot-spl.bin.normal.out
   sf update $kernel_addr_r 0 $filesize
   load mmc 1:f $kernel_addr_r fw/visionfive2_fw_payload.img
   sf update $kernel_addr_r 0x100000 $filesize

License
-------

GPLv2, see `COPYING <./COPYING>`_
