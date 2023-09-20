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
line=`sed -n ${k}p  /tmp/$i`
line_ch=`echo $line|wc -c|cut -d' ' -f1`
percentage=`echo "scale=4;$line_ch / $all_ch"|bc -l`
current_length=`echo "scale=4;$percentage * $all_length"|bc -l`
actual_length=`echo "scale=4;$current_length + 1"|bc -l`
echo $line > $i-${k}.tixt
current_pointerr=`echo "scale=4;$current_pointer - 1"|bc -l`
ffmpeg -i $i.mp3 -ss $current_pointerr -t $actual_length -acodec copy $i-${k}.mp3
current_pointer=`echo "scale=4;$current_pointer + $current_length"|bc -l`
done
done
