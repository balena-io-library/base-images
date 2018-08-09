#!/bin/bash
set -e

out_dir=.

# List of devices
targets='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart kitra520 jetson-tx2 jetson-tx1 iot2000 generic-aarch64 generic-armv7ahf bananapi-m1-plus orangepi-plus2 fincm3 artik533s artik530 orbitty-tx2 spacely-tx2'
# List of archs
targets+=' armv7hf armel i386 amd64 aarch64'
variants='sdk runtime aspnetcore'
bases='debian:jessie alpine:3.7'

OPTIND=1
while getopts "o:" opt; do
  case "$opt" in
    o)
      out_dir="$OPTARG"
      ;;
  esac
done
shift $((OPTIND-1))

for target in $targets; do
	case "$target" in
    'raspberry-pi'|'armel')
      binary_arch='armv6hf'
    ;;
    'intel-edison'|'qemux86'|'i386')
      binary_arch='x86'
    ;;
    'intel-nuc'|'qemux86-64'|'amd64')
      binary_arch='x64'
    ;;
    'generic-aarch64'|'aarch64')
      binary_arch='aarch64'
    ;;
    *)
      binary_arch='armv7hf'
    ;;
	esac

  case "$binary_arch" in
    'armv6hf'|'armv7hf')
      dotnet_arch='arm'
    ;;
    'x64')
      dotnet_arch='x64'
    ;;
    'aarch64')
      dotnet_arch='arm64'
    ;;
    *)
      echo "Unsupported arch '$binary_arch'! Skipping device '$target'..."
      continue
    ;;
  esac

  for base in $bases; do

    IFS=: read -r base_image base_image_label <<< "$base"

    case $dotnet_arch in
        'arm'|'arm64')
          crossbuild=''
          ;;
        *)
          crossbuild='# '
          case $base_image in
            'alpine')
              dotnet_arch='musl-x64'
          esac
          ;;
      esac

    for variant in $variants; do
      case "$variant" in
        'sdk')
          bundle="https://download.microsoft.com/download/4/0/9/40920432-3302-47a8-b13c-bbc4848ad114/dotnet-sdk-2.1.302-linux-$dotnet_arch.tar.gz"
          version='2.1.302'
        ;;
        'runtime')
          bundle="https://download.microsoft.com/download/1/f/7/1f7755c5-934d-4638-b89f-1f4ffa5afe89/dotnet-runtime-2.1.2-linux-$dotnet_arch.tar.gz"
          version='2.1.2'
        ;;
        'aspnetcore')
          case "$dotnet_arch" in
            'arm64')
              dotnet_arch='arm'
              ;;
          esac
          bundle="https://download.microsoft.com/download/1/f/7/1f7755c5-934d-4638-b89f-1f4ffa5afe89/aspnetcore-runtime-2.1.2-linux-$dotnet_arch.tar.gz"
          version='2.1.2'
        ;;
      esac

      bundle_basename=$(basename $bundle)
      sha256sum=$(cat ./SHA256SUMS | grep -i $bundle_basename)

      dockerfilePath=$out_dir/$target/$base_image/$version/$variant
      mkdir -p $dockerfilePath

      sed "s~#{FROM}~resin/$target-$base_image:$base_image_label~g; s~#{DOTNET_BUNDLE}~$bundle~g; s~#{DOTNET_BUNDLE_BASENAME}~$bundle_basename~g; s~#{DOTNET_BUNDLE_SHA256SUM}~$sha256sum~g; s~#{ARCH=ARM}~$crossbuild~g" Dockerfile.$base_image.tpl > $dockerfilePath/Dockerfile

    done
  done
done
