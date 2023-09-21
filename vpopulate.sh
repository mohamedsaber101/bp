#PUT THE CONTENT IN /tmp/a
id=$1
type=vocabulary
part=vocabulary
cd ~/easy_german/$id
echo from revision.models import \*  > /tmp/django_script
for i in `seq $(cat $id.txt|wc -l | cut -d' ' -f1)`
do
DE=`sed -n ${i}p $id.txt |cut -d'-' -f1`
EN=`sed -n ${i}p $id.txt |cut -d'-' -f2`

echo a=Sentence.objects.get_or_create\(name=\"V${id}-${i}\",DE=\"$DE\",EN=\"$EN\",revision_number=-1,state=\'cold\',type=\"$type\",part=\"$part\"\) >> /tmp/django_script

done


echo a=Index.objects.get_or_create\(name=\"V${id}\",state=\'pending\'\) >> /tmp/django_script
cd ~/bp
python manage.py shell < /tmp/django_script

