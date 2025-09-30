import base64
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse, HttpResponseRedirect
from .models import Employee
from .forms import EmployeeForm


def landing_page(request):
    return render(request, "employees/landing.html")


def signup_view(request):
    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect("signin")
    else:
        form = UserCreationForm()
    return render(request, "employees/signup.html", {"form": form})


def signin_view(request):
    if request.method == "POST":
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect("employee_list")
    else:
        form = AuthenticationForm()
    return render(request, "employees/signin.html", {"form": form})


def signout_view(request):
    logout(request)
    return redirect("landing")


@login_required
def employee_list(request):
    employees = Employee.objects.all()
    return render(request, "employees/employee_list.html", {"employees": employees})


@login_required
def employee_create(request):
    if request.method == "POST":
        form = EmployeeForm(request.POST, request.FILES)
        if form.is_valid():
            employee = form.save(commit=False)
            image_file = request.FILES.get("image")  # file from form
            print("image_file", image_file)
            if image_file:
                # Convert file to Base64
                employee.image = base64.b64encode(image_file.read()).decode('utf-8')
            employee.save()
            return redirect("employee_list")
    else:
        form = EmployeeForm()
    return render(request, "employees/partials/create_form.html", {"form": form})


@login_required
def employee_update(request, pk):
    employee = get_object_or_404(Employee, pk=pk)
    if request.method == "POST":
        form = EmployeeForm(request.POST, request.FILES, instance=employee)
        if form.is_valid():
            employee = form.save(commit=False)
            image_file = request.FILES.get("image_file")
            if image_file:
                employee.image = base64.b64encode(image_file.read()).decode('utf-8')
            employee.save()
            return redirect("employee_list")
    else:
        form = EmployeeForm(instance=employee)
    return render(request, "employees/partials/edit_form.html", {"form": form, "employee": employee})


@login_required
def employee_delete(request, pk):
    employee = get_object_or_404(Employee, pk=pk)
    if request.method == "POST":
        employee.delete()
        return redirect("employee_list")
    return render(request, "employees/partials/delete_confirm.html", {"employee": employee})
