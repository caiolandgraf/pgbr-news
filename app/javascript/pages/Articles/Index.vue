<template>
  <AppLayout>
    <div v-if="featuredArticle" class="mb-8 border-b border-zinc-200 pb-6 dark:border-zinc-800 animate-fade-in">
      <Link :href="`/@${featuredArticle.user.username}/${featuredArticle.slug}`" class="group block">
        <h2 class="text-xl font-bold text-emerald-600 group-hover:text-emerald-500 dark:text-emerald-400 dark:group-hover:text-emerald-300 transition-colors duration-200">
          {{ featuredArticle.title }}
        </h2>
        <p class="mt-2 text-sm text-zinc-600 dark:text-zinc-400 line-clamp-2 leading-relaxed">
          {{ truncate(featuredArticle.body, 160) }}
        </p>
      </Link>
      <p class="mt-3 text-xs text-zinc-500 dark:text-zinc-500 flex items-center gap-1.5 flex-wrap">
        <span>{{ featuredArticle.popularity || 0 }} pontos</span>
        <span>·</span>
        <Link :href="`/@${featuredArticle.user.username}`" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition-colors font-medium">
          @{{ featuredArticle.user.username }}
        </Link>
        <span>·</span>
        <time :datetime="featuredArticle.created_at">{{ timeAgo(featuredArticle.created_at) }}</time>
      </p>
    </div>

    <ol v-if="articles && articles.length > 0" class="list-none space-y-5 p-0 m-0" id="articles">
      <li v-for="(article, index) in articles" :key="article.id" class="animate-fade-in" :style="{ animationDelay: `${index * 50}ms` }">
        <ArticleCard :article="article" :position="index + 2" />
      </li>
    </ol>

    <div v-if="!featuredArticle && (!articles || articles.length === 0)" class="py-12 text-center text-zinc-500 dark:text-zinc-400 animate-fade-in">
      <p class="text-sm">Nenhum artigo ainda.</p>
      <p v-if="currentUser" class="mt-2 text-sm">
        <Link href="/articles/new" class="text-emerald-600 hover:underline dark:text-emerald-400 font-semibold">Seja o primeiro a publicar</Link>.
      </p>
      <p v-else class="mt-2 text-sm">
        <Link href="/users/new" class="text-emerald-600 hover:underline dark:text-emerald-400 font-semibold">Cadastre-se</Link> para publicar.
      </p>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed } from 'vue'
import { Link, usePage } from '@inertiajs/vue3'
import AppLayout from '../../Layouts/AppLayout.vue'
import ArticleCard from '../../Components/ArticleCard.vue'
import { timeAgo } from '../../utils'

defineProps({
  featuredArticle: {
    type: Object,
    default: null
  },
  articles: {
    type: Array,
    default: () => []
  }
})

const { props: pageProps } = usePage()
const currentUser = computed(() => pageProps.currentUser)

const truncate = (text, length) => {
  if (!text) return ''
  if (text.length <= length) return text
  return text.substring(0, length) + '...'
}
</script>
