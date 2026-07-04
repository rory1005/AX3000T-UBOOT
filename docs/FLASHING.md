# Flashing Notes

## Hardware Target

- Device: Xiaomi Router AX3000T
- SoC: MediaTek MT7981
- Switch: AN8855
- RAM: 512MB
- Flash: 512MB SPI-NAND
- Tested target IDs in source:
  - Winbond `W25N04KV` for `W25N04KVZEIR`
  - GigaDevice `GD5F4GQ4xAYIG` for `GD5F4GQ4UAYIG`

## Output Files

The build produces:

- `mt7981_ax3000t_an8855_512m-bl2.bin`
- `mt7981_ax3000t_an8855_512m-fip-fixed-parts-multi-layout.bin`

## Safety Checklist

Before flashing:

1. Back up the original `bl2`, `fip`, `factory`, `Nvram`, `Bdata`, and full NAND if possible.
2. Confirm serial console access works.
3. Confirm the physical Flash chip is really one of the intended 512MB chips.
4. Confirm the current OpenWrt image and DTS match the 512MB partition layout.
5. Keep a known-good recovery method ready.

## Default 512MB Layout

```text
nmbm0:1024k(bl2),256k(Nvram),256k(Bdata),2048k(factory),2048k(fip),256k(crash),256k(crash_log),496m(ubi),256k(KF)
```

The layout intentionally leaves unpartitioned space after `KF`, matching the style of the original 128MB layout and giving NMBM room at the end of the chip.

## Notes

This repository prepares source and build automation. Do not flash artifacts blindly. Bootloader flashing can brick the router if the NAND ID, RAM configuration, partition layout, or write offset is wrong.
