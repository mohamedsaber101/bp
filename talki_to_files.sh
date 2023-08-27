rm /tmp/v; rm /tmp/a;for i in `seq $(cat /tmp/t|wc -l|cut -d' ' -f1)`;do clear;tt=`sed -n ${i}p /tmp/t`;sed -n ${i}p /tmp/t ;echo '===================='; 
google-chrome "https://translate.google.co.uk/?sl=de&tl=en&text=$tt&op=translate" 1>/dev/null 2>&1 &
read -e e;if [ "$e" == "d" ];then continue;fi; echo $e |grep '^v ' 1>/dev/null 2>/dev/null ;if [ $? -eq 0 ];then E=`echo $e|sed 's/^v //g'`; echo "E -- $E" >> /tmp/v;echo "-------------------------" >> /tmp/v;echo `sed -n ${i}p /tmp/t` >> /tmp/v ;else echo "E -- $e" >> /tmp/a;echo "-------------------------" >> /tmp/a;echo `sed -n ${i}p /tmp/t` >> /tmp/a;fi ;done

