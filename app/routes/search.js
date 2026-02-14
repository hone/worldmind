import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class SearchRoute extends Route {
  @service cerebroApi;

  queryParams = {
    q: {
      refreshModel: true
    }
  };

  async model(params) {
    await this.cerebroApi.loadAll();
    if (params.q) {
      return {
        results: this.cerebroApi.searchCards(params.q),
        query: params.q
      };
    }
    return { results: [], query: '' };
  }
}