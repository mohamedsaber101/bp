
from django.urls import path
from . import views
app_name = 'revision'
urlpatterns = [
    path('', views.regular_dotting, name='index'),
    path('random/', views.random_hot, name='random_hot'),
    path('dotting/', views.dotting, name='dotting'),
    path('regular_dotting/', views.regular_dotting, name='regular_dotting'),

    path('repeat/', views.repeat, name='repeat'),
    path('inject/', views.inject, name='inject'),
    path('vocabulary/', views.vocabulary, name='vocabulary'),
    path('set_timer/(?P<mode>.+)/', views.set_timer, name='set_timer'),


    path('delete/<int:id>/', views.delete, name='delete'),

    path('promote/<int:id>/', views.promote, name='promote'),
    path('pr/<int:id>/', views.demote, name='demote'),




]