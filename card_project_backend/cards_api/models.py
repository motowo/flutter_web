from django.db import models
from django.contrib.auth.models import User

class Card(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    organization = models.CharField(max_length=255, help_text="Organization of the owner at the time of card creation")
    type = models.CharField(max_length=100)
    status = models.CharField(max_length=100)
    latest_comment_summary = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.type} - {self.status} (Owner: {self.owner.username})"

class Comment(models.Model):
    card = models.ForeignKey(Card, related_name='comments', on_delete=models.CASCADE)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    text_content = models.TextField(blank=True, null=True)
    image_url = models.URLField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        if self.text_content:
            return f"Comment by {self.author.username} on {self.card.id}: {self.text_content[:50]}..."
        elif self.image_url:
            return f"Image comment by {self.author.username} on {self.card.id}: {self.image_url}"
        return f"Comment by {self.author.username} on {self.card.id}"
