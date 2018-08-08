#!/bin/sh

echo -n "Give me the user name: "
read user

home=/home/${user}/
trash_file=/dev/null

install()
{
    echo "Install ${1} on system"
    apt-get install -y --quiet ${1} 2> ${trash_file} > ${trash_file}
}

echo "Install system package"
while read tmp
do
	install ${tmp}
done < package.list/debian-9.0-package.list

rm ${home}/.config/awesome -rf 2> ${trash_file}
mkdir ${home}/.config 2> ${trash_file}
cp -r ./awesome ${home}/.config/awesome
cp ./graphical/.* ${home}/ 2> ${trash_file}
cp ./bash/.* ${home}/ 2> ${trash_file}
chown -R ${user}:${user} ${home}

echo "Install python package"
while read tmp
do
	su ${user} -c "pip install --user ${tmp}"
done < package.list/python2-package.list

while read tmp
do
	su ${user} -c "pip3 install --user ${tmp}"
done < package.list/python3-package.list

echo "Install docker"
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable"
apt-get update
install docker-ce -y 2> ${trash_file} > ${trash_file}
