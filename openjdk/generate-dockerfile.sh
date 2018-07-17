#!/bin/bash
set -e

function getZuluVersion() {
	case "$deviceArch" in
	'armhf')
		if [ $javaVersion == '7' ]; then
			# Not found the binary yet.
			zuluBinary=
		else
			zuluBinary='ezdk-1.8.0_121-8.20.0.42-eval-linux_aarch32hf'
		fi
	;;
	'amd64')
		if [ $javaVersion == '7' ]; then
			# Not found the binary yet.
			zuluBinary=
		else
			zuluBinary='zulu8.21.0.1-jdk8.0.131-linux_x64'
		fi
	;;
	*)
		zuluBinary=
	;;
	esac
}

declare -A debianSuites=(
	[6]='wheezy'
	[7]='jessie'
	[8]='stretch'
	[9]='sid'
)

declare -A debianAddSuites=(
	[9]='experimental'
)

declare -A variants=(
	[jre]='curl'
	[jdk]='scm'
)

declare -A debCache=()

versions='7-jdk 7-jre 8-jdk 8-jre'
# List of devices
targets='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart kitra520 jetson-tx2 jetson-tx1 iot2000 generic-armv7ahf generic-aarch64 bananapi-m1-plus orangepi-plus2 fincm3 artik533s artik530 orbitty-tx2'
# List of archs
targets+=' armv7hf armel i386 amd64 aarch64'
fedora_targets=' raspberry-pi2 beaglebone-black via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 up-board imx6ul-var-dart kitra520 jetson-tx2 jetson-tx1 armv7hf amd64 aarch64 generic-aarch64 generic-armv7ahf bananapi-m1-plus orangepi-plus2 fincm3 artik533s artik530 orbitty-tx2 '
alpineVersion='3.8'
alpineDeviceArchs='x86_64 x86 armhf'
zuluVersionArmhf='ezdk-1.8.0_121-8.20.0.42-eval-linux_aarch32hf'
zuluVersionX86_64='zulu8.21.0.1-jdk8.0.131-linux_x64'
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

for target in $targets; do
	for version in $versions; do
		case "$target" in
		'armv7hf'|'generic-armv7ahf'|'bananapi-m1-plus'|'orangepi-plus2')
			targetArch='armhf'
		;;
		'armel')
			targetArch='armel'
		;;
		'i386')
			targetArch='i386'
		;;
		'amd64')
			targetArch='amd64'
		;;
		'raspberry-pi')
			targetArch='armhf'
		;;
		'raspberry-pi2')
			targetArch='armhf'
		;;
		'raspberrypi3'|'fincm3')
			targetArch='armhf'
		;;
		'beaglebone-black')
			targetArch='armhf'
		;;
		'beaglebone-green-wifi')
			targetArch='armhf'
		;;
		'beaglebone-green')
			targetArch='armhf'
		;;
		'intel-edison')
			targetArch='i386'
		;;
		'qemux86')
			targetArch='i386'
		;;
		'cybertan-ze250')
			targetArch='i386'
		;;
		'iot2000')
			targetArch='i386'
		;;
		'intel-nuc')
			targetArch='amd64'
		;;
		'qemux86-64')
			targetArch='amd64'
		;;
		'up-board')
			targetArch='amd64'
		;;
		'via-vab820-quad')
			targetArch='armhf'
		;;
		'zynq-xz702')
			targetArch='armhf'
		;;
		'odroid-c1')
			targetArch='armhf'
		;;
		'odroid-xu4')
			targetArch='armhf'
		;;
		'parallella')
			targetArch='armhf'
		;;
		'nitrogen6x')
			targetArch='armhf'
		;;
		'hummingboard')
			targetArch='armhf'
		;;
		'ts4900')
			targetArch='armhf'
		;;
		'colibri-imx6dl')
			targetArch='armhf'
		;;
		'apalis-imx6q')
			targetArch='armhf'
		;;
		'am571x-evm')
			targetArch='armhf'
		;;
		'ts7700')
			targetArch="armel"
		;;
		'artik5'|'artik533s'|'artik530')
			targetArch='armhf'
		;;
		'artik10')
			targetArch='armhf'
		;;
		'kitra520')
			targetArch='armhf'
		;;
		'imx6ul-var-dart')
			targetArch='armhf'
		;;
		'ccon-01')
			targetArch='armhf'
		;;
		'jetson-tx2'|'jetson-tx1'|'kitra710'|'artik710'|'generic-aarch64'|'orbitty-tx2')
			targetArch='armhf'
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
		

		debianJavaHome="/usr/lib/jvm/java-$javaVersion-openjdk-$targetArch"
		if [ "$javaType" = 'jre' -a "$javaVersion" -lt 9 ]; then
			# woot, this hackery stopped in OpenJDK 9+!
			debianJavaHome+='/jre'
		fi

		needCaHack=
		if [ "$javaVersion" -ge 8 -a "$debianSuite" != 'sid' ]; then
			# "20140324" is broken (jessie), but "20160321" is fixed (sid)
			needCaHack=1
		fi

		if [ $target == "raspberry-pi" ]; then
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

		if [ "$debianAddSuite" ] && [ $target != "raspberry-pi" ]; then
			debianAddSuiteContent="RUN echo 'deb http://deb.debian.org/debian $debianAddSuite main' > /etc/apt/sources.list.d/$debianAddSuite.list"
			debianPrioritizedSource="-t $debianAddSuite"
		else
			debianAddSuiteContent=""
			debianPrioritizedSource=""
		fi

		if [ "$needCaHack" ]; then
			if [ $target == "raspberry-pi" ]; then
				caHackContent0="ENV CA_CERTIFICATES_JAVA_VERSION 20140324"
			else
				caHackContent0="ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1"
			fi
			caHackContent1="ca-certificates-java=\$CA_CERTIFICATES_JAVA_VERSION "
			caHackContent2="RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure"
		else
			caHackContent0=""
			caHackContent1=""
			caHackContent2=""
		fi

		debian_dockerfilePath=$target/debian/$version
		mkdir -p $debian_dockerfilePath
		sed -e s@#{FROM}@"resin/$target-buildpack-deps:$debianSuite-$variant"@g \
			-e s@#{ADD_SUITE}@"$debianAddSuiteContent"@g \
			-e s@#{JAVA_HOME}@"$debianJavaHome"@g \
			-e s@#{FULL_VERSION}@"$debianFullVersion"@g \
			-e s@#{DEBIAN_VERSION}@"$debianVersion"@g \
			-e s@#{DEBIAN_PACKAGE}@"$debianPackage"@g \
			-e s@#{DEBIAN_PRIORITIZED_SOURCE}@"$debianPrioritizedSource"@g \
			-e s@#{CA_HACK0}@"$caHackContent0"@g \
			-e s@#{CA_HACK1}@"$caHackContent1"@g \
			-e s@#{CA_HACK2}@"$caHackContent2"@g Dockerfile.tpl > "$debian_dockerfilePath/Dockerfile"

		# Zulu variant
		getZuluVersion
		if [ "$zuluBinary" ]; then
			if [ $javaType == 'jdk' ]; then
				zulu_template='Dockerfile.zulu.jdk.tpl'
			else
				zulu_template='Dockerfile.zulu.jre.tpl'
			fi

			mkdir -p $debian_dockerfilePath/zulu
			sed -e s@#{FROM}@"resin/$device-buildpack-deps:$debianSuite-$variant"@g \
				-e s@#{ZULU_VERSION}@"$zuluBinary"@g $zulu_template > "$debian_dockerfilePath/zulu/Dockerfile"
		fi

		# Alpine Linux
		if [ $javaVersion != 9 ] && [ "$targetArch" != 'armel' ]; then

			if [ $target == "armv7hf" ]; then
				target='armhf'
			fi

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

			alpinePackageVersion="$(awk -F: '$1 == "P" { pkg = $2 } pkg == "'"$alpinePackage"'" && $1 == "V" { print $2 }' APKINDEX.$targetArch)"
			alpineFullVersion="${alpinePackageVersion/./u}"
			alpineFullVersion="${alpineFullVersion%%.*}"

			alpine_dockerfilePath=$target/alpine/$version
			mkdir -p $alpine_dockerfilePath
			sed -e s@#{FROM}@resin/$target-alpine:$alpineVersion@g \
				-e s@#{ALPINE_JAVA_HOME}@"$alpineJavaHome"@g \
				-e s@#{ALPINE_JAVA_PATH}@"$alpinePathAdd"@g \
				-e s@#{ALPINE_FULL_VERSION}@"$alpineFullVersion"@g \
				-e s@#{ALPINE_PACKAGE_VERSION}@"$alpinePackageVersion"@g \
				-e s@#{ALPINE_PACKAGE}@"$alpinePackage"@g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile
		fi
	done
done

for fedoratarget in $fedora_targets; do
	for variant in $variants; do
		if [ $variant == 'jre' ]; then
			fedoraPackage='java-1.8.0-openjdk'
		else
			fedoraPackage='java-1.8.0-openjdk java-1.8.0-openjdk-devel'
		fi
		fedora_dockerfilePath="$fedoratarget/fedora/8-$variant"
		mkdir -p $fedora_dockerfilePath
		sed -e s~#{FROM}~resin/$fedoratarget-fedora:latest~g \
			-e s~#{FEDORA_PACKAGE}~"$fedoraPackage"~g Dockerfile.fedora.tpl > "$fedora_dockerfilePath/Dockerfile"
	done
done

rm -f APKINDEX*
