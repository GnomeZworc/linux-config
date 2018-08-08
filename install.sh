#!/bin/sh

user=${USER_TO_INSTALL}
home=/home/${user}/
trash_file=/dev/null

install()
{
    echo "Install ${1} on system"
    apt-get install -y --quiet ${1} 2> ${trash_file} > ${trash_file}
}

py2install()
{
    echo "Install ${1} on python2.7"
    pip install --user ${1} 2> ${trash_file} > ${trash_file}
}

py3install()
{
    echp "Install ${1} on python3"
	pip3 install --user ${1} 2> ${trash_file} > ${trash_file}
}

echo "Install system package"
while read tmp
do
	install ${tmp}
done < package.list/debian-9.0-package.list

rm ${home}/.config/awesome -rf 2> ${trash_file}
mkdir -f ${home}/.config 2> ${trash_file}
cp -r ./awesome ${home}/.config/awesome
cp ./graphical/.* ${home}/ 2> ${trash_file}
cp ./bash/.* ${home}/ 2> ${trash_file}

echo "Install python package"
while read tmp
do
	su ${user} -c py2install ${tmp}
done < package.list/python2-package.list

while read tmp
do
	su ${user} -c py3install ${tmp}
done < package.list/python3-package.list

echo "Install docker"
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable"
apt-get update
install docker-ce -y 2> ${trash_file} > ${trash_file}
