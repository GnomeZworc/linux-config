#!/bin/sh

user=${USER_TO_INSTALL}
home=/home/${user}/
trash_file=/dev/null

install()
{
	apt-get install -y --quiet $1
}

py2install()
{
	pip install --user $1
}

py3install()
{
	pip3 install --user $1
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

while read tmp
do
	su ${user} -c py2install ${tmp}
done < package.list/python2-package.list

while read tmp
do
	su ${user} -c py3install ${tmp}
done < package.list/python3-package.list

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable"

apt-get update
install docker-ce
