# 刷写注意事项

## 硬件目标

- 设备：Xiaomi Router AX3000T
- SoC: MediaTek MT7981
- 交换芯片：AN8855
- RAM: 512MB
- Flash：512MB SPI-NAND
- 源码里对应的 Flash ID：
  - Winbond `W25N04KV`，对应 `W25N04KVZEIR`
  - GigaDevice `GD5F4GQ4xAYIG`，对应 `GD5F4GQ4UAYIG`

## 输出文件

编译完成后会生成：

- `mt7981_ax3000t_an8855_512m-bl2.bin`
- `mt7981_ax3000t_an8855_512m-fip-fixed-parts-multi-layout.bin`

## 刷写前检查

刷写前请先确认：

1. 已备份原厂 `bl2`、`fip`、`factory`、`Nvram`、`Bdata`，最好也备份完整 NAND。
2. 串口能正常进入和救砖。
3. 实物 Flash 确认是目标 512MB 芯片之一。
4. 当前 OpenWrt 镜像和 DTS 分区布局与 512MB 大分区匹配。
5. 已准备好一套确认可用的恢复方法。

## 默认 512MB 分区

```text
nmbm0:1024k(bl2),256k(Nvram),256k(Bdata),2048k(factory),2048k(fip),256k(crash),256k(crash_log),472m(ubi),256k(KF)
```

512MB NAND 启用 NMBM 后，U-Boot 看到的可用 `nmbm0` 空间约为 480MiB。`472m(ubi)` 给前面的启动分区和末尾 `KF` 留出空间，避免分区越界。

## 提醒

这个仓库提供源码补丁和自动编译流程，不建议直接盲刷产物。NAND ID、RAM 配置、分区布局或写入位置不对，都可能导致路由器无法启动。
