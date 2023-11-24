<template>
  <div class="flex flex-row items-center">
    <button @click="doDec" class="h-8 w-8 items-center flex justify-center border rounded-sm shadow-sm">-</button>
    <div class="mx-4">
      {{ counter }}
    </div>
    <button @click="doInc" class="h-8 w-8 items-center flex justify-center border rounded-sm shadow-sm">+</button>
  </div>
</template>

<script setup lang="ts">

import { onMounted, onUnmounted, computed } from 'vue';
import { useStore } from '@/store/store'
import { ActionTypes } from '@/store/action-types';
import { GetterTypes } from '@/store/getter-types';

import { Pokes, Scries } from "@/api/counterAppApi"

const store = useStore()

onMounted(() => {
  const deskname = 'counter'
  startAirlock(deskname)
})

onUnmounted(() => {
  // Maybe:
  // closeAirlock()
})

const counter = computed(() => store.state.counter)

const fromGetters = computed(() => {
  return store.getters[GetterTypes.EXAMPLE_WITH_ARG]('arg here');
})

const doInc = () => {
  return Pokes.Inc()
}
const doDec = () => {
  return Pokes.Dec()
}

const someScry = () => {
  return Scries.Thing()
}

const startAirlock = (deskname: string) => {
  store.dispatch(ActionTypes.AIRLOCK_OPEN, deskname)
}

const closeAirlock = () => {
  // Maybe you want this.
}

</script>

