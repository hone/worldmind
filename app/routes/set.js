import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class SetRoute extends Route {
  @service cerebroApi;

  async model(params) {
    await this.cerebroApi.loadAll();
    const set = this.cerebroApi.sets.find(s => s.Id === params.set_id);
    const cards = this.cerebroApi.getCardsBySet(params.set_id);

    // Sort cards by the ArtificialId of the printing that belongs to this set
    const sortedCards = cards.sort((a, b) => {
      const printA = a.Printings?.find(p => p.SetId === params.set_id);
      const printB = b.Printings?.find(p => p.SetId === params.set_id);

      const idA = printA?.ArtificialId || '';
      const idB = printB?.ArtificialId || '';

      return idA.localeCompare(idB);
    });

    return { set, cards: sortedCards };
  }
}
