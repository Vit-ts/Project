# Generated by Django 3.0.13 on 2021-03-07 02:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blog', '0004_auto_20210307_0508'),
    ]

    operations = [
        migrations.AlterField(
            model_name='post',
            name='image',
            field=models.ImageField(default='/static/images/d.png', upload_to='images/'),
        ),
    ]