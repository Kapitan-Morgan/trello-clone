<template>
  <div class="col-3 list-wrapper"> 

    <h4>{{ list.name }}</h4>
    <hr />
    
    <draggable :disabled="reversedMessage" v-model="list.cards" group='cards' class="dragArea cards" @change="cardMoved">
      <card v-for="card in list.cards" :card="card" :list="list"></card>
    </draggable>

    <div class="list-body">
      <a v-if="!editing" v-on:click="startEditing" class="link add-card">Add a card</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control"></textarea>
      <button v-if="editing" v-on:click="submitMessage()" class="btn btn-secondary">Add</button>
      <a v-if="editing" v-on:click="editing=false">Cancel</a>
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable'
import card from 'components/card'
import { Rails } from "packs/application.js"
  export default {
    components: { card, draggable },
    props: ["list"],

    data: function() {
      return {
        editing: false,
        message: "",
        status: window.store.modal
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

      cardMoved: function(event) {
        const evt = event.added || event.moved
        if (evt == undefined) { return }

        const element = evt.element
        const list_index = window.store.lists.findIndex((list) => {
          return list.cards.find((card) => {
            return card.id === element.id
          })
        })
        
        let data = new FormData
        data.append("card[list_id]", window.store.lists[list_index].id)
        data.append("card[position]", evt.newIndex + 1)

        Rails.ajax({
          url: `/cards/${element.id}/move`,
          type: "PATCH",
          data: data,
          dataType: "json",
        })
      },

      submitMessage: function() {
        let data = new FormData
        data.append("card[list_id]", this.list.id)
        data.append("card[name]", this.message)

        Rails.ajax({
          url: "/cards",
          type: "POST",
          data: data,
          dataType: "json",
          success: (data) => {
            const index = window.store.lists.findIndex(item => item.id == this.list.id)
            window.store.lists[index].cards.push(data)
            this.message = ""
            this.$nextTick(() => { this.$refs.message.focus() })
          }
        })
      }
    }
  }
</script>

<style scoped>
.list-body {
  padding: 1rem;
}
hr {
  border: none; /* Убираем границу для браузера Firefox */
  color: #b5b5b5; /* Цвет линии для остальных браузеров */
  background-color: #b5b5b5; /* Цвет линии для браузера Firefox и Opera */
  height: 1px; /* Толщина линии */
}
h4{
  padding: 10px 8px;
  margin: 0;
}
.row{
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -ms-flex-wrap: wrap;
  flex-wrap: wrap;
  margin-right: -15px;
  margin-left: -15px;
}
.col{
  flex-basis: 0;
  -webkit-box-flex: 1;
  -ms-flex-positive: 1;
  flex-grow: 1;
  max-width: 100%;
}
body{
  max-width: 1200px;
  margin: 0 auto;
}
p {
  font-size: 2em;
  text-align: center;
}
.dragArea{
  min-height: 20px;
}
</style>