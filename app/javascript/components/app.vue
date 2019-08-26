<template>
  <div id="app" class="main-cards row">
    <div v-for="(list, index) in original_lists" class="col-3"> 
      <h4>{{ list.name }}</h4>
      <hr />

      <div v-for="(card, index) in list.cards" class="lists">
        <div class="list">
          {{ card.name }}
        </div>
      </div>

      <div class="card card-body">
        <textarea v-model="messages[list.id]" class="form-control"></textarea>
        <button v-on:click="submitMessages(list.id)" class="btn btn-secondary">Add</button>
      </div>

    </div>
  </div>
</template>

<script>
import { Rails } from "packs/application.js"
export default {
  props: ["original_lists"],
  data: function() {
    return {
      messages: {},
      lists: this.original_lists,
    }
  },

  methods: {
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
</style>
