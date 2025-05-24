from django.contrib.auth.models import User
from rest_framework import serializers

class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    organization = serializers.CharField(write_only=True, required=False) # Assuming organization is handled by view or a signal

    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'organization')

    def create(self, validated_data):
        # The 'organization' field is in validated_data if provided.
        # For now, we're not directly saving it to the User model here.
        # This could be handled in the view, or by a signal, or by a custom User model.
        organization = validated_data.pop('organization', None) # Remove it so User.objects.create_user doesn't complain
        
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''), # email is optional in default User model
            password=validated_data['password']
        )
        # If you had a UserProfile model linked to User:
        # if organization:
        #     UserProfile.objects.create(user=user, organization=organization)
        return user

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email')
        # If 'organization' were part of a UserProfile or extended User model,
        # you could add it here, e.g., organization = serializers.CharField(source='userprofile.organization', read_only=True)

from .models import Card, Comment

class CommentSerializer(serializers.ModelSerializer):
    author_username = serializers.CharField(source='author.username', read_only=True)

    class Meta:
        model = Comment
        fields = ('id', 'author_username', 'text_content', 'image_url', 'created_at')

class CardSerializer(serializers.ModelSerializer):
    owner_username = serializers.CharField(source='owner.username', read_only=True)
    comments = CommentSerializer(many=True, read_only=True)

    class Meta:
        model = Card
        fields = ('id', 'owner_username', 'organization', 'type', 'status', 
                  'latest_comment_summary', 'created_at', 'updated_at', 'comments')

class CardCreateUpdateSerializer(serializers.ModelSerializer):
    # organization can be set based on the user profile or explicitly passed.
    # If it's always derived from the user, it could be read_only=True or excluded
    # and set in the view's perform_create/perform_update.
    # For now, allowing it to be passed explicitly or derived in view.
    organization = serializers.CharField(required=False) 

    class Meta:
        model = Card
        fields = ('type', 'status', 'organization')

class ImageUploadSerializer(serializers.Serializer):
    image = serializers.ImageField()
