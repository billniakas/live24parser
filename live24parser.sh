#!/bin/bash
#
#
# live24parser 
# Copyright (c)2018 Vasilis Niakas and Contributors
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation version 3 of the License.
#
# Please read the file LICENSE and README for more information.
#
#
function YN_Q {
	while true; do
		read -rp "$1" yes_no
		case "$yes_no" in
			y|yes|Y|Yes|YES )
				return 0;
				break;;
			n|no|N|No|NO )
				return 1;
				break;;
			* )
				echo "${2:-"μη έγκυρη απάντηση"}";;
		esac
	done
}

if [[ "$#" == "0" ]];
then
    echo "Δε δόθηκε παράμετρος"
    text="Δημιουργία λίστας με τους σταθμούς της αρχικής σελίδας του live24.gr"
    var=" "
    
else
    if [[ $1 == "--help" ]];
	then
	echo "----------------------------------------------"
	echo "--help          : Aυτό το κείμενο"
	#echo "--m3u  	      : create a M3U playlist file"
        #echo "--pls  	      : create a PLS playlist file"
	echo "----------------------------------------------"
	echo "Δημιουργία λίστας ανά περιοχή                 "
	echo "----------------------------------------------"
	echo "--athens        : Λίστα με σταθμούς της Αθήνας"
	echo "--thessaloniki  : Λίστα με σταθμούς της Θεσσαλονίκης"
	echo "--peloponisos   : Λίστα με σταθμούς της Πελλοπονήσου"
	echo "--makedonia     : Λίστα με σταθμούς της Μακεδονίας"
	echo "--hpeiros       : Λίστα με σταθμούς της Ηπείρου"
	echo "--thraki        : Λίστα με σταθμούς της Θράκης"
	echo "--thessalia     : Λίστα με σταθμούς της Θεσσαλίας"
	echo "--sterea        : Λίστα με σταθμούς της Στερεάς Ελλάδας"
	echo "--aigaio        : Λίστα με σταθμούς του Αιγαίου"
	echo "--ionio         : Λίστα με σταθμούς του Ιονίου"
	echo "--kriti         : Λίστα με σταθμούς της Κρήτης"
	echo "--webradios     : Λίστα με Web Radios"
	
	exit 0
	elif [[ $1 == "--athens" ]];then
		filename="_athens"
		text="Δημιουργία λίστας με σταθμούς της Αθήνας"
		var="/radio.jsp?aid=1"  # Αθήνα

	elif [[ $1 == "--thessaloniki" ]];then
		filename="_thessaloniki"
		text="Δημιουργία λίστας με σταθμούς της Θεσσαλονίκης"
		var="/radio.jsp?aid=2"  # Θεσ/κη

	elif [[ $1 == "--peloponisos" ]];then
		filename="_peloponisos"
		text="Δημιουργία λίστας με σταθμούς της Πελλοπονήσου"
		var="/radio.jsp?aid=4"  # Πελ/νησος

	elif [[ $1 == "--makedonia" ]];then
		filename="_makedonia"
		text="Δημιουργία λίστας με σταθμούς της Μακεδονίας"
		var="/radio.jsp?aid=5"  # Μακεδονία

	elif [[ $1 == "--hpeiros" ]];then
		filename="_hpeiros"
		text="Δημιουργία λίστας με σταθμούς της Ηπείρου"
		var="/radio.jsp?aid=7"  # Ήπειρος

	elif [[ $1 == "--thraki" ]];then
		filename="_thraki"
		text="Δημιουργία λίστας με σταθμούς της Θράκης"
		var="/radio.jsp?aid=6"  # Θράκη

	elif [[ $1 == "--thessalia" ]];then
		filename="_thessalia"
		text="Δημιουργία λίστας με σταθμούς της Θεσσαλίας"
		var="/radio.jsp?aid=10"  # Θεσσαλία

	elif [[ $1 == "--sterea" ]];then
		filename="_sterea"
		text="Δημιουργία λίστας με σταθμούς της Στερεάς Ελλάδας"
		var="/radio.jsp?aid=11"  # Στερεά Ελλάδα

	elif [[ $1 == "--aigaio" ]];then
		filename="_aigaio"
		text="Δημιουργία λίστας με σταθμούς του Αιγαίου"
		var="/radio.jsp?aid=99"  # Αιγαίο

	elif [[ $1 == "--ionio" ]];then
		filename="_ionio"
		text="Δημιουργία λίστας με σταθμούς του Ιονίου"
		var="/radio.jsp?aid=9"  # Ιόνιο

	elif [[ $1 == "--kriti" ]];then
		filename="_kriti"
		text="Δημιουργία λίστας με σταθμούς της Κρήτης"
		var="/radio.jsp?aid=94"  # Κρήτη

	elif [[ $1 == "--webradios" ]];then
		filename="_webradios"
		text="Δημιουργία λίστας με Web Radios"
		var="/radio.jsp?aid=84"  # Web Radios

		
	else
	echo "Δόθηκε λανθασμένη παράμετρος"
	exit 0
    fi
fi
clear
echo "--------------------------------------------------------------------"
echo "Live24 Parser"
echo "--------------------------------------------------------------------"
echo "Ένα script για κατέβασμα των links από το live24.gr για να ακούτε"
echo "τους αγαπημένους σας σταθμούς, όχι απαραιτήτα μέσω browser"
echo "--------------------------------------------------------------------"
echo "H διαδικασία ανάλογως την ταχύτητα της σύνδεσης σας, ενδέχεται να"
echo "διαρκέσει μερικά λεπτα."
echo "--------------------------------------------------------------------"
echo "Τρέξτε το script με την παράμετρο --help για περισσότερα"
echo "--------------------------------------------------------------------"
if YN_Q "Θέλετε να συνεχίσετε (y/n); " "μη έγκυρος χαρακτήρας" ; then
	echo $text
else
	echo "Έξοδος..."
	exit 0
fi

sleep 1

wget -q -O- http://live24.gr$var | grep -oP '<a[^<]*class="name"[^<]*href="\K[^"]+' | sed 's/^/http:\/\/live24.gr/' > live24_stations.txt
while IFS='' read -r line || [[ -n "$line" ]]; do
    num=$(( $num + 1 ))
    #echo $line
    station_name=$(wget -q -O- $line | grep -oP "radioStationName: '\K[^']+" | head -n1 | sed 's/powered by LIVE24//g' | cut -d "-" -f1)
    station_url=$(wget -q -O- $line | grep -oP "streamsrc: '\K[^']+")
    echo "$station_name  $station_url >> greek_stations"$filename".txt"
    echo "$station_name, $station_url" >> greek_stations"$filename".txt

done < "live24_stations.txt"
echo "Η λίστα ολοκληρώθηκε και βρίσκεται στο greek_stations"$filename".txt"
rm live24_stations.txt
exit 0
