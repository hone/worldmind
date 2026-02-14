import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class IndexRoute extends Route {
  @service cerebroApi;

  async model() {
    await this.cerebroApi.loadAll();
    return {
      sets: this.cerebroApi.sets,
      packs: this.cerebroApi.packs
    };
  }
}