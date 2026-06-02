<template>
  <AppLayout>
    <div v-if="errors && errors.length > 0" class="mb-4 rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-800 dark:border-red-900/60 dark:bg-red-950/50 dark:text-red-200 animate-fade-in">
      <p class="font-medium">Erro ao salvar:</p>
      <ul class="mt-1 list-inside list-disc">
        <li v-for="err in errors" :key="err">{{ err }}</li>
      </ul>
    </div>

    <div class="flex gap-4 animate-fade-in">
      <!-- Article Vote Column -->
      <div class="flex items-center flex-col gap-4">
        <button 
          @click="vote(true)"
          class="text-sm text-zinc-500 rounded-lg p-2 hover:dark:bg-white/5 hover:bg-black/5 transition cursor-pointer flex items-center gap-2 justify-center"
          aria-label="Votar positivo"
        >
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="m18 15-6-6-6 6" />
          </svg>
        </button>

        <span class="text-sm text-emerald-500 font-semibold">
          {{ article.popularity }}
        </span>

        <button 
          @click="vote(false)"
          class="text-sm text-zinc-500 rounded-lg p-2 hover:dark:bg-white/5 hover:bg-black/5 transition cursor-pointer flex items-center gap-2 justify-center"
          aria-label="Votar negativo"
        >
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="m6 9 6 6 6-6" />
          </svg>
        </button>

        <div class="w-[2px] h-full dark:bg-white/10 bg-black/10 rounded-full"></div>
      </div>

      <!-- Article content -->
      <div class="flex-1 min-w-0">
        <article>
          <h1 class="text-4xl font-bold tracking-tight text-zinc-900 dark:text-zinc-100">
            {{ article.title }}
          </h1>

          <p class="mt-2 text-sm text-zinc-500 dark:text-zinc-400 flex items-center gap-1.5 flex-wrap">
            <span>{{ article.popularity || 0 }} pontos</span>
            <span>·</span>
            <Link :href="`/@${article.user.username}`" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition-colors font-medium">
              @{{ article.user.username }}
            </Link>
            <span>·</span>
            <span>{{ timeAgo(article.created_at) }}</span>
          </p>

          <p v-if="article.ref" class="mt-2 text-sm">
            <a :href="article.ref" target="_blank" rel="noopener noreferrer" class="text-emerald-600 hover:underline dark:text-emerald-400 font-medium">
              Fonte
            </a>
          </p>

          <div class="mt-6">
            <MarkdownViewer :value="article.body" />
          </div>
        </article>
      </div>
    </div>

    <!-- Actions bar -->
    <div class="mt-10 flex flex-wrap gap-3 border-t border-zinc-200 pt-6 dark:border-zinc-800 animate-fade-in">
      <Link href="/" class="text-sm rounded-lg border border-emerald-500 text-emerald-500 px-3 py-1.5 hover:bg-emerald-500 hover:text-white transition duration-200 cursor-pointer flex items-center gap-2 justify-center">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="m12 19-7-7 7-7m14 7H5" />
        </svg>
        Voltar
      </Link>

      <template v-if="currentUser && currentUser.id === article.user.id">
        <Link :href="`/@${article.user.username}/${article.slug}/edit`" class="text-sm border border-blue-500 rounded-lg bg-blue-500 text-white px-3 py-1.5 hover:bg-blue-400 hover:border-blue-400 transition duration-200 cursor-pointer flex items-center gap-2 justify-center">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10" />
          </svg>
          Editar
        </Link>
        
        <button @click="destroyArticle" class="text-sm border border-red-500 rounded-lg bg-red-500 text-white px-3 py-1.5 hover:bg-red-400 hover:border-red-400 transition duration-200 cursor-pointer flex items-center gap-2 justify-center">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
          Excluir
        </button>
      </template>
    </div>

    <!-- Comments Section -->
    <div class="mt-10 animate-fade-in">
      <h2 class="mb-6 text-xl font-bold">
        Comentários
      </h2>

      <!-- Comment Submission Form -->
      <div v-if="currentUser" class="mb-10">
        <form @submit.prevent="submitComment" class="flex flex-col gap-2">
          <MarkdownField 
            v-model="commentBody"
            :max-length="20000"
            :required="true"
            :error="commentErrors?.join(', ')"
          />
          <button 
            type="submit"
            class="w-fit rounded-lg border border-emerald-500 px-4 py-2 text-emerald-500 cursor-pointer hover:bg-emerald-500 hover:text-white transition duration-200"
          >
            Comentar
          </button>
        </form>
      </div>

      <!-- Nested Comments List -->
      <div class="space-y-8">
        <Comment 
          v-for="comment in comments" 
          :key="comment.id" 
          :comment="comment" 
          :article="article" 
          :currentUser="currentUser" 
        />
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Link, router, usePage } from '@inertiajs/vue3'
import AppLayout from '../../Layouts/AppLayout.vue'
import MarkdownViewer from '../../Components/MarkdownViewer.vue'
import MarkdownField from '../../Components/MarkdownField.vue'
import Comment from '../../Components/Comment.vue'
import { timeAgo } from '../../utils'

const props = defineProps({
  article: {
    type: Object,
    required: true
  },
  comments: {
    type: Array,
    default: () => []
  },
  errors: {
    type: Array,
    default: () => []
  },
  commentErrors: {
    type: Array,
    default: () => []
  }
})

const { props: pageProps } = usePage()
const currentUser = computed(() => pageProps.currentUser)

const commentBody = ref('')

const vote = (up) => {
  const url = `/@${props.article.user.username}/${props.article.slug}/vote`
  router.patch(url, { up }, {
    preserveScroll: true
  })
}

const destroyArticle = () => {
  if (confirm('Tem certeza?')) {
    router.delete(`/articles/${props.article.id}`)
  }
}

const submitComment = () => {
  if (!commentBody.value.trim()) return

  const url = `/@${props.article.user.username}/${props.article.slug}/comments`
  router.post(url, {
    article_comment: {
      body: commentBody.value
    }
  }, {
    preserveScroll: true,
    onSuccess: () => {
      commentBody.value = ''
    }
  })
}
</script>
