<template>
  <div
    class="min-h-screen flex flex-col bg-[var(--bgColor-default)] text-[var(--fgColor-default)] transition-colors duration-300"
  >
    <!-- Navbar -->
    <header
      class="sticky top-0 z-50 border-b border-zinc-800 bg-zinc-900 text-zinc-100 shadow-lg backdrop-blur-md bg-opacity-95"
    >
      <div class="mx-auto flex max-w-5xl flex-wrap items-center gap-3 px-4 py-3 sm:gap-4 sm:px-6">
        <!-- Logo -->
        <Link
          href="/"
          class="flex shrink-0 items-center gap-2 font-semibold tracking-tight text-white hover:text-emerald-400 transition-all duration-200 transform hover:scale-105"
        >
          <Folder
            class="h-6 w-6 text-emerald-400 filter drop-shadow-[0_0_8px_rgba(52,211,153,0.5)]"
            stroke-width="1.5"
          />
          <span
            class="text-xl font-bold bg-gradient-to-r from-white via-zinc-200 to-emerald-400 bg-clip-text text-transparent"
          >Blog</span>
        </Link>

        <!-- Nav tabs -->
        <nav class="flex items-center gap-4 text-sm font-medium">
          <Link
            href="/"
            :data="{ sort: 'recent' }"
            class="text-zinc-300 hover:text-white transition-colors duration-200"
            :class="{ 'text-white border-b-2 border-emerald-500 pb-0.5': currentSort !== 'relevant' }"
          >
            Recentes
          </Link>
          <Link
            href="/"
            :data="{ sort: 'relevant' }"
            class="text-zinc-300 hover:text-white transition-colors duration-200"
            :class="{ 'text-white border-b-2 border-emerald-500 pb-0.5': currentSort === 'relevant' }"
          >
            Relevantes
          </Link>
        </nav>

        <!-- Search Bar (Disabled as per original design but beautiful) -->
        <div class="order-last w-full sm:order-none sm:mx-4 sm:flex-1 sm:max-w-md">
          <div class="relative">
            <span class="sr-only">Pesquisar</span>
            <Search
              class="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-zinc-500"
              stroke-width="1.5"
            />
            <input
              type="search"
              placeholder="Pesquisar"
              disabled
              class="w-full rounded-lg border border-zinc-700 bg-zinc-800 py-1.5 pl-10 pr-3 text-sm text-zinc-100 placeholder:text-zinc-500 focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500 disabled:cursor-not-allowed disabled:opacity-60 transition-all duration-200"
            />
          </div>
        </div>

        <!-- Right actions -->
        <div class="ml-auto flex items-center gap-2 sm:gap-3">
          <!-- Theme Toggle -->
          <button
            type="button"
            @click="toggleTheme"
            class="rounded-lg p-2 text-zinc-400 hover:bg-zinc-800 hover:text-white transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-emerald-500/50"
            aria-label="Alternar tema"
          >
            <Sun
              v-if="isDark"
              class="h-5 w-5 text-yellow-400"
              stroke-width="1.5"
            />
            <Moon
              v-else
              class="h-5 w-5 hover:text-indigo-400 transition-colors"
              stroke-width="1.5"
            />
          </button>

          <!-- User session section -->
          <template v-if="currentUser">
            <Link
              :href="`/@${currentUser.username}`"
              class="max-w-[9rem] truncate rounded-lg px-3 py-1.5 text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors duration-200 font-medium"
            >
              @{{ currentUser.username }}
            </Link>
            <Link
              href="/logout"
              method="delete"
              as="button"
              class="rounded-lg px-3 py-1.5 text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors duration-200 font-medium cursor-pointer"
            >
              Sair
            </Link>
            <Link
              href="/articles/new"
              class="rounded-lg bg-emerald-600 px-3.5 py-1.5 text-sm font-semibold text-white hover:bg-emerald-500 shadow-md shadow-emerald-950/20 transition-all duration-200 hover:scale-105 active:scale-95"
            >
              Publicar
            </Link>
          </template>
          <template v-else>
            <Link
              href="/login"
              class="rounded-lg px-3 py-1.5 text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors duration-200 font-medium"
            >
              Login
            </Link>
            <Link
              href="/users/new"
              class="rounded-lg bg-emerald-600 px-3.5 py-1.5 text-sm font-semibold text-white hover:bg-emerald-500 shadow-md shadow-emerald-950/20 transition-all duration-200 hover:scale-105 active:scale-95"
            >
              Cadastrar
            </Link>
          </template>
        </div>
      </div>
    </header>

    <!-- Flash notifications -->
    <div
      v-if="showNotice && flash.notice"
      class="border-b border-emerald-200 bg-emerald-50 px-4 py-2.5 text-center text-sm text-emerald-800 dark:border-emerald-900 dark:bg-emerald-950/80 dark:text-emerald-200 flex items-center justify-center gap-2 animate-fade-in"
    >
      <CheckCircle
        class="h-4 w-4 text-emerald-600 dark:text-emerald-400 shrink-0"
      />
      <span class="font-medium">{{ flash.notice }}</span>
      <button
        @click="showNotice = false"
        class="ml-2 hover:opacity-80 p-0.5 rounded-full hover:bg-emerald-200 dark:hover:bg-emerald-900 transition-colors"
      >
        <X
          class="w-3.5 h-3.5"
        />
      </button>
    </div>

    <div
      v-if="showAlert && flash.alert"
      class="border-b border-red-200 bg-red-50 px-4 py-2.5 text-center text-sm text-red-800 dark:border-red-900 dark:bg-red-950/80 dark:text-red-200 flex items-center justify-center gap-2 animate-fade-in"
    >
      <AlertTriangle
        class="h-4 w-4 text-red-600 dark:text-red-400 shrink-0"
      />
      <span class="font-medium">{{ flash.alert }}</span>
      <button
        @click="showAlert = false"
        class="ml-2 hover:opacity-80 p-0.5 rounded-full hover:bg-red-200 dark:hover:bg-red-900 transition-colors"
      >
        <X
          class="w-3.5 h-3.5"
        />
      </button>
    </div>

    <!-- Main Content -->
    <main :class="['mx-auto px-4 py-6 sm:px-6 flex-1 w-full antialiased transition-all duration-300', mainClass]">
      <slot />
    </main>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, computed } from 'vue'
import { Link, usePage } from '@inertiajs/vue3'
import { Folder, Search, Sun, Moon, CheckCircle, X, AlertTriangle } from '@lucide/vue'

const props = defineProps({
  mainClass: {
    type: String,
    default: 'max-w-5xl'
  }
})

const { props: pageProps } = usePage()

const currentUser = computed(() => pageProps.currentUser)
const flash = computed(() => pageProps.flash || {})
const currentSort = computed(() => pageProps.sort || 'recent')

const showNotice = ref(true)
const showAlert = ref(true)

// Reset flash visibility on navigation
watch(() => flash.value, () => {
  showNotice.value = true
  showAlert.value = true
}, { deep: true })

const isDark = ref(false)

onMounted(() => {
  isDark.value = document.documentElement.classList.contains("dark")
  syncMarkdownDarkTheme()
})

const toggleTheme = () => {
  const dark = document.documentElement.classList.toggle("dark")
  localStorage.theme = dark ? "dark" : "light"
  document.documentElement.dataset.colorMode = dark ? "dark" : "light"
  isDark.value = dark
  document.dispatchEvent(new CustomEvent("theme:changed"))
  syncMarkdownDarkTheme()
}

const syncMarkdownDarkTheme = () => {
  const link = document.getElementById("hljs-markdown-dark")
  if (link) {
    link.disabled = !isDark.value
  }
}
</script>

<style>
.animate-spin-slow {
  animation: spin 8s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-5px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
