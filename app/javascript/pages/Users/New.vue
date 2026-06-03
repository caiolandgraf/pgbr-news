<template>
  <AuthShell active-tab="signup">
    <header class="mb-6">
      <h1 class="text-xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">Crie sua conta</h1>
      <p class="mt-1 text-sm text-zinc-500 dark:text-zinc-400">Leva menos de um minuto para começar a publicar.</p>
    </header>

    <div v-if="errors && errors.length > 0" class="mb-6 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800 dark:border-red-900/50 dark:bg-red-950/40 dark:text-red-200" role="alert">
      <p class="font-medium">Revise os campos abaixo:</p>
      <ul class="mt-2 space-y-1">
        <li v-for="err in errors" :key="err" class="flex gap-2">
          <span>·</span>
          {{ err }}
        </li>
      </ul>
    </div>

    <form @submit.prevent="submit" class="space-y-5">
      <!-- Username -->
      <div class="space-y-1.5">
        <label for="username" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Usuário</label>
        <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm dark:border-zinc-700 dark:bg-zinc-900">
          <span class="flex items-center border-r border-zinc-200 bg-zinc-50 px-3 text-sm font-medium text-zinc-500 dark:border-zinc-700 dark:bg-zinc-800/50 dark:text-zinc-400">@</span>
          <input 
            id="username"
            v-model="form.username"
            type="text"
            required
            autofocus
            autocomplete="username"
            placeholder="seu_usuario"
            spellcheck="false"
            class="block w-full border-0 bg-transparent px-3 py-2.5 text-sm text-zinc-900 placeholder:text-zinc-400 focus:outline-none focus:ring-0 dark:text-zinc-100 dark:placeholder:text-zinc-600"
          />
        </div>
        <p class="text-xs text-zinc-500 dark:text-zinc-500">Letras, números e underscore. Aparece nas suas publicações.</p>
      </div>

      <!-- Email -->
      <div class="space-y-1.5">
        <label for="email" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">E-mail</label>
        <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/30 dark:border-zinc-700 dark:bg-zinc-900">
          <span class="flex items-center pl-3 text-zinc-400 dark:text-zinc-500" aria-hidden="true">
            <Mail class="h-5 w-5" stroke-width="1.5" />
          </span>
          <input 
            id="email"
            v-model="form.email"
            type="email"
            required
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
          <input 
            id="password"
            v-model="form.password"
            :type="showPassword ? 'text' : 'password'"
            required
            autocomplete="new-password"
            placeholder="Mínimo 8 caracteres"
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
        <p 
          class="text-xs transition-colors duration-200 font-medium"
          :class="isPasswordLengthOk ? 'text-emerald-600 dark:text-emerald-400' : 'text-zinc-500'"
        >
          Pelo menos 8 caracteres
        </p>
      </div>

      <!-- Password Confirmation -->
      <div class="space-y-1.5">
        <label for="password_confirmation" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Confirmar senha</label>
        <div class="flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/30 dark:border-zinc-700 dark:bg-zinc-900">
          <input 
            id="password_confirmation"
            v-model="form.password_confirmation"
            :type="showPasswordConfirmation ? 'text' : 'password'"
            required
            autocomplete="new-password"
            placeholder="Repita a senha"
            class="block w-full border-0 bg-transparent px-3 py-2.5 text-sm text-zinc-900 placeholder:text-zinc-400 focus:outline-none focus:ring-0 dark:text-zinc-100 dark:placeholder:text-zinc-600"
          />
          <button 
            type="button" 
            @click="showPasswordConfirmation = !showPasswordConfirmation"
            class="shrink-0 px-3 text-xs font-medium text-zinc-500 hover:text-zinc-800 dark:text-zinc-400 dark:hover:text-zinc-200 transition-colors cursor-pointer"
          >
            <span>{{ showPasswordConfirmation ? 'Ocultar' : 'Mostrar' }}</span>
          </button>
        </div>
        <p 
          v-if="form.password_confirmation"
          class="text-xs transition-colors duration-200 font-medium"
          :class="isPasswordMatchOk ? 'text-emerald-600 dark:text-emerald-400' : 'text-red-600 dark:text-red-400'"
        >
          {{ passwordMatchText }}
        </p>
      </div>

      <button 
        type="submit"
        :disabled="form.processing"
        class="w-full cursor-pointer rounded-lg bg-emerald-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 dark:focus:ring-offset-zinc-900 transition-colors disabled:opacity-50"
      >
        {{ form.processing ? 'Criando conta...' : 'Criar conta' }}
      </button>
    </form>

    <p class="mt-6 border-t border-zinc-100 pt-6 text-center text-sm text-zinc-500 dark:border-zinc-800 dark:text-zinc-400">
      Já tem conta?
      <Link href="/login" class="font-medium text-emerald-600 hover:text-emerald-500 dark:text-emerald-400 transition-colors">
        Entrar
      </Link>
    </p>
  </AuthShell>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useForm, Link } from '@inertiajs/vue3'
import { Mail } from '@lucide/vue'
import AuthShell from '../../Components/AuthShell.vue'

const props = defineProps({
  user: {
    type: Object,
    default: () => ({ username: '', email: '', password: '', password_confirmation: '' })
  },
  errors: {
    type: Array,
    default: () => []
  }
})

const showPassword = ref(false)
const showPasswordConfirmation = ref(false)

const form = useForm({
  username: props.user.username,
  email: props.user.email,
  password: '',
  password_confirmation: ''
})

const isPasswordLengthOk = computed(() => form.password.length >= 8)

const isPasswordMatchOk = computed(() => {
  return form.password === form.password_confirmation
})

const passwordMatchText = computed(() => {
  if (!form.password_confirmation) return ''
  return isPasswordMatchOk.value ? 'Senhas conferem' : 'Senhas não conferem'
})

const submit = () => {
  form.transform((data) => ({
    user: {
      username: data.username,
      email: data.email,
      password: data.password,
      password_confirmation: data.password_confirmation
    }
  })).post('/users')
}
</script>
