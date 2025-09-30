from django import forms
from .models import Employee


class EmployeeForm(forms.ModelForm):
    image_file = forms.FileField(required=False)

    class Meta:
        model = Employee
        fields = ["name", "email", "role", "join_date"]
