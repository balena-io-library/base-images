FROM resin/armv7hf-fedora:24
LABEL io.resin.device-type="artik533s"

RUN echo $'[artik]\n\
name=Artik $releasever - $basearch\n\
failovermethod=priority\n\
baseurL=http://repo.artik.cloud/artik/bin/pub/artik/linux/releases/$releasever/Everything/$basearch/os/\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-artik' > /etc/yum.repos.d/artik.repo

RUN echo $'-----BEGIN PGP PUBLIC KEY BLOCK-----\n\
Version: GnuPG v1\n\
\n\
mI0EWAoJUwEEAMSpsqvDOz8ceSNrDHbuDlM3R7Gc+Md+eH/aXZYse0ZRC8D9ZSYO\n\
CfgN983pJd5NZSGSEcK1epJ7oKmQ6k7Kb32ff/nVwIrbR8fXVUc6DiBeKIhVTO3U\n\
th4jf+pXi4r83dWuKQ2uaKcjpmUHEhyUIIXwJuOS2GYfzYLs45yMVCDhABEBAAG0\n\
QEFSVElLIEZlZG9yYSBQYWNrYWdlIFJlcG9zaXRvcnkgKFNhbXN1bmcgQVJUSUsp\n\
IDxhcnRpZUBhcnRpay5pbz6IuAQTAQIAIgUCWAoJUwIbAwYLCQgHAwIGFQgCCQoL\n\
BBYCAwECHgECF4AACgkQDK9lFg3UZUXobQQAil5UyDXxBrViiTQNavBAFj+BFXyR\n\
txbq4LvIywOFCsvNood5pXXVXLx6NZhhJ+ApL98SHEdz9jwel128FiQv+TXduoVc\n\
oNXv6ZyQ77so8YBc4IuxZht4wIG6GzNGDJNnOr12pUmMt66tfPngYeLX0pVei5dR\n\
j4oWZJkuol8dYwy4jQRYCglTAQQAxEWajcCuuEIDkyG6HA0EosrWDjpHWqH9vXZk\n\
JuUeKq+vA2acXYnelDMLhK7MBCF2tLey4I58QO9ga+/uyK7HNqZF9pXybdoeM89d\n\
FMN8K71AsdkzEwd1/2yJiJKOzg10ESE99Q4QAM+okpWZRtgV59X2W97uXIGzIE30\n\
mvDmSbEAEQEAAYifBBgBAgAJBQJYCglTAhsMAAoJEAyvZRYN1GVFN40EAIJom0ZY\n\
FwJu6zWID35HH7Uq4tvrm4Jt/xg0VsUnmUQlP5BkZLCp+gUn33tKWJuP6vo+Ck5X\n\
D/2sq0flj5mPF9WBE1TLc8Tw9DbFEMpWd1NboRlCAK/O4ote2bfaqYwCTj8QXEHW\n\
Nb0z4J5LYa1ci8t3mEXnzMQMqlqUFOCfve5p\n\
=m52w\n\
-----END PGP PUBLIC KEY BLOCK-----' > /etc/pki/rpm-gpg/RPM-GPG-KEY-artik

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
		libartik-sdk \
	&& dnf clean all