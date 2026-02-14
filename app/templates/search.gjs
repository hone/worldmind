import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import SearchBar from '../components/search-bar';
import CardDisplay from '../components/card-display';

export default class SearchView extends Component {
  @tracked displayMode = 'full';

  @action
  setDisplayMode(event) {
    this.displayMode = event.target.value;
  }

  <template>
    <div class="search-page">
      <div class="search-header">
        <h1>Search Cards</h1>
        <div class="view-controls">
          <label for="display-mode">View:</label>
          <select id="display-mode" {{on "change" this.setDisplayMode}}>
            <option value="full">Full (Image + Text)</option>
            <option value="image">Images Only</option>
            <option value="text">Text Only</option>
          </select>
        </div>
      </div>
      
      <SearchBar @initialQuery={{@model.query}} />

      {{#if @model.query}}
        <div class="results-info">
          Found {{@model.results.length}} results for "{{@model.query}}"
        </div>
        
        <div class="results-grid mode-{{this.displayMode}}">
          {{#each @model.results as |card|}}
            <CardDisplay @card={{card}} @mode={{this.displayMode}} />
          {{/each}}
        </div>
      {{/if}}
    </div>

    <style>
      .search-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
      }
      .view-controls {
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }
      .view-controls select {
        padding: 0.4rem;
        border-radius: 4px;
        border: 1px solid #ccc;
      }
      .results-info {
        margin-bottom: 1.5rem;
        color: #666;
        font-style: italic;
      }
      
      .results-grid {
        display: grid;
        gap: 1.5rem;
      }
      .results-grid.mode-image, .results-grid.mode-text {
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      }
      .results-grid.mode-full {
        grid-template-columns: 1fr;
      }
    </style>
  </template>
}
