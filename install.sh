#!/bin/sh

user=${USER_TO_INSTALL}
home=/home/${user}/
trash_file=/dev/null

install()
{
	apt-get install -y --quiet $1
}

while read tmp
do
	install ${tmp}
done < package.list/debian-9.0-package.list

rm ${home}/.config/awesome -rf 2> ${trash_file}
mkdir -f ${home}/.config 2> ${trash_file}
cp -r ./awesome ${home}/.config/awesome
cp ./graphical/.* ${home}/ 2> ${trash_file}
cp ./bash/.* ${home}/ 2> ${trash_file}
