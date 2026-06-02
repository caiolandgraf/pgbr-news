<template>
  <article class="group">
    <div class="flex gap-3">
      <span v-if="position !== undefined" class="mt-0.5 w-6 shrink-0 text-right text-sm font-medium text-zinc-400 dark:text-zinc-600 tabular-nums">
        {{ position }}
      </span>
      <div class="min-w-0 flex-1">
        <Link :href="`/@${article.user.username}/${article.slug}`" class="block">
          <h2 class="text-base font-semibold text-zinc-900 group-hover:text-emerald-600 dark:text-zinc-100 dark:group-hover:text-emerald-400 transition-colors duration-200 leading-snug">
            {{ article.title }}
          </h2>
        </Link>
        <p class="mt-1 text-xs text-zinc-500 dark:text-zinc-500 flex items-center gap-1.5 flex-wrap">
          <span class="relative group cursor-help">
            <span>{{ article.popularity || 0 }} pontos</span>
            <span class="pointer-events-none absolute bottom-full left-1/2 z-50 mb-2 -translate-x-1/2 whitespace-nowrap rounded-lg bg-zinc-800/95 dark:bg-zinc-700/95 px-2.5 py-1.5 text-xs font-semibold text-white shadow-xl opacity-0 transition-opacity duration-200 group-hover:opacity-100 border border-zinc-700/50 dark:border-zinc-600/50">
              +{{ article.upvotes || 0 }} | -{{ article.downvotes || 0 }} ({{ relevance }}% achou relevante)
            </span>
          </span>
          <span>·</span>
          <Link :href="`/@${article.user.username}`" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition-colors">
            @{{ article.user.username }}
          </Link>
          <span>·</span>
          <time :datetime="article.created_at">{{ timeAgo(article.created_at) }}</time>
        </p>
      </div>
    </div>
  </article>
</template>

<script setup>
import { computed } from 'vue'
import { Link } from '@inertiajs/vue3'
import { timeAgo } from '../utils'

const props = defineProps({
  article: {
    type: Object,
    required: true
  },
  position: {
    type: Number,
    default: undefined
  }
})

const relevance = computed(() => {
  const up = props.article.upvotes || 0
  const down = props.article.downvotes || 0
  const total = up + down
  return total > 0 ? Math.round((up / total) * 100) : 0
})
</script>
