from django.contrib import admin
from .models import Card, Comment

@admin.register(Card)
class CardAdmin(admin.ModelAdmin):
    list_display = ('id', 'owner', 'organization', 'type', 'status', 'updated_at', 'created_at')
    list_filter = ('status', 'type', 'organization', 'owner', 'created_at', 'updated_at')
    search_fields = ('type', 'status', 'organization', 'owner__username', 'latest_comment_summary')
    readonly_fields = ('created_at', 'updated_at')

@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('id', 'card', 'author', 'text_content_summary', 'image_url', 'created_at')
    list_filter = ('author', 'created_at')
    search_fields = ('text_content', 'author__username', 'card__id')
    readonly_fields = ('created_at',)

    def text_content_summary(self, obj):
        if obj.text_content:
            return obj.text_content[:50] + '...' if len(obj.text_content) > 50 else obj.text_content
        return None
    text_content_summary.short_description = 'Text Content'
