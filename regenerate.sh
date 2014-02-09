#!/bin/sh
set -e
dpkg-deb -b net.pocketmine.server
dpkg-deb -b net.pocketmine.php-5.5
dpkg-deb -b net.pocketmine.php-5.5-opcache

dpkg-scanpackages . /dev/null > Packages
cat Packages | bzip2 -9c > Packages.bz2
cat Packages | gzip -9c > Packages.gz