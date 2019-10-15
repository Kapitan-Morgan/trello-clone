<template>
  <div>
    <div @click="openModal" class="card">
      {{ card.name }}
    </div>
    <transition name="modal-backdrop">
      <div v-if='editing' class="modal-backdrop"></div>
    </transition>

    <transition name="modal-fade">
      <div v-if='editing' @click="closeModal" class="modal show" style="display: block">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">{{ card.name }}</h5>
            </div>
            <div class="modal-body">
              <textarea ref="cardName" v-model='cardName' class="form-control"></textarea>
            </div>
            <div class="modal-footer">
              <button v-on:click="save()" type="button" class="btn btn-primary">Save change</button>
            </div>
          </div>
        </div>
      </div>
    </transition>
    
  </div>
</template>

<script>
import { Rails } from "packs/application.js"
  export default {
    props: ['card', 'list'],
    data: function() {
      return {
        bufCardName: '',
        editing: false,
      }
    },
    computed: {
      cardName: {
        get() {return this.card.name;},
        set(newVal) {this.bufCardName = newVal}
      },
    },
    methods: {
      openModal: function() {
        window.store.modal = true
        toggleModal(this)
        this.$nextTick(() => { this.$refs.cardName.focus() })
      },
      closeModal: function() {
        if (event.target.classList.contains("modal")) {
          window.store.modal = false
          toggleModal(this)
        }
      },
      save: function() {
        let data = new FormData
        data.append("card[name]", this.bufCardName)

        Rails.ajax({
          url: `/cards/${this.card.id}`,
          type: "PATCH",
          data: data,
          dataType: "json",
          success: (data) => {
            const list_index = window.store.lists.findIndex((item) => item.id === this.list.id),
                  card_index = window.store.lists[list_index].cards.findIndex((item) => item.id === this.card.id)
            window.store.lists[list_index].cards.splice(card_index, 1, data)
            window.store.modal = false
            toggleModal(this)
          }
        })
      },
    }
  }

  function toggleModal(card) {
    card.editing = !card.editing
    document.querySelector('body').classList.toggle("modal-open");
  }
  
</script>

<style scoped>
.cards{
  margin: 0 4px;
  padding: 0 4px;
}
.card{ 
  padding: 10px;
  border-radius: 3px;
  margin: 0 5px 5px;
  background-color: #fff;
}

</style>