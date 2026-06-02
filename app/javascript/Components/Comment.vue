<template>
  <div class="flex gap-4 article-comment rounded-md p-4 transition-all duration-200 hover:bg-zinc-50/50 dark:hover:bg-zinc-900/30">
    <div class="flex flex-col items-center gap-1">
      <button 
        @click="vote(true)"
        :disabled="comment.deleted"
        class="comment-vote-button text-sm text-zinc-500 rounded-lg p-2 transition flex items-center gap-2 justify-center cursor-pointer hover:dark:bg-white/5 hover:bg-black/5 disabled:opacity-40 disabled:cursor-not-allowed disabled:pointer-events-none"
      >
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="m18 15-6-6-6 6" />
        </svg>
      </button>

      <span class="comment-score text-sm font-semibold">
        <template v-if="comment.deleted">
          <span class="italic text-zinc-500">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </span>
        </template>
        <template v-else>
          <div class="relative group cursor-help flex justify-center items-center">
            {{ comment.popularity }}
            <div class="pointer-events-none absolute bottom-full left-1/2 z-50 mb-2 -translate-x-1/2 whitespace-nowrap rounded-lg bg-zinc-800/95 dark:bg-zinc-700/95 px-2.5 py-1.5 text-xs font-semibold text-white shadow-xl opacity-0 transition-opacity duration-200 group-hover:opacity-100 border border-zinc-700/50 dark:border-zinc-600/50">
              +{{ comment.upvotes || 0 }} | -{{ comment.downvotes || 0 }} ({{ relevance }}% achou relevante)
            </div>
          </div>
        </template>
      </span>

      <button 
        @click="vote(false)"
        :disabled="comment.deleted"
        class="comment-vote-button text-sm text-zinc-500 rounded-lg p-2 transition flex items-center gap-2 justify-center cursor-pointer hover:dark:bg-white/5 hover:bg-black/5 disabled:opacity-40 disabled:cursor-not-allowed disabled:pointer-events-none"
      >
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="m6 9 6 6 6-6" />
        </svg>
      </button>

      <div v-if="comment.children && comment.children.length > 0" class="w-px flex-1 bg-zinc-300 dark:bg-zinc-800 mt-2"></div>
    </div>

    <div class="flex-1">
      <div class="comment-meta text-sm text-zinc-400 flex items-center gap-2">
        <span class="comment-author font-medium">@{{ comment.user.username }}</span>
        <span>·</span>
        <span>{{ timeAgo(comment.created_at) }}</span>
        <template v-if="!comment.deleted && currentUser && comment.user.id === currentUser.id">
          <span>·</span>
          <button 
            @click="destroyComment"
            class="text-sm text-zinc-400 flex items-center gap-1 justify-center cursor-pointer hover:text-red-500 transition-colors duration-200"
          >
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
            Excluir comentário
          </button>
        </template>
      </div>

      <div class="comment-body mt-2 text-zinc-800 dark:text-zinc-200 leading-relaxed text-sm">
        <template v-if="comment.deleted">
          <span class="italic text-zinc-500">comentário excluído</span>
        </template>
        <template v-else>
          <div v-html="formatBody(comment.body)" class="prose prose-sm dark:prose-invert max-w-none"></div>
        </template>
      </div>

      <template v-if="!comment.deleted && currentUser">
        <button 
          @click="showReplyForm = !showReplyForm"
          class="comment-reply-button mt-3 inline-flex items-center gap-2 rounded-md border border-zinc-200 dark:border-zinc-700 px-3 py-1 text-xs transition cursor-pointer hover:bg-zinc-100 dark:hover:bg-zinc-800"
        >
          Responder
        </button>

        <div v-if="showReplyForm" class="mt-3">
          <form @submit.prevent="submitReply" class="flex flex-col gap-2">
            <MarkdownField 
              v-model="replyBody"
              :max-length="20000"
              :compact="true"
              :required="true"
            />
            <button 
              type="submit"
              class="w-fit rounded-lg border border-emerald-500 px-3 py-1 text-sm text-emerald-500 cursor-pointer hover:bg-emerald-500 hover:text-white transition"
            >
              Enviar
            </button>
          </form>
        </div>
      </template>

      <div v-if="comment.children && comment.children.length > 0" class="mt-6 space-y-6 border-l border-zinc-200 dark:border-zinc-800 pl-4 sm:pl-6">
        <Comment 
          v-for="child in comment.children" 
          :key="child.id" 
          :comment="child" 
          :article="article" 
          :currentUser="currentUser" 
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { router } from '@inertiajs/vue3'
import { timeAgo } from '../utils'
import MarkdownField from './MarkdownField.vue'
import Comment from './Comment.vue' // self import

const relevance = computed(() => {
  const up = props.comment.upvotes || 0
  const down = props.comment.downvotes || 0
  const total = up + down
  return total > 0 ? Math.round((up / total) * 100) : 0
})

const props = defineProps({
  comment: {
    type: Object,
    required: true
  },
  article: {
    type: Object,
    required: true
  },
  currentUser: {
    type: Object,
    default: null
  }
})

const showReplyForm = ref(false)
const replyBody = ref('')

const vote = (up) => {
  const url = `/@${props.article.user.username}/${props.article.slug}/comments/${props.comment.id}/vote`
  router.patch(url, { up }, {
    preserveScroll: true
  })
}

const destroyComment = () => {
  if (confirm('Tem certeza?')) {
    const url = `/@${props.article.user.username}/${props.article.slug}/comments/${props.comment.id}/cancel`
    router.delete(url, {
      preserveScroll: true
    })
  }
}

const submitReply = () => {
  if (!replyBody.value.trim()) return

  const url = `/@${props.article.user.username}/${props.article.slug}/comments/${props.comment.id}/comments`
  router.post(url, {
    article_comment: {
      body: replyBody.value
    }
  }, {
    preserveScroll: true,
    onSuccess: () => {
      replyBody.value = ''
      showReplyForm.value = false
    }
  })
}

const formatBody = (text) => {
  if (!text) return ''
  // escape HTML to avoid XSS, then split paragraphs
  const escaped = text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;')
  
  return escaped
    .split(/\n\n+/)
    .map(p => `<p class="mb-2 last:mb-0">${p.replace(/\n/g, '<br>')}</p>`)
    .join('')
}
</script>
