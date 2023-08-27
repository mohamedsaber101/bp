#PUT THE CONTENT IN /tmp/a
id=$1
type=expression

file=/tmp/b
cat /tmp/a |sed 's/\"//g' | sed "s/\'//g"|sed 's/E -- //g'| grep -v '^ \-\-'|grep -v '^\-\-'|grep -v '^$'|grep -v '^ $'|grep -v '^   $'|grep -v '^  $' > /tmp/b
for i in `seq $(cat $file|wc -l | cut -d' ' -f1)`
do
if [ $((i%2)) -eq 0 ]
then
continue
else
ii=$((i+1))
EN=`sed -n ${i}p $file`
DE=`sed -n ${ii}p $file`
echo $EN -**- $DE

echo from revision.models import \*  > /tmp/django_script
echo a=Sentence.objects.get_or_create\(name=\"${id}-${i}\",DE=\"$DE\",EN=\"$EN\",revision_number=-1,state=\'cold\',type=\"$type\"\) >> /tmp/django_script
echo a=Index.objects.get_or_create\(name=\"${id}\",state=\'pending\'\) >> /tmp/django_script
python manage.py shell < /tmp/django_script




fi
done


echo from revision.models import \*  > /tmp/django_script

echo a=Index.objects.get_or_create\(name=\"${id}\",state=\'pending\'\) >> /tmp/django_script
python manage.py shell < /tmp/django_script

