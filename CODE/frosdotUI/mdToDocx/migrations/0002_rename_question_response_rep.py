# Generated by Django 4.2.3 on 2023-07-21 14:13

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('mdToDocx', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='response',
            old_name='question',
            new_name='rep',
        ),
    ]
