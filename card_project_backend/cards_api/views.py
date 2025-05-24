from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404 # For CommentListCreateView
from rest_framework import generics, permissions, status # For CommentListCreateView status
from rest_framework.response import Response # For CommentListCreateView
from .serializers import (
    UserRegistrationSerializer, 
    UserSerializer,
    CardSerializer,
    CardCreateUpdateSerializer,
    CommentSerializer,
    ImageUploadSerializer # Import the new serializer
)
from .models import Card, Comment # Import Card and Comment models
from .permissions import IsOwnerOrReadOnly # Import custom permission

from rest_framework.views import APIView # For ImageUploadView
from rest_framework.parsers import MultiPartParser, FormParser # For ImageUploadView
from django.core.files.storage import default_storage # For ImageUploadView
import os # For ImageUploadView filename generation
from uuid import uuid4 # For ImageUploadView filename generation

class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = (permissions.AllowAny,)

    # If you need to handle 'organization' data from the serializer,
    # you might override perform_create or the serializer's create method further.
    # For example, if you had a UserProfile model:
    # def perform_create(self, serializer):
    #     user = serializer.save()
    #     organization = serializer.validated_data.get('organization')
    #     if organization:
    #         UserProfile.objects.create(user=user, organization=organization)

class UserDetailView(generics.RetrieveAPIView):
    serializer_class = UserSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_object(self):
        # Return the currently authenticated user
        return self.request.user

class CardListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return CardCreateUpdateSerializer
        return CardSerializer

    def get_queryset(self):
        # Assuming user has a field/property `default_organization_name` that stores their organization.
        # This needs to be properly defined based on how User-Organization relationship is established.
        # For now, as a placeholder, let's assume it exists.
        # If not, this might list all cards or need adjustment.
        user_organization = getattr(self.request.user, 'default_organization_name', None)
        if user_organization:
            return Card.objects.filter(organization=user_organization).order_by('-updated_at')
        # Fallback: if no organization is associated, return cards owned by user, or adjust as needed
        return Card.objects.filter(owner=self.request.user).order_by('-updated_at')


    def perform_create(self, serializer):
        # Organization can be passed in request data or derived from user profile
        organization = serializer.validated_data.get('organization')
        if not organization:
            # Placeholder: Attempt to get organization from a user profile or similar attribute
            # This needs to be adapted to the actual User model structure for organization
            organization = getattr(self.request.user, 'default_organization_name', 'DefaultOrg') # Fallback
        serializer.save(owner=self.request.user, organization=organization)


class CardDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Card.objects.all()
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrReadOnly]

    # Use get_serializer_class to differentiate between read and update/partial_update
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return CardCreateUpdateSerializer
        return CardSerializer

    # Ensure perform_update and perform_destroy respect IsOwnerOrReadOnly implicitly
    # by how DRF handles permissions with RetrieveUpdateDestroyAPIView.
    # If specific logic for organization on update is needed, override perform_update:
    # def perform_update(self, serializer):
    #     # Logic to handle 'organization' if it's updatable or derived
    #     serializer.save(owner=self.request.user) # Owner should not change on update by non-admin


class CommentListCreateView(generics.ListCreateAPIView):
    serializer_class = CommentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Comment.objects.filter(card_id=self.kwargs['card_pk']).order_by('-created_at')

    def perform_create(self, serializer):
        card = get_object_or_404(Card, pk=self.kwargs['card_pk'])
        # Check if the user has permission to comment on this card (e.g., if card is in their org)
        # For now, assuming if they can see the card (via CardList/Detail), they can comment.
        # More specific permissions can be added here if needed.
        
        comment_text = serializer.validated_data.get('text_content')
        image_url = serializer.validated_data.get('image_url')

        if not comment_text and not image_url:
             # Consider raising serializers.ValidationError if neither is provided
             # For now, returning a response directly for simplicity.
             # In a real app, this validation should be in the serializer.
            return Response(
                {"detail": "Either text_content or image_url is required."},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        comment = serializer.save(author=self.request.user, card=card)

        # Update parent Card
        if comment_text:
            card.latest_comment_summary = comment_text
        elif image_url:
            card.latest_comment_summary = "Image uploaded" # Or store image_url, or a generic message
        
        card.save() # This will also update card.updated_at due to auto_now=True


class ImageUploadView(APIView):
    parser_classes = [MultiPartParser, FormParser]
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = ImageUploadSerializer(data=request.data)
        if serializer.is_valid():
            image_file = serializer.validated_data['image']
            
            # Generate a unique filename
            ext = image_file.name.split('.')[-1]
            filename = f"{uuid4()}.{ext}"
            file_path = os.path.join('uploads', 'images', filename)
            
            saved_path = default_storage.save(file_path, image_file)
            image_url = default_storage.url(saved_path)
            
            return Response({'image_url': image_url}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
