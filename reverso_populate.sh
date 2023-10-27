#PUT THE CONTENT IN /tmp/a
id=rverso
rm /tmp/django_script
type=expression
part=$id
cd ~/easy_german/$id

for i in `ls *text|sed 's/.text//g'`
do
category=reverso
DE=`cat $i.text|sed 's/"/4444/g'|sed "s/4444/'/g"`

EN='-------'
echo from revision.models import \*  >> /tmp/django_script
echo a=Sentence.objects.get_or_create\(name=\"rv-${i}\",DE=\"$DE\",EN=\"$EN\",revision_number=0,state=\'hot\',type=\"$type\"\,part=\"$part\"\, category=\"$category\"\) >> /tmp/django_script

done

cd ~/bp
python manage.py shell < /tmp/django_script

cd -
for i in `ls *mp3|sed 's/.mp3//g'`
do
 cp $i.mp3 ~/bp/revision/static/rv-${i}
done

