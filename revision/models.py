from django.db import models

# Create your models here.
class Sentence(models.Model):
    TYPE_CHOICES = (
        ('vocabulary', 'vocabulary'),
        ('expression', 'expression'),
    )

    STATE_CHOICES = (
        ('hot', 'hot'),
        ('cold', 'cold'),
    )

    def __str__(self):
        return self.name
    
    name = models.CharField(max_length=200,unique=True)
    DE = models.CharField(max_length=2000)
    EN = models.CharField(max_length=2000)
    part = models.CharField(max_length=2000)
    category = models.CharField(max_length=2000, default='splitted')
    revision_number = models.IntegerField(default=0)
    state = models.CharField(max_length=200, choices= STATE_CHOICES, default='hot')
    type = models.CharField(max_length=200, choices= TYPE_CHOICES, default='expression')

    
class Index(models.Model):
    STATE_CHOICES = (
        ('pending', 'pending'),
        ('injected', 'injected'),
    )

    def __str__(self):
     return self.name
    
    name = models.CharField(max_length=200,unique=True)
    state = models.CharField(max_length=200, choices= STATE_CHOICES, default='pending')
    time_of_injection = models.DateTimeField(null=True, blank=True)


class Paramater(models.Model):
    def __str__(self):
     return self.name
    name = models.CharField(max_length=200,unique=True)

    value = models.CharField(max_length=200)
