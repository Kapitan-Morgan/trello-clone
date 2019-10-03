<template>
  <draggable v-model="lists" group='lists' class="main-cards dragArea" @end="listMoved">
    <list v-for="(list, index) in lists" :list="list"></list>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import list from 'components/list'
import { Rails } from "packs/application.js"

export default {
  components: { draggable, list},
  props: ["original_lists"],
  
  data: function() {
    return {
      lists: this.original_lists,
    }
  },

  methods: {
    listMoved: function(event) {
      let data = new FormData
      data.append("list[position]", event.newIndex + 1)

      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    },
  }
}
</script>

<style scoped>
.main-cards{
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  margin-top: 50px;
}
.col-3{
  flex: 0 0 calc(25% - 10px);
}
</style>
