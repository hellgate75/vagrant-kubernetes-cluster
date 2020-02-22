#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"


function replace_in_vagranfile() {
	sed -i "s/$1/$2/g" $FOLDER/Vagrantfile
}

function check_base_address() {
	sh $FOLDER/base-ip-check "$1" *> /dev/null
	RES="$?"
	echo "$RES"
}

BASE_ADDR="192.168"
SUBNET="50"
BASE_IP=10
APP_NAME="k8s"
APP_NODES="2"
APP_MEMORY="1024"
APP_VCPUS="2"
ANSWER=""
while [ "y" != "$ANSWER" ] && [ "y" != "$ANSWER" ]
do
	clear
	printf "Please provide app name [default: $APP_NAME]: "
	read AN_VAR
	if [ "" != "$AN_VAR" ]; then
		APP_NAME="$AN_VAR"
	fi

	printf "Please provide number of client nodes [default: $APP_NODES]: "
	read AK_VAR
	[ -n "$AK_VAR" ] && [ "$AK_VAR" -eq "$AK_VAR" ] 2>/dev/null
	if [ $? -ne 0 ]; then
		APP_NODES="$APP_NODES"
	elif [ "" != "$SN_VAR" ]; then
		APP_NODES="$AK_VAR"
	fi

	printf "Please provide base address prefix nn.nn[.xx.xx.] [default: $BASE_ADDR]: "
	read BA_VAR
	if [ "" != "$BA_VAR" ] && [ "0" = "$(check_base_address "$BA_VAR")" ] ; then
		BASE_ADDR="$BA_VAR"
	fi

	printf "Please provide subnet number [xx.xx.]nn[.xx] [default: $SUBNET]: "
	read SN_VAR
	[ -n "$SN_VAR" ] && [ "$SN_VAR" -eq "$SN_VAR" ] 2>/dev/null
	if [ $? -ne 0 ]; then
		SUBNET="$SUBNET"
	elif [ "" != "$SN_VAR" ]; then
		SUBNET="$SN_VAR"
	fi

	printf "Please provide host address number [xx.xx.xx,]nn [default: $BASE_IP]: "
	read BI_VAR
	[ -n "$BI_VAR" ] && [ "$BI_VAR" -eq "$BI_VAR" ] 2>/dev/null
	if [ $? -ne 0 ]; then
		BASE_IP="$BASE_IP"
	elif [ "" != "$BI_VAR" ]; then
		BASE_IP="$BI_VAR"
	fi

	echo "Application name: <$APP_NAME>"
	echo "Number of nodes: <$APP_NODES>"
	echo "Base address will be: $BASE_ADDR.$SUBNET.xx"
	echo "Master Node address will be: $BASE_ADDR.$SUBNET.$BASE_IP"
	for i in $(seq 1 $APP_NODES)
	do
		IP_ADDR=$(( $BASE_IP + $i ))
		echo "Slave Node address will be: $BASE_ADDR.$SUBNET.$IP_ADDR"
	done
	printf "do you want continue [y/n]? : "
	read ANSWER

done

cp $FOLDER/Vagrantfile.template $FOLDER/Vagrantfile
replace_in_vagranfile "\\\$APPLICATION" "$APP_NAME"
replace_in_vagranfile "\\\$NODES" "$APP_NODES"
replace_in_vagranfile "\\\$BASE_ADDRESS" "$BASE_ADDR"
replace_in_vagranfile "\\\$BASE_SUBNET" "$SUBNET"
replace_in_vagranfile "\\\$BASE_IP_SUFFIX" "$BASE_IP"
replace_in_vagranfile "\\\$GUEST_MEMORY" "$APP_MEMORY"
replace_in_vagranfile "\\\$GUEST_VCPUS" "$APP_VCPUS"

