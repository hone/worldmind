import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class PacksRoute extends Route {
  @service cerebroApi;

  async model() {
    await this.cerebroApi.loadAll();
    // Sort packs by their Number field
    return this.cerebroApi.packs.sort((a, b) => {
      const numA = parseInt(a.Number || '999', 10);
      const numB = parseInt(b.Number || '999', 10);
      return numA - numB;
    });
  }
}