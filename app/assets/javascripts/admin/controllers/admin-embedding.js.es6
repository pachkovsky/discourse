export default Ember.Controller.extend({
  embedding: null,

  actions: {
    saveChanges() {
      this.get('embedding').update({});
    }
  }
});
