# Generated by Django 4.2.1 on 2023-09-09 04:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('revision', '0007_alter_paramater_name'),
    ]

    operations = [
        migrations.AlterField(
            model_name='paramater',
            name='name',
            field=models.CharField(max_length=200, unique=True),
        ),
        migrations.AlterField(
            model_name='paramater',
            name='value',
            field=models.CharField(max_length=99999),
        ),
    ]
