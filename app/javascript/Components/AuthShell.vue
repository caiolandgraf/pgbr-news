<template>
  <div class="flex min-h-[calc(100dvh-8rem)] flex-col justify-center py-8 animate-fade-in">
    <div class="mb-6 text-center">
      <Link href="/" class="inline-flex items-center gap-2 text-zinc-900 hover:text-emerald-600 dark:text-zinc-100 dark:hover:text-emerald-400 transition-colors">
        <svg class="h-6 w-6 text-emerald-600 dark:text-emerald-400" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12.75V12A2.25 2.25 0 0 1 4.5 9.75h15A2.25 2.25 0 0 1 21.75 12v.75m-8.69-6.44-2.12-2.12a1.5 1.5 0 0 0-1.061-.44H4.5A2.25 2.25 0 0 0 2.25 6v12a2.25 2.25 0 0 0 2.25 2.25h15A2.25 2.25 0 0 0 21.75 18V9a2.25 2.25 0 0 0-2.25-2.25h-5.379a1.5 1.5 0 0 1-1.06-.44Z" />
        </svg>
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
</template>

<script setup>
import { Link } from '@inertiajs/vue3'

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
