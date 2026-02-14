import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';
import CardDisplay from '../components/card-display';
import SearchBar from '../components/search-bar';

export default class PackView extends Component {
  @service cerebroApi;
  
  @tracked displayMode = 'image';
  @tracked localSearchQuery = '';

  @action
  setDisplayMode(event) {
    this.displayMode = event.target.value;
  }

  @action
  updateLocalSearch(query) {
    this.localSearchQuery = query;
  }

  get filteredCards() {
    // Use the powerful service logic but limited to this pack's cards
    return this.cerebroApi.searchCards(this.localSearchQuery, this.args.model.cards);
  }

  <template>
    <nav class="breadcrumb">
      <LinkTo @route="packs">Packs</LinkTo> » {{@model.pack.Name}}
    </nav>

    <div class="pack-header">
      <div class="header-main">
        <h1>{{@model.pack.Name}}</h1>
        <p class="pack-meta">
          <span class="badge">{{@model.pack.Type}}</span>
          Pack #{{@model.pack.Number}}
        </p>
      </div>
      <div class="view-controls">
        <label for="display-mode">View:</label>
        <select id="display-mode" {{on "change" this.setDisplayMode}}>
          <option value="image">Images Only</option>
          <option value="text">Text Only</option>
          <option value="full">Full (Image + Text)</option>
        </select>
      </div>
    </div>

    {{#if @model.sets}}
      <section class="pack-section">
        <h2>Defined Sets</h2>
        <div class="sets-grid">
          {{#each @model.sets as |set|}}
            <LinkTo @route="set" @model={{set.Id}} class="set-card">
              <h3>{{set.Name}}</h3>
              <span class="badge">{{set.Type}}</span>
            </LinkTo>
          {{/each}}
        </div>
      </section>
    {{/if}}

    <section class="pack-section">
      <div class="section-header">
        <h2>All Cards in Pack <small>({{this.filteredCards.length}} / {{@model.cards.length}})</small></h2>
        <div class="pack-filter-wrap">
          <SearchBar 
            @local={{true}} 
            @onInput={{this.updateLocalSearch}} 
            @placeholder="Filter this pack (e.g. 'c<3 tr:avenger')..."
          />
        </div>
      </div>

      {{#if this.filteredCards}}
        <div class="cards-grid mode-{{this.displayMode}}">
          {{#each this.filteredCards as |card|}}
            <CardDisplay @card={{card}} @mode={{this.displayMode}} @setId={{card.Printings.0.SetId}} />
          {{/each}}
        </div>
      {{else}}
        <div class="no-results">
          No cards in this pack match "{{this.localSearchQuery}}" 🕸️
        </div>
      {{/if}}
    </section>

    <style>
      .breadcrumb { margin-bottom: 1rem; color: var(--text-muted); font-size: 0.9rem; }
      .pack-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 3rem; padding-bottom: 1.5rem; border-bottom: 2px solid var(--border); }
      .pack-meta { display: flex; align-items: center; gap: 1rem; color: var(--text-muted); margin-top: 0.5rem; }
      
      .view-controls { display: flex; align-items: center; gap: 0.5rem; }
      .view-controls select { padding: 0.5rem; border-radius: 8px; border: 1px solid var(--border); background: white; }

      .pack-section { margin-bottom: 4rem; }
      .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem; }
      .section-header h2 { margin: 0; font-size: 1.75rem; display: flex; align-items: baseline; gap: 1rem; }
      .section-header h2 small { font-size: 1rem; color: var(--text-muted); font-weight: 400; }

      .pack-filter-wrap { width: 400px; }

      .sets-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 1.25rem; }
      .set-card { border: 1px solid var(--border); padding: 1.25rem; border-radius: 12px; text-decoration: none; color: inherit; background: white; transition: all 0.2s; }
      .set-card:hover { border-color: #3498db; background: #fcfcfc; transform: translateY(-2px); }
      .set-card h3 { margin: 0 0 0.75rem 0; font-size: 1.1rem; }

      .badge { font-size: 0.7rem; background: #f1f2f6; padding: 0.2rem 0.5rem; border-radius: 4px; font-weight: 700; text-transform: uppercase; }

      .cards-grid { display: grid; gap: 1.5rem; }
      .cards-grid.mode-image, .cards-grid.mode-text { grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); }
      .cards-grid.mode-full { grid-template-columns: 1fr; }

      .no-results { padding: 3rem; text-align: center; background: white; border-radius: 12px; border: 1px dashed var(--border); color: var(--text-muted); }
    </style>
  </template>
}
