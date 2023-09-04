from django.shortcuts import render
from django.shortcuts import redirect, reverse 
import random
import datetime
from django.http import HttpResponse
from django.template import loader
from .models import *
from django.db.models import Q
from django.core import serializers
# Create your views here.
#GLOBAL VARS
repeat_list = []
start_time = datetime.datetime.now()
timer_state = 'running'
f = Paramater.objects.get(name='font_size')
font_size = getattr(f, 'value')
re_index = 0
re_list = []
re_boolean = True


def index(request):
    global mode 
    mode='ordered'
    global type
    type = 'index'
    sentence_name = Sentence.objects.filter(state='hot').order_by('revision_number').first()
    sentence = Sentence.objects.get(name=str(sentence_name))
    rest_count = Sentence.objects.filter(state='hot',revision_number=sentence.revision_number).count()
    context = {
        'sentence': sentence,
        'rest_count': rest_count,
        'timer': str((datetime.datetime.now() - start_time)).split('.')[0],
        'font_size': font_size,


    }
    return render(request, 'index.html', context)

def vocabulary(request):
    global mode
    mode = 'vocabulary'
    sentence_name = Sentence.objects.filter(state='hot', type='vocabulary').order_by('revision_number').first()
    sentence = Sentence.objects.get(name=str(sentence_name))
    rest_count = Sentence.objects.filter(state='hot',revision_number=sentence.revision_number, type='vocabulary').count()
    context = {
        'sentence': sentence,
        'rest_count': rest_count,
        'timer': str((datetime.datetime.now() - start_time)).split('.')[0],
        'font_size': font_size,

        

    }
    return render(request, 'index.html', context)


def inject(request):

    in_process_sentences = Sentence.objects.filter(state='hot', revision_number__lte='0')
    if len(in_process_sentences) > 0:
        print ('\n********* DP ********* '+ str(len(in_process_sentences)) + ' are still under processing. Complete them and come back\n')
        return redirect('/')
    else:
        indexed_episode = Index.objects.filter(state='pending').order_by('pk').first()
        data_rows = Sentence.objects.filter(name__contains = indexed_episode.name)
        for row in data_rows:
            setattr(row, 'state', 'hot')
            row.save()
        setattr(indexed_episode, 'state', 'injected')
        setattr(indexed_episode, 'time_of_injection', datetime.datetime.now())     
        indexed_episode.save()
        return redirect('/')



def delete(request, id):
    sentence = Sentence.objects.get(pk=id)
    sentence.delete()
    if mode == 'ordered':
        return redirect('/')
    elif mode == 'random':
        return redirect('/random')



def repeat(request):
    global mode
    mode = 'repeat'
    sentence_list = Sentence.objects.filter(type='expression')
    global repeat_list
    if len(repeat_list) >= len(sentence_list) - 3:
        repeat_list = []
    while True:
        rid = random.randint(0, len(sentence_list) - 1)
        if rid in repeat_list:
            continue
        else:
            break
    repeat_list = repeat_list + [rid]
    sentence1 = Sentence.objects.get(name=sentence_list[rid])
    while True:
        rid = random.randint(0, len(sentence_list) - 1)
        if rid in repeat_list:
            continue
        else:
            break
    repeat_list = repeat_list + [rid]

    sentence2 = Sentence.objects.get(name=sentence_list[rid])
    while True:
        rid = random.randint(0, len(sentence_list) - 1)
        if rid in repeat_list:
            continue
        else:
            break    
    repeat_list = repeat_list + [rid]
    sentence3 = Sentence.objects.get(name=sentence_list[rid])
    context = {
        'sentence1': sentence1,
        'sentence2': sentence2,
        'sentence3': sentence3,
        'timer': str((datetime.datetime.now() - start_time)).split('.')[0],
        'font_size': font_size,

    }

    return render(request, 'repeat.html', context)

def random_hot(request):
    global mode
    mode='random'
    sentence_list = Sentence.objects.filter(Q(revision_number__gt=0, type='vocabulary') | Q(state='cold', revision_number = 0, type='vocabulary'))
    rid = random.randint(0, len(sentence_list) - 1)
    sentence = Sentence.objects.get(name=sentence_list[rid])
    rest_count = Sentence.objects.filter(state='hot',revision_number=0).count()


    context = {
        'sentence': sentence,
        'rest_count': rest_count,
        'timer': str((datetime.datetime.now() - start_time)).split('.')[0],
        'font_size': font_size,

        

    }
    return render(request, 'index.html', context)


    
def promote(request, id):
    sentence = Sentence.objects.get(pk=id)
    revision_number = getattr (sentence, 'revision_number')

    setattr (sentence, 'state', 'hot')
    setattr (sentence, 'revision_number', revision_number + 1 )
    sentence.save()
    return next_action(request)



def demote(request, id):
    sentence = Sentence.objects.get(pk=id)
    setattr (sentence, 'state', 'cold')
    sentence.save()
    return next_action(request)


def next_action(request):
    if mode == 'ordered':
        return redirect('/')
    elif mode == 'random':
        return redirect('/random')
    elif mode == 'vocabulary':
        return redirect('/vocabulary')
    elif mode == 'repeat':
        return redirect('/repeat')
    elif mode == 'dotting':
        return redirect('/dotting')
    
def set_timer(request, mode='reset'):
    global start_time
    global  timer_state
    global pausing_time
    if mode == 'reset':
        start_time = datetime.datetime.now()
    elif mode == 'pause':
        print (mode)
        if timer_state == 'running':
            pausing_time = datetime.datetime.now() - start_time
            start_time = datetime.datetime(2070, 1, 1, 00, 00, 00)
            timer_state = 'paused'
        elif timer_state == 'paused':
            start_time = datetime.datetime.now() - pausing_time
            timer_state = 'running'
    return next_action(request)


def dotting(request):


    global mode
    mode='dotting'
    global re_index
    global re_list
    global re_boolean
    if len(re_list) >= 3 and re_boolean is True:
        sentence = Sentence.objects.get(pk=re_list[re_index])
        re_index += 1
        re_boolean = False
        dotting_factor = 're_dotting_factor'

    else:
        sentence_list = Sentence.objects.filter(Q(revision_number__gt=0) | Q(state='cold', revision_number = 0))
        rid = random.randint(0, len(sentence_list) - 1)
        sentence = Sentence.objects.get(name=sentence_list[rid])
        s_id=getattr(sentence, 'pk')
        re_list.append(s_id)
        re_boolean = True
        dotting_factor = 'dotting_factor'


    s=str(getattr(sentence , 'DE'))

    
    s_words = s.split()
    s_length = len(s_words)
    fac = Paramater.objects.get(name=dotting_factor)
    factor = int(getattr(fac, 'value'))


    if s_length >= factor:
        begin = 0
        round = factor - 1
        missed_words = []
        for i in range(s_length//factor):
            ns_words = s_words[begin:round]

            rid = random.randint(begin, round)
            missed_words = missed_words + [s_words[rid]]
            begin = begin + factor
            round = round + factor
    else:
        missed_words = []
    new_s = ''
    for i in range(0, s_length):
        word = ''
        if s_words[i] in missed_words:
            for k in range(len(s_words[i].replace(',', ''))):
                word = word + '.'
        else:
            word = s_words[i]

        new_s = new_s + ' ' + word
    if getattr(sentence, 'type') == 'vocabulary':
        new_s = '***********'
    rest_count = Sentence.objects.filter(state='hot',revision_number=0).count()


    context = {
        'sentence': sentence,
        'rest_count': rest_count,
        'timer': str((datetime.datetime.now() - start_time)).split('.')[0],
        'font_size': font_size,
        'new_s': new_s,

        

    }
    return render(request, 'index.html', context)

