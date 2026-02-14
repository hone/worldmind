import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class PackRoute extends Route {
  @service cerebroApi;

  async model(params) {
    await this.cerebroApi.loadAll();
    const pack = this.cerebroApi.packs.find(p => p.Id === params.pack_id);
    
    // 1. Get all sets associated with this pack
    const sets = this.cerebroApi.sets.filter(s => s.PackId === params.pack_id);
    
    // 2. Get EVERY card that has a printing in this pack
    const packCards = this.cerebroApi.cards.filter(card => 
      card.Printings?.some(p => p.PackId === params.pack_id)
    );

    // 3. Sort cards by the ArtificialId for this specific pack printing
    const sortedCards = packCards.sort((a, b) => {
      const printA = a.Printings?.find(p => p.PackId === params.pack_id);
      const printB = b.Printings?.find(p => p.PackId === params.pack_id);
      return (printA?.ArtificialId || '').localeCompare(printB?.ArtificialId || '');
    });

    return { pack, sets, cards: sortedCards };
  }
}
