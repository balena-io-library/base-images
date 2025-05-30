# AUTOGENERATED FILE
FROM balenalib/var-som-mx6-debian:bookworm-run

# A few reasons for installing distribution-provided OpenJDK:
#
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#     really hairy.
#
#     For some sample build times, see Debian's buildd logs:
#       https://buildd.debian.org/status/logs.php?pkg=openjdk-11

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-11-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

RUN set -ex; \
	\
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		openjdk-11-jdk-headless \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	rm -vf /usr/local/bin/java; \
	\
# ca-certificates-java does not work on src:openjdk-11: (https://bugs.debian.org/914424, https://bugs.debian.org/894979, https://salsa.debian.org/java-team/ca-certificates-java/commit/813b8c4973e6c4bb273d5d02f8d4e0aa0b226c50#d4b95d176f05e34cd0b718357c532dc5a6d66cd7_54_56)
	keytool -importkeystore -srckeystore /etc/ssl/certs/java/cacerts -destkeystore /etc/ssl/certs/java/cacerts.jks -deststoretype JKS -srcstorepass changeit -deststorepass changeit -noprompt; \
	mv /etc/ssl/certs/java/cacerts.jks /etc/ssl/certs/java/cacerts; \
	/var/lib/dpkg/info/ca-certificates-java.postinst configure; \
	\
# verify that "docker-java-home" returns what we expect
	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
	\
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

# https://docs.oracle.com/javase/10/tools/jshell.htm
# https://en.wikipedia.org/wiki/JShell
CMD ["jshell"]

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: https://balena.io/docs"]

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo 'This base image is deprecated and will no longer receive updates. Please see our blog post (https://blog.balena.io/deprecate-balenalib-images/) for migration guidance and suggested alternatives. Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v7 \nOS: Debian Bookworm \nVariant: run variant \nDefault variable(s): UDEV=off \nThe following software stack is preinstalled: \nOpenJDK v11-jdk \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info