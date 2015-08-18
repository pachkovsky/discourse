import { bufferedProperty } from 'discourse/mixins/buffered-content';

export default Ember.Component.extend(bufferedProperty('host'), {
  editing: false,
  tagName: 'tr',
  categoryId: null,

  actions: {
    edit() {
      this.set('categoryId', this.get('host.category.id'));
      this.set('editing', true);
    },

    save() {
      const props = this.get('buffered').getProperties('host');
      props.category_id = this.get('categoryId');

      const host = this.get('host');
      host.update(props).then(() => {
        host.set('category', Discourse.Category.findById(this.get('categoryId')));
        this.set('editing', false);
      });
    },

    cancel() {
      this.rollbackBuffer();
      this.set('editing', false);
    }
  }
});
