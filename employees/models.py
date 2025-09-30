from django.db import models


class Employee(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=50)
    image = models.TextField(blank=True, null=True)
    join_date = models.DateField()

    def __str__(self):
        return self.name
