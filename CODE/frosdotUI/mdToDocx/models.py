import datetime

from django.db import models
from django.utils import timezone

class Query(models.Model):
    query_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField("date published")
    def __str__(self):
        return self.query_text
    def was_published_recently(self):
        return self.pub_date >= timezone.now() - datetime.timedelta(days=1)

class Response(models.Model):
    question = models.ForeignKey(Query, on_delete=models.CASCADE)
    response_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
    def __str__(self):
        return self.choice_text
