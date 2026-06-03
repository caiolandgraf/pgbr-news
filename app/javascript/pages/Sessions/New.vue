<template>
  <AuthShell active-tab="login">
    <header class="mb-6">
      <h1 class="text-xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">Bem-vindo de volta</h1>
      <p class="mt-1 text-sm text-zinc-500 dark:text-zinc-400">Entre para publicar e acompanhar o feed.</p>
    </header>

    <div v-if="errors && errors.length > 0" class="mb-6 flex gap-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800 dark:border-red-900/50 dark:bg-red-950/40 dark:text-red-200" role="alert">
      <AlertCircle class="mt-0.5 h-5 w-5 shrink-0" stroke-width="1.5" />
      <p>{{ errors.join(', ') }}</p>
    </div>

    <form @submit.prevent="submit" class="space-y-5">
      <!-- Login (Email or Username) -->
      <div class="space-y-1.5">
        <label for="login" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">E-mail ou Usuário</label>
        <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/30 dark:border-zinc-700 dark:bg-zinc-900">
          <span class="flex items-center pl-3 text-zinc-400 dark:text-zinc-500" aria-hidden="true">
            <User class="h-5 w-5" stroke-width="1.5" />
          </span>
          <input 
            id="login"
            v-model="form.login"
            type="text"
            required
            autofocus
            autocomplete="username"
            placeholder="voce@email.com ou seu_usuario"
            class="block w-full border-0 bg-transparent px-3 py-2.5 text-sm text-zinc-900 placeholder:text-zinc-400 focus:outline-none focus:ring-0 dark:text-zinc-100 dark:placeholder:text-zinc-600"
          />
        </div>
      </div>

      <!-- Password -->
      <div class="space-y-1.5">
        <label for="password" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Senha</label>
        <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/30 dark:border-zinc-700 dark:bg-zinc-900">
          <span class="flex items-center pl-3 text-zinc-400 dark:text-zinc-500" aria-hidden="true">
            <Lock class="h-5 w-5" stroke-width="1.5" />
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
import { AlertCircle, User, Lock } from '@lucide/vue'
import AuthShell from '../../Components/AuthShell.vue'

const props = defineProps({
  login: {
    type: String,
    default: ''
  },
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
  login: props.login || props.email,
  password: ''
})

const submit = () => {
  form.post('/login')
}
</script>
