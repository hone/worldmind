import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { service } from '@ember/service';
import CardDisplay from '../components/card-display';
import SearchBar from '../components/search-bar';

export default class SetView extends Component {
  @service cerebroApi;

  @tracked displayMode = 'image'; // Default to images for sets
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
    return this.cerebroApi.searchCards(this.localSearchQuery, this.args.model.cards);
  }

  <template>
    <div class="set-page">
      <div class="set-header">
        <h1>{{@model.set.Name}}</h1>
        <div class="set-actions">
          <div class="set-filter-wrap">
            <SearchBar 
              @local={{true}} 
              @onInput={{this.updateLocalSearch}} 
              @placeholder="Filter this set (e.g. 't:ally')..."
            />
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
      </div>

      {{#if this.filteredCards}}
        <div class="cards-grid mode-{{this.displayMode}}">
          {{#each this.filteredCards as |card|}}
            <CardDisplay @card={{card}} @mode={{this.displayMode}} @setId={{@model.set.Id}} />
          {{/each}}
        </div>
      {{else}}
        <div class="no-results">
          No cards in this set match "{{this.localSearchQuery}}" 🕸️
        </div>
      {{/if}}
    </div>

    <style>
      .set-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid #eee;
        flex-wrap: wrap;
        gap: 1rem;
      }
      .set-actions {
        display: flex;
        align-items: center;
        gap: 1.5rem;
        flex-grow: 1;
        justify-content: flex-end;
      }
      .set-filter-wrap {
        width: 100%;
        max-width: 400px;
      }
      .view-controls {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        white-space: nowrap;
      }
      .view-controls select {
        padding: 0.4rem;
        border-radius: 4px;
        border: 1px solid #ccc;
      }
      .cards-grid {
        display: grid;
        gap: 1.5rem;
      }
      .cards-grid.mode-image, .cards-grid.mode-text {
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      }
      .cards-grid.mode-full {
        grid-template-columns: 1fr;
      }
      .no-results {
        padding: 3rem;
        text-align: center;
        background: white;
        border-radius: 12px;
        border: 1px dashed #ddd;
        color: #666;
      }
    </style>
  </template>
}
