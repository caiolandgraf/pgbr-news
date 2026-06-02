<template>
  <div class="space-y-2">
    <label v-if="label" class="block text-sm text-zinc-600 dark:text-zinc-400">
      {{ label }}
      <span v-if="required" class="text-zinc-400 dark:text-zinc-500" aria-hidden="true"> *</span>
    </label>

    <div 
      class="bytemd-editor-container overflow-hidden rounded-md border border-zinc-300 shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/40 dark:border-[var(--borderColor-default)] dark:bg-[var(--bgColor-default)] dark:focus-within:border-[var(--fgColor-accent)] dark:focus-within:ring-[var(--fgColor-accent)]/30"
      :class="{ 'bytemd-editor-container--compact': compact }"
    >
      <div ref="mount" class="block w-full" :class="compact ? 'min-h-[180px]' : 'min-h-[360px]'"></div>
      
      <div class="flex justify-end border-t border-zinc-200 bg-zinc-50 px-3 py-1.5 dark:border-[var(--borderColor-default)] dark:bg-[var(--bgColor-muted)]">
        <span 
          class="text-xs tabular-nums"
          :class="modelValue.length > maxLength ? 'text-red-500 dark:text-red-400' : 'text-zinc-500'"
        >
          {{ modelValue.length }}/{{ maxLength }}
        </span>
      </div>
    </div>

    <p v-if="hint" class="text-xs text-zinc-500 dark:text-zinc-500">{{ hint }}</p>
    <p v-if="error" class="text-xs text-red-500 dark:text-red-400">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import { createEditor } from '../markdown_editor'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  maxLength: {
    type: Number,
    required: true
  },
  compact: {
    type: Boolean,
    default: false
  },
  label: {
    type: String,
    default: ''
  },
  required: {
    type: Boolean,
    default: false
  },
  hint: {
    type: String,
    default: ''
  },
  error: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue'])

const mount = ref(null)
let editor = null
let writeOnlyObserver = null

const initEditor = () => {
  if (editor) return

  const mode = props.compact ? 'tab' : 'auto'

  editor = createEditor({
    target: mount.value,
    value: props.modelValue,
    mode: mode,
    onChange: (value) => {
      emit('update:modelValue', value)
    }
  })

  if (!props.compact) {
    enableWriteOnlyMode()
  }
}

const enableWriteOnlyMode = () => {
  if (writeOnlyObserver) return

  const clickWriteOnly = () => {
    const button = mount.value.querySelector(
      '.bytemd-toolbar-right .bytemd-toolbar-icon[bytemd-tippy-path="2"]'
    )

    if (!button) return false
    if (button.classList.contains('bytemd-toolbar-icon-active')) return true

    button.click()
    return true
  }

  if (clickWriteOnly()) return

  writeOnlyObserver = new MutationObserver(() => {
    if (clickWriteOnly() && writeOnlyObserver) {
      writeOnlyObserver.disconnect()
      writeOnlyObserver = null
    }
  })

  writeOnlyObserver.observe(mount.value, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['class']
  })
}

const refreshLayout = () => {
  requestAnimationFrame(() => {
    mount.value?.querySelectorAll(".CodeMirror").forEach((element) => {
      element.CodeMirror?.refresh()
    })
  })
}

const refreshTheme = () => {
  if (!editor) return
  editor.$set({ value: props.modelValue + "\u200b" })
  editor.$set({ value: props.modelValue })
  refreshLayout()
}

onMounted(() => {
  initEditor()
  document.addEventListener("theme:changed", refreshTheme)
})

onBeforeUnmount(() => {
  document.removeEventListener("theme:changed", refreshTheme)
  if (writeOnlyObserver) {
    writeOnlyObserver.disconnect()
  }
  if (editor) {
    editor.$destroy()
  }
})

watch(() => props.modelValue, (newVal) => {
  if (editor && editor.props.value !== newVal) {
    editor.$set({ value: newVal })
  }
})
</script>
