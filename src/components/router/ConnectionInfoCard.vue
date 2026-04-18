<template>
  <div class="grid grid-cols-1 gap-4 xl:grid-cols-2">
    <div class="card border border-base-300/60 bg-base-100/60 shadow-sm">
      <div class="card-body gap-3">
        <div>
          <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">IP</div>
          <div class="mt-1 text-lg font-semibold">{{ $t('showIPAndConnectionInfo') }}</div>
        </div>
        <IPCheck />
      </div>
    </div>

    <div class="card border border-base-300/60 bg-base-100/60 shadow-sm">
      <div class="card-body gap-3">
        <div>
          <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">Ping</div>
          <div class="mt-1 text-lg font-semibold">{{ $t('connections') }}</div>
        </div>
        <ConnectionStatus />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import ConnectionStatus from '@/components/overview/ConnectionStatus.vue'
import IPCheck from '@/components/overview/IPCheck.vue'
</script>
