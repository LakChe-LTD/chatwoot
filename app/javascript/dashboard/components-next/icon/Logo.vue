<script setup>
import { useAttrs } from 'vue';

const attrs = useAttrs();
const brandLogoThumbnail = '/brand-assets/logo_thumbnail.png?v=20260718-1';
</script>

<template>
  <img v-bind="attrs" :src="brandLogoThumbnail" />
</template>
