<template>
  <div
    :id="'comment-' + comment.id"
    class="flex gap-4 article-comment rounded-md p-4 transition-all duration-200"
  >
    <!-- Left Column: Collapse button and Up/Down Vote buttons -->
    <div class="flex flex-col items-center gap-1 flex-shrink-0 w-8">
      <template v-if="!collapsed">
        <button
          @click="vote(true)"
          :disabled="comment.deleted"
          class="comment-vote-button text-sm text-zinc-500 rounded-lg p-2 transition flex items-center justify-center cursor-pointer hover:dark:bg-white/5 hover:bg-black/5 disabled:opacity-40 disabled:cursor-not-allowed disabled:pointer-events-none"
          title="Votar relevante"
        >
          <ChevronUp class="w-4 h-4" />
        </button>

        <span
          class="comment-score text-sm font-semibold select-none"
          :class="scoreColorClass"
        >
          <template v-if="comment.deleted">
            <span class="text-zinc-500 dark:text-zinc-400">
              -
            </span>
          </template>
          <template v-else>
            <span class="relative group cursor-help">
              <span class="text-emerald-600">{{ comment.popularity || 0 }}</span>
              <span
                class="pointer-events-none absolute left-full top-1/2 z-50 ml-2 -translate-y-1/2 whitespace-nowrap rounded-lg bg-zinc-800/95 dark:bg-zinc-700/95 px-2.5 py-1.5 text-xs font-semibold text-white shadow-xl opacity-0 transition-opacity duration-200 group-hover:opacity-100 border border-zinc-700/50 dark:border-zinc-600/50"
              >
                +{{ comment.upvotes || 0 }} | -{{ comment.downvotes || 0 }} ({{ relevance }}% achou relevante)
              </span>
            </span>
          </template>
        </span>

        <button
          @click="vote(false)"
          :disabled="comment.deleted"
          class="comment-vote-button text-sm text-zinc-500 rounded-lg p-2 transition flex items-center justify-center cursor-pointer hover:dark:bg-white/5 hover:bg-black/5 disabled:opacity-40 disabled:cursor-not-allowed disabled:pointer-events-none"
          title="Votar não relevante"
        >
          <ChevronDown class="w-4 h-4" />
        </button>
      </template>
    </div>

    <!-- Right Column: Content -->
    <div class="flex-1 min-w-0">
      <!-- Meta Row -->
      <div class="comment-meta text-sm text-zinc-400 flex items-center gap-2 flex-wrap">
        <Link
          :href="`/@${comment.user.username}`"
          class="inline-block bg-emerald-900/10 dark:bg-emerald-900/20 text-zinc-700 dark:text-zinc-400 font-mono text-xs px-1.5 py-0.5 rounded-md no-underline whitespace-nowrap break-words"
        >
          <span
            class="font-mono text-xs text-emerald-600 no-underline underline-offset-1 whitespace-nowrap break-words italic-0 shadow-none outline-none not-italic"
          >
            @{{ comment.user.username }}
          </span>
        </Link>

        <span
          v-if="comment.user.id === article.user.id"
          class="dark:bg-emerald-900/10 bg-emerald-100/10 dark:text-emerald-400 text-emerald-500 border dark:border-emerald-700 border-emerald-500 px-2.5 py-0.5 rounded-full text-[10px] font-bold tracking-wide uppercase"
        >
          Autor
        </span>

        <span>·</span>
        <span>{{ timeAgo(comment.created_at) }}</span>

        <template v-if="!comment.deleted && currentUser && comment.user.id === currentUser.id">
          <span>·</span>
          <button
            @click="destroyComment"
            class="text-sm text-zinc-400 flex items-center gap-1 justify-center cursor-pointer hover:text-red-500 transition-colors duration-200"
          >
            Excluir comentário
          </button>
        </template>
      </div>

      <template v-if="!collapsed">
        <!-- Comment Body -->
        <div class="comment-body mt-2 text-zinc-800 dark:text-zinc-200 leading-relaxed text-sm">
          <template v-if="comment.deleted">
            <span class="italic text-zinc-500">comentário excluído</span>
          </template>
          <template v-else>
            <div
              v-html="formatBody(comment.body)"
              class="prose prose-sm dark:prose-invert max-w-none"
            ></div>
          </template>
        </div>

        <!-- Action buttons: Responder & Share -->
        <div
          v-if="!comment.deleted"
          class="mt-3 flex gap-2 items-center"
        >
          <button
            @click="handleReplyClick"
            class="bg-zinc-100 hover:bg-zinc-200 dark:bg-[#21262d] dark:hover:bg-[#30363d] text-zinc-800 dark:text-zinc-200 border border-zinc-300 dark:border-[#30363d] hover:border-zinc-400 dark:hover:border-zinc-500 rounded px-3 py-1.5 text-xs font-semibold flex items-center justify-center transition-all duration-150 cursor-pointer"
          >
            Responder
          </button>
          <button
            @click="shareComment"
            class="bg-zinc-100 hover:bg-zinc-200 dark:bg-[#21262d] dark:hover:bg-[#30363d] text-zinc-800 dark:text-zinc-200 border border-zinc-300 dark:border-[#30363d] hover:border-zinc-400 dark:hover:border-zinc-500 rounded p-1.5 text-xs font-semibold flex items-center justify-center transition-all duration-150 cursor-pointer"
            title="Compartilhar"
          >
            <Share2 class="w-3.5 h-3.5" />
          </button>
          <span
            v-if="copiedCommentLink"
            class="text-xs text-emerald-500 flex items-center animate-fade-in"
          >
            Link copiado!
          </span>
        </div>

        <!-- Reply form -->
        <div
          v-if="showReplyForm && currentUser"
          class="mt-3 max-w-2xl animate-fade-in"
        >
          <form
            @submit.prevent="submitReply"
            class="flex flex-col gap-2"
          >
            <MarkdownField
              v-model="replyBody"
              :max-length="20000"
              :compact="true"
              :required="true"
            />
            <div class="flex gap-2">
              <button
                type="submit"
                class="bg-emerald-600 hover:bg-emerald-500 text-white rounded px-3 py-1.5 text-xs font-semibold cursor-pointer transition"
              >
                Enviar
              </button>
              <button
                type="button"
                @click="showReplyForm = false"
                class="bg-zinc-800 hover:bg-zinc-700 text-zinc-200 border border-zinc-700 rounded px-3 py-1.5 text-xs font-semibold cursor-pointer transition"
              >
                Cancelar
              </button>
            </div>
          </form>
        </div>

        <!-- Children recursive container (TabNews style with interactive dotted thread line) -->
        <template v-if="comment.children && comment.children.length > 0">
          <div
            v-if="!repliesCollapsed"
            :class="comment.depth > 0 ? 'mt-12 flex gap-4 -ml-12' : 'mt-4 flex gap-4 -ml-12'"
          >
            <!-- Interactive Dotted Thread Line Column (width w-8, centered) -->
            <div
              @click="toggleRepliesCollapse"
              class="group cursor-pointer relative w-8 flex justify-center flex-shrink-0 "
              title="Ocultar respostas"
            >
              <span
                class="pointer-events-none absolute left-full top-0 z-50 ml-2 whitespace-nowrap rounded-lg bg-zinc-800/95 dark:bg-zinc-700/95 px-2.5 py-1.5 text-xs font-semibold text-white shadow-xl opacity-0 transition-opacity duration-200 group-hover:opacity-100 border border-zinc-700/50 dark:border-zinc-600/50"
              >
                Ocultar respostas
              </span>

              <!-- Dotted vertical line -->
              <div
                class="h-full border-l-2 border-dotted border-zinc-300 dark:border-zinc-800 group-hover:border-red-500 dark:group-hover:border-red-500 transition-colors"
              ></div>

              <!-- Double-arrow dotted icon appearing at the top of the line on hover -->
              <div
                class="opacity-0 group-hover:opacity-100 absolute z-10 flex items-center justify-center bg-white dark:bg-[#0d1117] text-red-500 transition-opacity duration-150 rounded-full border border-red-500 p-0.5 shadow-sm"
              >
                <ChevronsUpDown class="w-4 h-4" />
              </div>
            </div>

            <!-- Children list -->
            <div class="flex-1 min-w-0 space-y-6">
              <Comment
                v-for="child in comment.children"
                :key="child.id"
                :comment="child"
                :article="article"
                :currentUser="currentUser"
              />
            </div>
          </div>

          <div
            v-else
            class="mt-4"
          >
            <button
              @click="toggleRepliesCollapse"
              class="inline-flex items-center gap-2 text-sky-500 hover:text-sky-400 font-semibold text-xs py-1 transition cursor-pointer group"
            >
              <!-- Blue double-arrow dotted icon -->
              <span class="text-sky-500 group-hover:scale-110 transition-transform">
                <ChevronsUpDown class="w-5 h-5" />
              </span>
              Ver mais {{ totalRepliesCount }} {{ totalRepliesCount === 1 ? 'resposta' : 'respostas' }}
            </button>
          </div>
        </template>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { ChevronUp, ChevronDown, Share2, ChevronsUpDown } from '@lucide/vue';
import { timeAgo } from '../utils';
import MarkdownField from './MarkdownField.vue';
import Comment from './Comment.vue'; // self import

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

const collapsed = ref(false)
const repliesCollapsed = ref(false)
const showReplyForm = ref(false)
const replyBody = ref('')
const copiedCommentLink = ref(false)

const scoreColorClass = computed(() => {
  const pop = props.comment.popularity || 0
  if (pop > 0) return 'text-emerald-500 dark:text-emerald-400'
  if (pop < 0) return 'text-red-500 dark:text-red-400'
  return 'text-zinc-500 dark:text-zinc-400'
})

const toggleCollapse = () => {
  collapsed.value = !collapsed.value
}

const toggleRepliesCollapse = () => {
  repliesCollapsed.value = !repliesCollapsed.value
}

const countReplies = (comment) => {
  if (!comment.children || comment.children.length === 0) return 0
  return comment.children.reduce((acc, child) => acc + 1 + countReplies(child), 0)
}

const totalRepliesCount = computed(() => {
  return countReplies(props.comment)
})

const handleReplyClick = () => {
  if (!props.currentUser) {
    router.visit('/login')
  } else {
    showReplyForm.value = !showReplyForm.value
  }
}

const shareComment = () => {
  const url = `${window.location.origin}/@${props.article.user.username}/${props.article.slug}#comment-${props.comment.id}`
  navigator.clipboard.writeText(url).then(() => {
    copiedCommentLink.value = true
    setTimeout(() => {
      copiedCommentLink.value = false
    }, 2000)
  })
}

const vote = (up) => {
  const url = `/@${props.article.user.username}/${props.article.slug}/comments/${props.comment.id}/vote`
  router.patch(url, { up }, {
    preserveScroll: true
  })
}

const destroyComment = () => {
  if (confirm('Tem certeza que deseja excluir este comentário?')) {
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

<style>
/* Evita que comentários pais mantenham o hover background quando um filho está sob hover */
.article-comment:has(.article-comment) {
  background-color: transparent !important;
}
</style>
