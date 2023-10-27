
counter=`cat /t/reverso_counter`

audio-recorder -c status |grep off
if [ $? -eq 0 ]
then
xclip -selection primary -o > ~/easy_german/reverso/`printf "%04d" ${counter}`.text
audio-recorder -c start

else
audio-recorder -c stop
audio_file=`ls ~/Audio |grep u2 |tail -1`
mv ~/Audio/$audio_file ~/easy_german/reverso/`printf "%04d" ${counter}`.mp3
counter1=$(( counter + 1))
echo $counter1 > /t/reverso_counter
fi