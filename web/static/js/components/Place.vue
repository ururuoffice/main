<template>
  <div
    class="place"
    :class="{'place__fill': user !== null}"
    :style="getPosition">
    <div class="user" v-if="user !== null">
      <img class="user__avatar" src="images/user_avatar.png" alt="">
      <span class="user__name">{{ user }}</span>
    </div>
  </div>
</template>

<script>
  import { prependCssDimension } from '../heplers';

  export default {
    name: 'place',
    props: {
      position: Object,
      busy: Boolean,
      user: String
    },
    computed: {
      getPosition() {
        const { position } = this

        return prependCssDimension(position)
      }
    }
  };
</script>

<style scoped lang="scss">
  .place {
    position: absolute;
    width: 40px;
    height: 40px;
    border-radius: 100%;
  }

  .user {
    width: 100%;
    height: 100%;

    &__avatar {
      max-width: 100%;
    }

    &__name {
      position: absolute;
      top: calc(100% + 5px);
      left: 50%;
      transform: translateX(-50%);
      height: 16px;
      padding: 1px 5px;
      border-radius: 8px;
      font-size: 12px;
      line-height: 14px;
      color: #fff;
      background-color: rgba(99, 99, 99, .67);
    }
  }
</style>
