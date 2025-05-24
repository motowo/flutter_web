from django.urls import path
from . import views

urlpatterns = [
    path('auth/register/', views.UserRegistrationView.as_view(), name='user-register'),
    path('auth/user/', views.UserDetailView.as_view(), name='user-detail'),
    
    # Card URLs
    path('cards/', views.CardListCreateView.as_view(), name='card-list-create'),
    path('cards/<int:pk>/', views.CardDetailView.as_view(), name='card-detail'),
    
    # Comment URLs (nested under cards)
    path('cards/<int:card_pk>/comments/', views.CommentListCreateView.as_view(), name='comment-list-create'),
    
    # Image Upload URL
    path('media/upload/', views.ImageUploadView.as_view(), name='image-upload'),
]
