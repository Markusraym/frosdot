from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import get_object_or_404, render
from django.urls import reverse
# from django.http import Http404

from .models import Query, Response

def index(request):
    latest_query_list = Query.objects.order_by("-pub_date")[:5]
    context = { "latest_query_list": latest_query_list, }
    return render(request, "mdToDocx/index.html", context)

def detail(request, query_id):
    query = get_object_or_404(Query, pk=query_id)
    return render(request, "mdToDocx/detail.html", {"query": query})

def results(request, query_id):
    query = get_object_or_404(Query, pk=query_id)
    return render(request, "mdToDocx/results.html", {"query": query})

def mark(request, query_id):
    query = get_object_or_404(Query, pk=query_id)
    try:
        selected_choice = query.response_set.get(pk=request.POST["mark"])
    except (KeyError, Response.DoesNotExist):
        # hm!
        return render(
                request,
                "mdToDocx/detail.html",
                {
                    "query": query,
                    "error_message": "No selection.",
                    },
                )
    else:
        selected_choice.votes += 1
        selected_choice.save()
        # back button prevention
        return HttpResponseRedirect(reverse("queries:results", args=(query.id,)))



