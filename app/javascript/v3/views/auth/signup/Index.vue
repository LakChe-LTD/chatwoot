<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import SignupForm from './components/Signup/Form.vue';
import Testimonials from './components/Testimonials/Index.vue';
import signupBg from 'assets/images/auth/signup-bg.jpg';

const { t } = useI18n();
const installationName = computed(() => 'LakcheLink');
const signupHeading = computed(() =>
  t('REGISTER.GET_STARTED', { installationName: installationName.value })
);
const brandLogo = '/brand-assets/logo.png?v=20260717-1';
const brandLogoDark = '/brand-assets/logo_dark.png?v=20260717-1';
</script>

<template>
  <div
    class="relative w-full h-full min-h-screen flex items-center justify-center bg-cover bg-center bg-no-repeat p-4"
    :style="{ backgroundImage: `url(${signupBg})` }"
  >
    <div
      class="absolute inset-0 bg-n-gray-12/60 dark:bg-n-gray-1/80 backdrop-blur-sm"
    />
    <div
      class="relative flex w-full max-w-[960px] bg-white dark:bg-n-solid-2 rounded-lg outline outline-1 outline-n-container shadow-sm"
    >
      <div class="flex-1 flex items-center justify-center py-10 px-10">
        <div class="max-w-[420px] w-full">
          <div class="mb-6">
            <img
              :src="brandLogo"
              alt="LakcheLink"
              class="block w-auto h-7 dark:hidden"
            />
            <img
              :src="brandLogoDark"
              alt="LakcheLink"
              class="hidden w-auto h-7 dark:block"
            />
            <h2 class="mt-6 text-2xl font-semibold text-n-slate-12">
              {{ signupHeading }}
            </h2>
            <p class="mt-2 text-sm text-n-slate-11">
              {{ $t('REGISTER.HAVE_AN_ACCOUNT') }}{{ ' '
              }}<router-link
                class="text-n-blue-10 font-medium hover:text-n-blue-11"
                to="/app/login"
              >
                {{ $t('LOGIN.SUBMIT') }}
              </router-link>
            </p>
          </div>
          <SignupForm />
        </div>
      </div>
      <Testimonials class="flex-1 hidden xl:flex" />
    </div>
  </div>
</template>
