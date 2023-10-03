#PUT THE CONTENT IN /tmp/a
id=$1
rm /tmp/django_script
type=expression
part=$2
cd ~/easy_german/$id

for i in `ls *text|sed 's/.text//g'`
do
part=$part
DE=`cat $i.text|sed 's/"/4444/g'|sed "s/4444/'/g"`
 echo $DE |grep '[a-z]' 1>/dev/null 2>/dev/null
 if [ $? -ne 0 ]
 then
         continue
 fi

EN='-------'
echo from revision.models import \*  >> /tmp/django_script
echo a=Sentence.objects.get_or_create\(name=\"${id}-${i}\",DE=\"$DE\",EN=\"$EN\",revision_number=-1,state=\'cold\',type=\"$type\"\,part=\"$part\"\) >> /tmp/django_script

done


for i in `ls *tixt|sed 's/.tixt//g'`
do
part=$part
DE=`cat $i.tixt|sed 's/"/4444/g'|sed "s/4444/'/g"`
echo $DE |grep '[a-z]' 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]
then
        continue
fi
EN='---------'
echo a=Sentence.objects.get_or_create\(name=\"${id}-${i}\",DE=\"$DE\",EN=\"$EN\",revision_number=-1,state=\'cold\',type=\"$type\"\,part=\"$part\"\) >> /tmp/django_script

done



echo a=Index.objects.get_or_create\(name=\"${id}\",state=\'pending\'\) >> /tmp/django_script
cd ~/bp
python manage.py shell < /tmp/django_script

cd -
for i in `ls *mp3|sed 's/.mp3//g'`
do
 cp $i.mp3 ~/bp/revision/static/${id}-${i}
done


