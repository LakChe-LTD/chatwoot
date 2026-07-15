<script setup>
import { computed, ref, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import TestimonialCard from './TestimonialCard.vue';
import { getTestimonialContent } from '../../../../../api/testimonials';

const store = useStore();

const testimonial = ref(null);
const globalConfig = computed(() => store.getters['globalConfig/get']);
const installationName = computed(
  () => globalConfig.value.installationName || 'LakcheLink'
);
const isChatwootInstance = computed(
  () => installationName.value === 'Chatwoot'
);

const brandedTestimonials = computed(() => [
  {
    authorReview: `${installationName.value} gives our team one place to manage customer conversations across web chat, support requests, and follow-ups without losing context.`,
    authorImage: globalConfig.value.logoThumbnail,
    authorName: 'Customer Operations Team',
    authorCompany: 'LakcheLink',
  },
  {
    authorReview: `We can move faster with ${installationName.value} because agents see the full customer timeline before they reply, which keeps handoffs and follow-through clean.`,
    authorImage: globalConfig.value.logoThumbnail,
    authorName: 'Support Leadership',
    authorCompany: 'LakcheLink',
  },
  {
    authorReview: `${installationName.value} helps us stay responsive as conversation volume grows. The setup is straightforward and the daily workflow is easy for agents to adopt.`,
    authorImage: globalConfig.value.logoThumbnail,
    authorName: 'Service Delivery',
    authorCompany: 'LakcheLink',
  },
]);

const fetchTestimonials = async () => {
  if (!isChatwootInstance.value) {
    testimonial.value =
      brandedTestimonials.value[
        Math.floor(Math.random() * brandedTestimonials.value.length)
      ];
    return;
  }

  try {
    const { data } = await getTestimonialContent();
    if (data.length) {
      testimonial.value = data[Math.floor(Math.random() * data.length)];
    }
  } catch {
    // Ignoring the error as the UI wouldn't break
  }
};

onBeforeMount(() => {
  fetchTestimonials();
});
</script>

<template>
  <div
    class="relative flex-1 flex flex-col items-start justify-center bg-n-alpha-black2 dark:bg-n-solid-3 px-12 py-14 rounded-e-lg"
  >
    <TestimonialCard
      v-if="testimonial"
      :review-content="testimonial.authorReview"
      :author-image="testimonial.authorImage"
      :author-name="testimonial.authorName"
      :author-designation="testimonial.authorCompany || installationName"
    />
    <div class="absolute bottom-8 right-8 grid grid-cols-3 gap-1.5">
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
    </div>
  </div>
</template>
