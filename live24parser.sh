#!/bin/bash
#
#
# live24parser - ακούστε online ραδιόφωνο από το τερματικό
# Copyright (c)2018 Vasilis Niakas and Contributors
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation version 3 of the License.
#
# Please read the file LICENSE and README for more information.
#
#
echo "Live24 Parser"
echo "Ένα script για κατέβασμα των links από το live24.gr για να ακούτε"
echo "τους αγαπημένους σας σταθμούς, όχι απαραιτήτα μέσω browser"
echo "--------------------------------------------------------------------"
echo "H διαδικασία ανάλογως την ταχύτητα της σύνδεσης σας, ενδέχεται να"
echo "διαρκέσει μερικά λεπτα. Περιμένετε την ολοκλήρωση της"
sleep 5
wget -q -O- http://live24.gr | grep -oP '<a[^<]*class="name"[^<]*href="\K[^"]+' | sed 's/^/http:\/\/live24.gr/' > live24_stations.txt
while IFS='' read -r line || [[ -n "$line" ]]; do
    num=$(( $num + 1 ))
    #echo $line
    station_name=$(wget -q -O- $line | grep -oP "radioStationName: '\K[^']+" | head -n1 | sed 's/powered by LIVE24//g' | cut -d "-" -f1)
    station_url=$(wget -q -O- $line | grep -oP "streamsrc: '\K[^']+")
    echo "$station_name  $station_url >> greek_stations.txt"
    echo "$station_name  $station_url" >> greek_stations.txt

done < "live24_stations.txt"
echo "Η λίστα ολοκληρώθηκε και βρίσκεται στο greek_stations.txt"
rm live24_stations.txt
exit 0


