<template>
  <AuthShell active-tab="login">
    <header class="mb-6">
      <h1 class="text-xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">Bem-vindo de volta</h1>
      <p class="mt-1 text-sm text-zinc-500 dark:text-zinc-400">Entre para publicar e acompanhar o feed.</p>
    </header>

    <div v-if="errors && errors.length > 0" class="mb-6 flex gap-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800 dark:border-red-900/50 dark:bg-red-950/40 dark:text-red-200" role="alert">
      <svg class="mt-0.5 h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
      </svg>
      <p>{{ errors.join(', ') }}</p>
    </div>

    <form @submit.prevent="submit" class="space-y-5">
      <!-- Email -->
      <div class="space-y-1.5">
        <label for="email" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">E-mail</label>
        <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/30 dark:border-zinc-700 dark:bg-zinc-900">
          <span class="flex items-center pl-3 text-zinc-400 dark:text-zinc-500" aria-hidden="true">
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
            </svg>
          </span>
          <input 
            id="email"
            v-model="form.email"
            type="email"
            required
            autofocus
            autocomplete="email"
            placeholder="voce@email.com"
            class="block w-full border-0 bg-transparent px-3 py-2.5 text-sm text-zinc-900 placeholder:text-zinc-400 focus:outline-none focus:ring-0 dark:text-zinc-100 dark:placeholder:text-zinc-600"
          />
        </div>
      </div>

      <!-- Password -->
      <div class="space-y-1.5">
        <label for="password" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Senha</label>
        <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/30 dark:border-zinc-700 dark:bg-zinc-900">
          <span class="flex items-center pl-3 text-zinc-400 dark:text-zinc-500" aria-hidden="true">
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
            </svg>
          </span>
          <input 
            id="password"
            v-model="form.password"
            :type="showPassword ? 'text' : 'password'"
            required
            autocomplete="current-password"
            placeholder="Sua senha"
            class="block w-full border-0 bg-transparent px-3 py-2.5 text-sm text-zinc-900 placeholder:text-zinc-400 focus:outline-none focus:ring-0 dark:text-zinc-100 dark:placeholder:text-zinc-600"
          />
          <button 
            type="button" 
            @click="showPassword = !showPassword"
            class="shrink-0 px-3 text-xs font-medium text-zinc-500 hover:text-zinc-800 dark:text-zinc-400 dark:hover:text-zinc-200 transition-colors cursor-pointer"
          >
            <span>{{ showPassword ? 'Ocultar' : 'Mostrar' }}</span>
          </button>
        </div>
      </div>

      <button 
        type="submit"
        :disabled="form.processing"
        class="w-full cursor-pointer rounded-lg bg-emerald-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 dark:focus:ring-offset-zinc-900 transition-colors disabled:opacity-50"
      >
        {{ form.processing ? 'Entrando...' : 'Entrar' }}
      </button>
    </form>

    <p class="mt-6 border-t border-zinc-100 pt-6 text-center text-sm text-zinc-500 dark:border-zinc-800 dark:text-zinc-400">
      Ainda não tem conta?
      <Link href="/users/new" class="font-medium text-emerald-600 hover:text-emerald-500 dark:text-emerald-400 transition-colors">
        Criar conta grátis
      </Link>
    </p>
  </AuthShell>
</template>

<script setup>
import { ref } from 'vue'
import { useForm, Link } from '@inertiajs/vue3'
import AuthShell from '../../Components/AuthShell.vue'

const props = defineProps({
  email: {
    type: String,
    default: ''
  },
  errors: {
    type: Array,
    default: () => []
  }
})

const showPassword = ref(false)

const form = useForm({
  email: props.email,
  password: ''
})

const submit = () => {
  form.post('/login')
}
</script>
