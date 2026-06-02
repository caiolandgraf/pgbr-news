<template>
  <AppLayout>
    <div class="space-y-8 animate-fade-in">
      <header class="border-b border-zinc-200 pb-6 dark:border-zinc-800">
        <div class="flex flex-wrap items-start justify-between gap-4">
          <div>
            <h1 class="text-2xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">
              @{{ profileUser.username }}
            </h1>
            <p v-if="profileUser.name" class="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
              {{ profileUser.name }}
            </p>
            <p class="mt-2 text-xs text-zinc-500 dark:text-zinc-500">
              {{ articlesCountText }} · membro desde {{ formattedJoinedDate }}
            </p>
          </div>

          <Link 
            v-if="isOwner" 
            :href="`/@${profileUser.username}/edit`"
            class="rounded-lg border border-zinc-300 bg-white px-4 py-2 text-sm font-medium text-zinc-700 shadow-sm hover:bg-zinc-50 dark:border-zinc-700 dark:bg-zinc-900 dark:text-zinc-200 dark:hover:bg-zinc-800 transition-colors"
          >
            Editar perfil
          </Link>
        </div>

        <div v-if="profileUser.bio" class="mt-6">
          <MarkdownViewer :value="profileUser.bio" />
        </div>
        <div v-else class="mt-6 text-sm text-zinc-500 dark:text-zinc-400 italic">
          <template v-if="isOwner">
            Você ainda não escreveu uma bio.
            <Link :href="`/@${profileUser.username}/edit`" class="text-emerald-600 hover:underline dark:text-emerald-400 font-semibold">Adicionar agora</Link>.
          </template>
          <template v-else>
            Este usuário ainda não adicionou uma bio.
          </template>
        </div>
      </header>

      <section>
        <h2 class="mb-4 text-lg font-semibold text-zinc-900 dark:text-zinc-100">Publicações</h2>

        <ol v-if="articles && articles.length > 0" class="list-none space-y-5 p-0 m-0">
          <li v-for="(article, index) in articles" :key="article.id">
            <ArticleCard :article="article" :position="index + 1" />
          </li>
        </ol>
        <p v-else class="text-sm text-zinc-500 dark:text-zinc-400">
          <template v-if="isOwner">
            Você ainda não publicou nada.
            <Link href="/articles/new" class="text-emerald-600 hover:underline dark:text-emerald-400 font-semibold">Criar primeira publicação</Link>.
          </template>
          <template v-else>
            Nenhuma publicação ainda.
          </template>
        </p>
      </section>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed } from 'vue'
import { usePage, Link } from '@inertiajs/vue3'
import AppLayout from '../../Layouts/AppLayout.vue'
import ArticleCard from '../../Components/ArticleCard.vue'
import MarkdownViewer from '../../Components/MarkdownViewer.vue'

const props = defineProps({
  profileUser: {
    type: Object,
    required: true
  },
  articles: {
    type: Array,
    default: () => []
  }
})

const { props: pageProps } = usePage()
const currentUser = computed(() => pageProps.currentUser)

const isOwner = computed(() => {
  return currentUser.value && currentUser.value.id === props.profileUser.id
})

const articlesCountText = computed(() => {
  const count = props.articles.length
  return count === 1 ? '1 publicação' : `${count} publicações`
})

const formattedJoinedDate = computed(() => {
  if (!props.profileUser.created_at) return ''
  const date = new Date(props.profileUser.created_at)
  const day = String(date.getDate()).padStart(2, '0')
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const year = date.getFullYear()
  return `${day}/${month}/${year}`
})
</script>
