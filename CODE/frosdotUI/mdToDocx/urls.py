from django.urls import path

from . import views

app_name = "queries"
urlpatterns = [
        # e.g. /mdToDocx
        path("", views.index, name="index"),
        # e.g. /mdToDocx/1/
        path("<int:query_id>/", views.detail, name="detail"),
        # e.g. /mdToDocx/1/results/
        path("<int:query_id>/results/", views.results, name="results"),
        # e.g. /mdToDocx/1/mark/
        path("<int:query_id>/mark/", views.mark, name="marks"),
        ]
