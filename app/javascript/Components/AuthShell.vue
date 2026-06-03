<template>
  <AppLayout main-class="max-w-md">
    <div class="flex min-h-[calc(100dvh-12rem)] flex-col justify-center py-8 animate-fade-in">
      <div class="mb-6 text-center">
        <Link href="/" class="inline-flex items-center gap-2 text-zinc-900 hover:text-emerald-600 dark:text-zinc-100 dark:hover:text-emerald-400 transition-colors">
          <Folder class="h-6 w-6 text-emerald-600 dark:text-emerald-400" stroke-width="1.5" />
          <span class="text-lg font-semibold tracking-tight">Blog</span>
        </Link>
      </div>

      <!-- Auth tabs -->
      <nav class="mb-8 flex rounded-lg bg-zinc-200/80 p-1 dark:bg-zinc-800/80" aria-label="Autenticação">
        <Link href="/login" :class="tabClass('login')">Entrar</Link>
        <Link href="/users/new" :class="tabClass('signup')">Criar conta</Link>
      </nav>

      <div class="rounded-xl border border-zinc-200 bg-white p-6 shadow-sm sm:p-8 dark:border-zinc-800 dark:bg-zinc-900/50 dark:shadow-none">
        <slot />
      </div>

      <p class="mt-6 text-center text-xs text-zinc-500 dark:text-zinc-500">
        <Link href="/" class="hover:text-zinc-700 dark:hover:text-zinc-300 transition-colors">← Voltar para o feed</Link>
      </p>
    </div>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
import { Folder } from '@lucide/vue'
import AppLayout from '../Layouts/AppLayout.vue'

const props = defineProps({
  activeTab: {
    type: String,
    required: true
  }
})

const tabClass = (tab) => {
  const active = props.activeTab === tab
  const base = "flex-1 rounded-md py-2.5 text-center text-sm font-medium transition-all duration-200"
  if (active) {
    return `${base} bg-white text-zinc-900 shadow-sm dark:bg-zinc-900 dark:text-zinc-50`
  } else {
    return `${base} text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-200`
  }
}
</script>
