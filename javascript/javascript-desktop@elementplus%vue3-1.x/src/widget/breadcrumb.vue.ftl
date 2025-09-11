<template>
  <nav class="breadcrumb" style="line-height:68px;">
    <div v-for="(bc, index) in breadcrumbs" :key="index">
      <router-link
        v-if="index != breadcrumbs.length - 1"
        :to="bc.path"
        class="breadcrumb-link">
        {{ bc.text }}
      </router-link>
      <span v-if="index != breadcrumbs.length - 1">&nbsp;&nbsp;/&nbsp;</span>
      <div v-if="index == breadcrumbs.length - 1" style="font-weight:600;">{{ bc.text }}</div>
    </div>  
  </nav>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import router from '@/router/index';

const route = useRoute();

const breadcrumbs = computed(() => {
  const matched = route.matched.filter(r => {
    return r;
  });
  return [...router.getBreadcrumbs()];
});

</script>

<style scoped>
.breadcrumb {
  display: flex;
  gap: 8px;
}
.breadcrumb-link {
  text-decoration: none;
  color: var(--color-info);
  font-weight: 600;
}
.breadcrumb-link::after {
  /* content: '/'; */
  margin-left: 8px;
}
.breadcrumb-link:last-child::after {
  content: '';
}
</style>
