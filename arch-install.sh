#!/bin/bash
echo "Checking prerequirements..."

#root priviledge check
sudo whoami > /dev/null
if [ $? -ne 0 ]
then
    echo "ERROR: root priviledge is needed" >&2
    exit 1
fi

#Command check
which ansible-playbook mkpasswd genfstab pacstrap arch-chroot 1>/dev/null
if [ $? -ne 0 ]
then
    echo "ERROR: Required commands are not found." >&2
    exit 1
fi

echo "OK"

#Run ansible playbook
PLAYBOOKS="stage1.yml stage2.yml"
for PB in ${PLAYBOOKS}
do
    ansible-playbook -i localhost, -c local $(dirname ${0})/ansible/${PB}
    if [ $? -ne 0 ]
    then
        echo "################################################################################"
        echo "$(dirname ${0})/ansible/${PB} Failed. Please see error log"
        echo "################################################################################"
        exit 1
    fi
done
echo "################################################################################"
echo "${PLAYBOOKS} have been successfully completed. Please run following commands."
echo "sudo arch-chroot YOUR_TARGET_MOUNTPOINT"
echo "ansible-playbook -i localhost, -c local /root/stage3.yml"
echo "################################################################################"

exit 0