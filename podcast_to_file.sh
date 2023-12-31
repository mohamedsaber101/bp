cat /t/bb.txt |grep -e Cari: -e Janusz: -e Manuel: -n |cut -d':' -f1 > /tmp/aa
##############################     /t/bb.txt     ##########################
#Cari:

#(30:45)
#Okay. Fahrt nach Polen, Leute. Ihr werdet es nicht bereuen.
#Manuel:

#(30:49) Ja. Bis bald!
#Cari:

#(30:50)
#Und kommt zu unserem Meetup.


##########################

ID=$1
cd ~/easy_german/$ID

for i in $(seq `cat /tmp/aa|wc -l|cut -d' ' -f1`)
do
o=$i
BEG=`sed -n ${i}p /tmp/aa`
ii=$(( i + 1 ));
END=`sed -n ${ii}p /tmp/aa`
lines=`awk -v s="$BEG" -v e="$END" 'NR>1*s&&NR<1*e'  /t/bb.txt `
AUDIO_BEG=`echo $lines|grep -oP '(?<=[(])[^)]*'|grep '[[:digit:]]'` 
content=`echo $lines|sed "s/($AUDIO_BEG)//g"`
i=$(( i + 1))
BEG=`sed -n ${i}p /tmp/aa`
ii=$(( i + 1 ));
END=`sed -n ${ii}p /tmp/aa`
lines=`awk -v s="$BEG" -v e="$END" 'NR>1*s&&NR<1*e'  /t/bb.txt `
AUDIO_END=`echo $lines|grep -oP '(?<=[(])[^)]*'|grep '[[:digit:]]'`
echo $AUDIO_BEG - $AUDIO_END 
echo $content > `printf "%03d" ${o}`.text
ffmpeg -i $ID.mp3 -ss $AUDIO_BEG -to $AUDIO_END  -acodec copy `printf "%03d" ${o}`.mp3
#read 
done
for i in `ls *text|sed 's/.text//g'`
do
cat $i.text |sed 's/\./\n/g'|grep -v '^$' > /tmp/$i

all_length=`sox $i.mp3 -n stat 2>/tmp/i ;cat /tmp/i|grep Length|sed 's/Length (seconds):   //g'`
all_ch=`wc -c /tmp/$i|cut -d' ' -f1`
current_pointer=0
for k in $(seq `wc -l /tmp/$i|cut -d' ' -f1`)
do
echo "K    $k"
line=`sed -n ${k}p  /tmp/$i`
echo line     $line
line_ch=`echo $line|wc -c|cut -d' ' -f1`
echo line_ch     $line_ch
percentage=`echo "scale=4;$line_ch / $all_ch"|bc -l`
echo percentage      $percentage
current_length=`echo "scale=4;$percentage * $all_length"|bc -l`
echo current_length      $current_length
actual_length=`echo "scale=4;$current_length + 1"|bc -l`
echo actual_length    $actual_length
echo $line > $i-${k}.tixt
current_pointerr=`echo "scale=4;$current_pointer"|bc -l|sed 's/^\./0./g'`
echo current_pointerr     $current_pointerr
ffmpeg -i $i.mp3 -ss $current_pointerr -t $actual_length -acodec copy $i-${k}.mp3
echo ffmpeg -i $i.mp3 -ss $current_pointerr -t $actual_length -acodec copy $i-${k}.mp3
current_pointer=`echo "scale=4;$current_pointer + $current_length"|bc -l`
echo current_pointer      $current_pointer
done
done
