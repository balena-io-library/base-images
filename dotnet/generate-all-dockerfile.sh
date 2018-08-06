#!/bin/bash
set -e

out_dir=.

devices='raspberry-pi raspberry-pi2 raspberrypi3 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6'
variants='sdk runtime aspnetcore'
bases='debian'

OPTIND=1
while getopts "o:" opt; do
  case "$opt" in
    o)
      out_dir="$OPTARG"
      ;;
  esac
done
shift $((OPTIND-1))

for device in $devices; do
	case "$device" in
	'raspberry-pi')
		binary_arch='armv6hf'
	;;
	'raspberry-pi2' | 'raspberrypi3')
		binary_arch='armv7hf'
	;;
	'beaglebone')
		binary_arch='armv7hf'
	;;
	'edison')
		binary_arch='x86'
	;;
	'nuc')
		binary_arch='x64'
	;;
	'vab820-quad')
		binary_arch='armv7hf'
	;;
	'zc702-zynq7')
		binary_arch='armv7hf'
	;;
	'odroid-c1')
		binary_arch='armv7hf'
	;;
	'odroid-ux3')
		binary_arch='armv7hf'
	;;
	'parallella-hdmi-resin')
		binary_arch='armv7hf'
	;;
	'nitrogen6x')
		binary_arch='armv7hf'
	;;
	'cubox-i')
		binary_arch='armv7hf'
	;;
	'ts4900')
		binary_arch='armv7hf'
	;;
	'colibri-imx6')
		binary_arch='armv7hf'
	;;
	'apalis-imx6')
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
      echo "Unsupported arch '$binary_arch'! Skipping device '$device'..."
      continue
    ;;
  esac

  for base in $bases; do

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
          bundle="https://download.microsoft.com/download/1/f/7/1f7755c5-934d-4638-b89f-1f4ffa5afe89/aspnetcore-runtime-2.1.2-linux-$dotnet_arch.tar.gz"
          version='2.1.2'
        ;;
      esac

      dockerfilePath=$out_dir/$device/$base/$variant-$version
      mkdir -p $dockerfilePath
      sed -e s~#{FROM}~resin/$device-$base:jessie~g \
        -e s~#{DOTNET_BUNDLE}~$bundle~g Dockerfile.tpl > $dockerfilePath/Dockerfile

    done
  done
done
