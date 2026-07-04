# AX3000T U-Boot 512M Build

用于小米路由器 AX3000T / MT7981 / AN8855，硬件已改 512MB RAM 和 512MB SPI-NAND Flash。

目标：

- 使用 `hanwckf/bl-mt798x` 最新源码快照：`abe158087c80ed1896f2c281e2dae5e43ffbee41`
- 默认构建 `uboot-mtk-20250711` + `atf-20250711`
- 新增板型：`mt7981_ax3000t_an8855_512m`
- RAM：512MB
- 默认大分区：`472m(ubi)`，适配 512MB NAND 启用 NMBM 后约 480MiB 的可用空间
- Flash：补齐 `W25N04KV` 的 ATF/BL2 识别，保留上游已有 `GD5F4GQ4xAYIG` 支持
- 交换芯片：AN8855
- 保留旧版 AX3000T U-Boot 的 `compatible` 顺序，方便从现有 U-Boot 网页升级

## 本地构建

在 WSL/Ubuntu/Debian 的 Linux 文件系统里运行，不要在 `/mnt/c/...` 里构建：

```bash
sudo apt-get update
sudo apt-get install -y git build-essential gcc-aarch64-linux-gnu flex bison libssl-dev device-tree-compiler qemu-user-static python3 bc

git clone https://github.com/rory1005/AX3000T-UBOOT.git
cd AX3000T-UBOOT
bash scripts/build.sh
```

输出会在 `out/`：

- `mt7981_ax3000t_an8855_512m-bl2.bin`
- `mt7981_ax3000t_an8855_512m-fip-fixed-parts-multi-layout.bin`
- `sha256sums.txt`

## GitHub Actions

推送到 `main` 后会自动编译。也可以在 GitHub 页面手动点 `Actions -> Build AX3000T U-Boot -> Run workflow`。

编译产物在 Actions 的 artifact 里下载。

## 默认分区

默认 `mtd_layout_label=default`：

```text
nmbm0:1024k(bl2),256k(Nvram),256k(Bdata),2048k(factory),2048k(fip),256k(crash),256k(crash_log),472m(ubi),256k(KF)
```

同时保留这些可选布局：

- `stock-128m`
- `openwrt-112m`
- `qwrt-112m`

## 重要提醒

这是 bootloader，不是普通系统固件。刷写前请确认串口救砖、原厂分区备份、当前 NAND/NMBM 状态都准备好了。刷错 `bl2` 或 `fip` 可能直接无法启动。

更多刷写注意事项见 [docs/FLASHING.md](docs/FLASHING.md)。
