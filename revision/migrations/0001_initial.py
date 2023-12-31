# Generated by Django 4.2.1 on 2023-08-10 12:27

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Arnaba',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200, unique=True)),
                ('DE', models.CharField(max_length=2000, unique=True)),
                ('EN', models.CharField(max_length=2000, unique=True)),
                ('revision_number', models.IntegerField(default=0)),
                ('state', models.CharField(choices=[('hot', 'hot'), ('cold', 'cold')], default='hot', max_length=200)),
                ('type', models.CharField(choices=[('vocabulary', 'vocabulary'), ('expression', 'expression')], default='expression', max_length=200)),
            ],
        ),
    ]
