#!/bin/sh

echo -n "Give me the user name: "
read user

home=/home/${user}/
trash_file=/dev/null

install()
{
    echo "Install on system : ${1}"
    apt-get install -y --quiet ${1} 2> ${trash_file} > ${trash_file}
}

echo "Install system packages"
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
	su ${user} -c "pip install --user ${tmp}" > ${trash_file} 2> ${trash_file}
done < package.list/python2-package.list

while read tmp
do
	su ${user} -c "pip3 install --user ${tmp}" > ${trash_file} 2> ${trash_file}
done < package.list/python3-package.list

echo "Install docker"
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable" > ${trash_file} 2> ${trash_file}
apt-get update >${trash_file} 2> ${trash_file}
install docker-ce 2> ${trash_file} > ${trash_file}
usermod -aG docker ${user}
echo "Install docker-compose"
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
