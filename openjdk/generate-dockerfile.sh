#!/bin/bash
set -e

declare -A debianSuites=(
	[6]='wheezy'
	[7]='jessie'
	[8]='jessie'
	[9]='sid'
)

declare -A debianAddSuites=(
	[8]='jessie-backports'
	[9]='experimental'
)

declare -A variants=(
	[jre]='curl'
	[jdk]='scm'
)

declare -A debCache=()

versions='7-jdk 7-jre 8-jdk 8-jre'
devices='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart ccon-01'
fedora_devices=' raspberry-pi2 beaglebone-black via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 up-board imx6ul-var-dart ccon-01 '
alpineVersion='3.6'
alpineDeviceArchs='x86_64 x86 armhf'
variants='jre jdk'

for arch in $alpineDeviceArchs; do
	curl -fsSL'#' "http://dl-cdn.alpinelinux.org/alpine/v$alpineVersion/community/$arch/APKINDEX.tar.gz" | tar -zxv APKINDEX
	case "$arch" in
	'armhf')
		mv APKINDEX APKINDEX.armhf
	;;
	'x86')
		mv APKINDEX APKINDEX.i386
	;;
	'x86_64')
		mv APKINDEX APKINDEX.amd64
	;;
	esac

done

for device in $devices; do
	for version in $versions; do
		case "$device" in
		'raspberry-pi')
			deviceArch='armhf'
		;;
		'raspberry-pi2')
			deviceArch='armhf'
		;;
		'raspberrypi3')
			deviceArch='armhf'
		;;
		'beaglebone-black')
			deviceArch='armhf'
		;;
		'beaglebone-green-wifi')
			deviceArch='armhf'
		;;
		'beaglebone-green')
			deviceArch='armhf'
		;;
		'intel-edison')
			deviceArch='i386'
		;;
		'qemux86')
			deviceArch='i386'
		;;
		'cybertan-ze250')
			deviceArch='i386'
		;;
		'intel-nuc')
			deviceArch='amd64'
		;;
		'qemux86-64')
			deviceArch='amd64'
		;;
		'up-board')
			deviceArch='amd64'
		;;
		'via-vab820-quad')
			deviceArch='armhf'
		;;
		'zynq-xz702')
			deviceArch='armhf'
		;;
		'odroid-c1')
			deviceArch='armhf'
		;;
		'odroid-xu4')
			deviceArch='armhf'
		;;
		'parallella')
			deviceArch='armhf'
		;;
		'nitrogen6x')
			deviceArch='armhf'
		;;
		'hummingboard')
			deviceArch='armhf'
		;;
		'ts4900')
			deviceArch='armhf'
		;;
		'colibri-imx6dl')
			deviceArch='armhf'
		;;
		'apalis-imx6q')
			deviceArch='armhf'
		;;
		'am571x-evm')
			deviceArch='armhf'
		;;
		'ts7700')
			deviceArch="armel"
		;;
		'artik5')
			deviceArch='armhf'
		;;
		'artik10')
			deviceArch='armhf'
		;;
		'artik710')
			deviceArch='armhf'
		;;
		'kitra710')
			deviceArch='armhf'
		;;
		'imx6ul-var-dart')
			deviceArch='armhf'
		;;
		'ccon-01')
			deviceArch='armhf'
		;;
		esac
		# Shared vars
		javaVersion="$version" # "7-jdk"
		javaType="${javaVersion##*-}" # "jdk"
		javaVersion="${javaVersion%-*}" # "7"
		variant="${variants[$javaType]}"

		# Debian
		debianSuite="${debianSuites[$javaVersion]}"
		debianAddSuite="${debianAddSuites[$javaVersion]}"
		

		debianJavaHome="/usr/lib/jvm/java-$javaVersion-openjdk-$deviceArch"
		if [ "$javaType" = 'jre' -a "$javaVersion" -lt 9 ]; then
			# woot, this hackery stopped in OpenJDK 9+!
			debianJavaHome+='/jre'
		fi

		needCaHack=
		if [ "$javaVersion" -ge 8 -a "$debianSuite" != 'sid' ]; then
			# "20140324" is broken (jessie), but "20160321" is fixed (sid)
			needCaHack=1
		fi

		if [ $device == "raspberry-pi" ]; then
			dist="resin/rpi-raspbian:$debianSuite"
		else
			dist="debian:${debianAddSuite:-$debianSuite}"
		fi
		debianPackage="openjdk-$javaVersion-$javaType"
		if [ "$javaType" = 'jre' -o "$javaVersion" -ge 9 ]; then
			# "openjdk-9" in Debian introduced an "openjdk-9-jdk-headless" package \o/
			debianPackage+='-headless'
		fi

		debCacheKey="$dist-openjdk-$javaVersion"
		debianVersion="${debCache[$debCacheKey]}"
		if [ -z "$debianVersion" ]; then
			debianVersion="$(set -x; docker run --rm "$dist" bash -c 'apt-get update -qq && apt-cache show "$@"' -- "$debianPackage" |tac|tac| awk -F ': ' '$1 == "Version" { print $2; exit }')"
			debCache["$debCacheKey"]="$debianVersion"
		fi
		debianFullVersion="${debianVersion%%-*}"

		if [ "$debianAddSuite" ] && [ $device != "raspberry-pi" ]; then
			debianAddSuiteContent="RUN echo 'deb http://deb.debian.org/debian $debianAddSuite main' > /etc/apt/sources.list.d/$debianAddSuite.list"
			debianPrioritizedSource="-t $debianAddSuite"
		else
			debianAddSuiteContent=""
			debianPrioritizedSource=""
		fi

		if [ "$needCaHack" ]; then
			if [ $device == "raspberry-pi" ]; then
				caHackContent0="ENV CA_CERTIFICATES_JAVA_VERSION 20140324"
			else
				caHackContent0="ENV CA_CERTIFICATES_JAVA_VERSION 20161107~bpo8+1"
			fi
			caHackContent1="ca-certificates-java=\$CA_CERTIFICATES_JAVA_VERSION "
			caHackContent2="RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure"
		else
			caHackContent0=""
			caHackContent1=""
			caHackContent2=""
		fi

		debian_dockerfilePath=$device/debian/$version
		mkdir -p $debian_dockerfilePath
		sed -e s@#{FROM}@"resin/$device-buildpack-deps:$debianSuite-$variant"@g \
			-e s@#{ADD_SUITE}@"$debianAddSuiteContent"@g \
			-e s@#{JAVA_HOME}@"$debianJavaHome"@g \
			-e s@#{FULL_VERSION}@"$debianFullVersion"@g \
			-e s@#{DEBIAN_VERSION}@"$debianVersion"@g \
			-e s@#{DEBIAN_PACKAGE}@"$debianPackage"@g \
			-e s@#{DEBIAN_PRIORITIZED_SOURCE}@"$debianPrioritizedSource"@g \
			-e s@#{CA_HACK0}@"$caHackContent0"@g \
			-e s@#{CA_HACK1}@"$caHackContent1"@g \
			-e s@#{CA_HACK2}@"$caHackContent2"@g Dockerfile.tpl > "$debian_dockerfilePath/Dockerfile"

		# Alpine Linux
		if [ $javaVersion != 9 ] && [ "$deviceArch" != 'armel' ]; then

			alpinePackage="openjdk$javaVersion"
			alpineJavaHome="/usr/lib/jvm/java-1.${javaVersion}-openjdk"
			alpinePathAdd="$alpineJavaHome/jre/bin:$alpineJavaHome/bin"

			case "$javaType" in
			'jdk')
			;;
			'jre')
				alpinePackage+="-$javaType"
				alpineJavaHome+="/$javaType"
			;;
			esac

			alpinePackageVersion="$(awk -F: '$1 == "P" { pkg = $2 } pkg == "'"$alpinePackage"'" && $1 == "V" { print $2 }' APKINDEX.$deviceArch)"
			alpineFullVersion="${alpinePackageVersion/./u}"
			alpineFullVersion="${alpineFullVersion%%.*}"

			alpine_dockerfilePath=$device/alpine/$version
			mkdir -p $alpine_dockerfilePath
			sed -e s@#{FROM}@resin/$device-alpine:$alpineVersion@g \
				-e s@#{ALPINE_JAVA_HOME}@"$alpineJavaHome"@g \
				-e s@#{ALPINE_JAVA_PATH}@"$alpinePathAdd"@g \
				-e s@#{ALPINE_FULL_VERSION}@"$alpineFullVersion"@g \
				-e s@#{ALPINE_PACKAGE_VERSION}@"$alpinePackageVersion"@g \
				-e s@#{ALPINE_PACKAGE}@"$alpinePackage"@g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile
		fi
	done
done

for fedoraDevice in $fedora_devices; do
	for variant in $variants; do
		if [ $variant == 'jre' ]; then
			fedoraPackage='java-1.8.0-openjdk'
		else
			fedoraPackage='java-1.8.0-openjdk java-1.8.0-openjdk-devel'
		fi
		fedora_dockerfilePath="$fedoraDevice/fedora/8-$variant"
		mkdir -p $fedora_dockerfilePath
		sed -e s~#{FROM}~resin/$fedoraDevice-fedora:24~g \
			-e s~#{FEDORA_PACKAGE}~"$fedoraPackage"~g Dockerfile.fedora.tpl > "$fedora_dockerfilePath/Dockerfile"
	done
done

rm -f APKINDEX*