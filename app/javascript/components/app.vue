<template>
  <draggable v-model="lists" group='lists' class="main-cards dragArea" @end="listMoved">
    <div v-for="(list, index) in lists" class="col-3"> 
      <h4>{{ list.name }}</h4>
      <hr />
      <draggable v-model="list.cards" group='cards' class="dragArea" @change="cardMoved">
        <div v-for="(card, index) in list.cards" class="list">
          {{ card.name }}
        </div>
      </draggable>

      <div class="card card-body">
        <textarea v-model="messages[list.id]" class="form-control"></textarea>
        <button v-on:click="submitMessages(list.id)" class="btn btn-secondary">Add</button>
      </div>

    </div>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import { Rails } from "packs/application.js"

export default {
  components: { draggable },
  props: ["original_lists"],
  
  data: function() {
    return {
      messages: {},
      lists: this.original_lists,
    }
  },

  methods: {

    cardMoved: function(event) {
      const evt = event.added || event.moved
      if (evt == undefined) { return }

      const element = evt.element
      const list_index = this.lists.findIndex((list) => {
        return list.cards.find((card) => {
          return card.id === element.id
        })
      })
      
      let data = new FormData
      data.append("card[list_id]", this.lists[list_index].id)
      data.append("card[position]", evt.newIndex + 1)

      Rails.ajax({
        url: `/cards/${element.id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
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

    submitMessages: function(list_id) {
      // console.log(this.messages[list_id]);
      console.log(this);
      let data = new FormData
      data.append("card[list_id]", list_id)
      data.append("card[name]", this.messages[list_id])

      Rails.ajax({
        url: "/cards",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          const index = this.lists.findIndex(item => item.id == list_id)
          this.lists[index].cards.push(data)
          this.messages[list_id] = undefined
        }
      })
    }
  }
}
</script>

<style scoped>
.main-cards{
  display: flex;
  flex-wrap: wrap;
}
.card{
  flex: 1 0 21%; /* explanation below */
  margin: 5px;
  height: 100px;
}
.lists{

}
.list{
  border: 1px solid #b5b5b5;
  padding: 20px;
  border-radius: 10px;
}
hr {
  border: none; /* Убираем границу для браузера Firefox */
  color: #b5b5b5; /* Цвет линии для остальных браузеров */
  background-color: #b5b5b5; /* Цвет линии для браузера Firefox и Opera */
  height: 1px; /* Толщина линии */
}
h4{
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
.col-3{
  flex: 0 0 25%;
  margin: 0 20px;
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
