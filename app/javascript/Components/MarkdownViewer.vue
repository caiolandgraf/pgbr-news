<template>
  <div ref="mount" class="tabnews-markdown-viewer animate-fade-in"></div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import { createViewer } from '../markdown_editor'

const props = defineProps({
  value: {
    type: String,
    required: true
  }
})

const mount = ref(null)
let viewer = null

const renderViewer = () => {
  if (viewer) {
    viewer.$destroy()
  }
  if (mount.value) {
    viewer = createViewer({
      target: mount.value,
      value: props.value
    })
  }
}

onMounted(() => {
  renderViewer()
  document.addEventListener('theme:changed', renderViewer)
})

onBeforeUnmount(() => {
  document.removeEventListener('theme:changed', renderViewer)
  if (viewer) {
    viewer.$destroy()
  }
})

watch(() => props.value, () => {
  renderViewer()
})
</script>
