<template>
  <AppLayout main-class="max-w-2xl w-full">
    <div class="space-y-6 animate-fade-in">
      <header>
        <h1 class="text-2xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">Editar perfil</h1>
        <p class="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
          <Link :href="`/@${profileUser.username}`" class="text-emerald-600 hover:underline dark:text-emerald-400 font-semibold">
            Ver perfil público
          </Link>
        </p>
      </header>

      <div v-if="errors && errors.length > 0" class="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-800 dark:border-red-900/60 dark:bg-red-950/50 dark:text-red-200">
        <p class="font-medium">Revise os erros abaixo:</p>
        <ul class="mt-1 list-inside list-disc">
          <li v-for="err in errors" :key="err">{{ err }}</li>
        </ul>
      </div>

      <form @submit.prevent="submit" class="space-y-6">
        <!-- Username -->
        <div class="space-y-2">
          <label for="username" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Usuário</label>
          <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm dark:border-zinc-700 dark:bg-zinc-900">
            <span class="flex items-center border-r border-zinc-200 bg-zinc-50 px-3 text-sm text-zinc-500 dark:border-zinc-700 dark:bg-zinc-800/50 dark:text-zinc-400">@</span>
            <input 
              id="username"
              v-model="form.username"
              type="text"
              required
              class="block w-full border-0 bg-transparent px-3 py-2.5 text-sm focus:outline-none focus:ring-0 dark:text-zinc-100"
            />
          </div>
        </div>

        <!-- Name -->
        <div class="space-y-2">
          <label for="name" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Nome (opcional)</label>
          <input 
            id="name"
            v-model="form.name"
            type="text"
            class="w-full rounded-lg border border-zinc-300 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/40 dark:border-zinc-700 dark:bg-zinc-900 dark:text-zinc-100"
          />
        </div>

        <!-- Email -->
        <div class="space-y-2">
          <span class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">E-mail</span>
          <p class="rounded-lg border border-zinc-200 bg-zinc-50 px-3 py-2.5 text-sm text-zinc-600 dark:border-zinc-800 dark:bg-zinc-900/50 dark:text-zinc-400">
            {{ profileUser.email }}
          </p>
          <p class="text-xs text-zinc-500">O e-mail não pode ser alterado por aqui.</p>
        </div>

        <!-- Bio -->
        <MarkdownField 
          v-model="form.bio"
          :max-length="2000"
          label="Bio"
          :compact="true"
          hint="Markdown suportado. Conte um pouco sobre você."
        />

        <div class="flex flex-wrap justify-end gap-3 pt-2">
          <Link :href="`/@${profileUser.username}`" class="rounded-lg px-4 py-2 text-sm font-medium text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-100">
            Cancelar
          </Link>
          <button 
            type="submit"
            :disabled="form.processing"
            class="cursor-pointer rounded-lg bg-emerald-600 px-5 py-2 text-sm font-medium text-white shadow-sm hover:bg-emerald-500 transition-colors disabled:opacity-50"
          >
            {{ form.processing ? 'Salvando...' : 'Salvar perfil' }}
          </button>
        </div>
      </form>
    </div>
  </AppLayout>
</template>

<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import AppLayout from '../../Layouts/AppLayout.vue'
import MarkdownField from '../../Components/MarkdownField.vue'

const props = defineProps({
  profileUser: {
    type: Object,
    required: true
  },
  errors: {
    type: Array,
    default: () => []
  }
})

const form = useForm({
  username: props.profileUser.username,
  name: props.profileUser.name || '',
  bio: props.profileUser.bio || ''
})

const submit = () => {
  form.transform((data) => ({
    user: {
      username: data.username,
      name: data.name,
      bio: data.bio
    }
  })).patch(`/@${props.profileUser.username}`)
}
</script>
