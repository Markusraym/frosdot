from django.shortcuts import render, HttpResponse, get_object_or_404
# from django.http import Http404

from .models import Query

def index(request):
    latest_query_list = Query.objects.order_by("-pub_date")[:5]
    context = { "latest_query_list": latest_query_list, }
    return render(request, "mdToDocx/index.html", context)

def detail(request, query_id):
    query = get_object_or_404(Query, pk=query_id)
    return render(request, "mdToDocx/detail.html", {"query": query})

def results(request, query_id):
    response = "Viewing results of query %s."
    return HttpResponse(response % query_id)

def mark(request, query_id):
    return HttpResponse("Mark question %s." % query_id)

