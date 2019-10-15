<template>
  <draggable :disabled="reversedMessage" v-model="lists" group='lists' class="main-cards dragArea" @end="listMoved">
    <list v-for="(list, index) in lists" :list="list"></list>

    <div class="list-wrapper add-list col-3">
      <a v-if="!editing" v-on:click="startEditing" class="link add-card">Add a list</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control"></textarea>
      <button v-if="editing" v-on:click="submitMessage()" class="btn btn-secondary">Add</button>
      <a v-if="editing" v-on:click="editing=false">Cancel</a>
    </div>
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
      status: window.store.modal,
      lists: this.original_lists,
      editing: false,
      message: '',
    }
  },
  computed: {
    reversedMessage: function () {
      return window.store.modal
    }
  },
  methods: {
    startEditing: function() {
      this.editing = true
      this.$nextTick(() => { this.$refs.message.focus() })
    },
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
    submitMessage: function() {
        let data = new FormData
        data.append("list[name]", this.message)
        Rails.ajax({
          url: "/lists",
          type: "POST",
          data: data,
          dataType: "json",
          success: (data) => {
            window.store.lists.push(data)
            this.message = ""
            this.editing = false
          }
        })
      },
  }
}
</script>

<style scoped>
.list-wrapper{
  display: flex;
  flex-direction: column;
  background-color: #ebecf0;
  border-radius: 3px;
  margin: 5px 5px;
}
.add-list{
  padding: 10px;
}
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
