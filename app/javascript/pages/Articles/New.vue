<template>
  <AppLayout main-class="max-w-4xl w-full">
    <div v-if="errors && errors.length > 0" class="mb-4 rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-800 dark:border-red-900/60 dark:bg-red-950/50 dark:text-red-200 animate-fade-in">
      <p class="font-medium">Revise os erros abaixo:</p>
      <ul class="mt-1 list-inside list-disc">
        <li v-for="err in errors" :key="err">{{ err }}</li>
      </ul>
    </div>

    <form @submit.prevent="submit" class="space-y-6">
      <header>
        <h1 class="text-2xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50 sm:text-3xl">
          Publicar novo conteúdo
        </h1>
      </header>

      <!-- Title -->
      <div class="space-y-2">
        <label for="title" class="block text-sm text-zinc-600 dark:text-zinc-400">
          Título <span class="text-zinc-400 dark:text-zinc-500" aria-hidden="true">*</span>
        </label>
        <input 
          id="title"
          v-model="form.title"
          type="text"
          required
          autofocus
          placeholder="Título da publicação"
          class="w-full rounded-md border border-zinc-300 bg-white px-3 py-2.5 text-sm text-zinc-900 shadow-sm placeholder:text-zinc-400 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/40 dark:border-zinc-700 dark:bg-zinc-900 dark:text-zinc-100 dark:placeholder:text-zinc-600"
        />
      </div>

      <!-- Body -->
      <MarkdownField 
        v-model="form.body"
        :max-length="20000"
        label="Corpo da publicação"
        :required="true"
      />

      <!-- Source / Ref -->
      <div class="space-y-2">
        <label for="ref" class="block text-sm text-zinc-600 dark:text-zinc-400">Fonte</label>
        <input 
          id="ref"
          v-model="form.ref"
          type="url"
          placeholder="https://origem.site/noticia"
          class="w-full rounded-md border border-zinc-300 bg-white px-3 py-2.5 text-sm text-zinc-900 shadow-sm placeholder:text-zinc-400 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/40 dark:border-zinc-700 dark:bg-zinc-900 dark:text-zinc-100 dark:placeholder:text-zinc-600"
        />
      </div>

      <p class="text-sm text-zinc-500 dark:text-zinc-500">
        Os campos marcados com um asterisco (<span aria-hidden="true">*</span>) são obrigatórios.
      </p>

      <div class="flex flex-wrap items-center justify-end gap-3 pt-2">
        <Link href="/" class="rounded-md px-4 py-2 text-sm font-medium text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-100 transition-colors">
          Cancelar
        </Link>
        <button 
          type="submit"
          :disabled="form.processing"
          class="cursor-pointer rounded-md bg-emerald-600 px-5 py-2 text-sm font-medium text-white shadow-sm hover:bg-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 dark:focus:ring-offset-zinc-950 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {{ form.processing ? 'Publicando...' : 'Publicar' }}
        </button>
      </div>
    </form>
  </AppLayout>
</template>

<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import AppLayout from '../../Layouts/AppLayout.vue'
import MarkdownField from '../../Components/MarkdownField.vue'

const props = defineProps({
  article: {
    type: Object,
    default: () => ({ title: '', body: '', ref: '' })
  },
  errors: {
    type: Array,
    default: () => []
  }
})

const form = useForm({
  title: props.article.title || '',
  body: props.article.body || '',
  ref: props.article.ref || ''
})

const submit = () => {
  form.transform((data) => ({
    article: {
      title: data.title,
      body: data.body,
      ref: data.ref
    }
  })).post('/articles')
}
</script>
