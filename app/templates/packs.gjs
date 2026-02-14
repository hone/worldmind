import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';
import { eq } from 'ember-truth-helpers';
import { fn } from '@ember/helper';

export default class PacksViewer extends Component {
  @tracked searchQuery = '';
  @tracked activeType = 'All';

  types = ['All', 'Core Set', 'Hero Pack', 'Campaign Expansion', 'Scenario Pack', 'Supplements'];

  get filteredPacks() {
    let packs = this.args.model;

    if (this.activeType !== 'All') {
      packs = packs.filter(p => p.Type === this.activeType);
    }

    if (this.searchQuery) {
      const query = this.searchQuery.toLowerCase();
      packs = packs.filter(p => p.Name.toLowerCase().includes(query));
    }

    return packs;
  }

  updateSearch = (event) => {
    this.searchQuery = event.target.value;
  };

  setType = (type) => {
    this.activeType = type;
  };

  <template>
    <div class="packs-header">
      <h1>Official Packs</h1>
      
      <div class="filter-controls">
        <input 
          type="text" 
          placeholder="Search packs by name..." 
          class="pack-search"
          value={{this.searchQuery}}
          {{on "input" this.updateSearch}}
        />
        
        <div class="type-filters">
          {{#each this.types as |type|}}
            <button 
              type="button"
              class="filter-btn {{if (eq this.activeType type) 'active'}}"
              {{on "click" (fn this.setType type)}}
            >
              {{type}}
            </button>
          {{/each}}
        </div>
      </div>
    </div>

    {{#if this.filteredPacks}}
      <div class="packs-grid">
        {{#each this.filteredPacks as |pack|}}
          <LinkTo @route="pack" @model={{pack.Id}} class="pack-card">
            <div class="pack-number">#{{pack.Number}}</div>
            <h3>{{pack.Name}}</h3>
            <span class="badge">{{pack.Type}}</span>
          </LinkTo>
        {{/each}}
      </div>
    {{else}}
      <div class="no-results">
        <p>No packs found matching your criteria. 📦</p>
      </div>
    {{/if}}

    <style>
      .packs-header {
        margin-bottom: 2rem;
      }
      .filter-controls {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        background: white;
        padding: 1.5rem;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
      }
      .pack-search {
        padding: 0.75rem;
        font-size: 1rem;
        border: 1px solid #ddd;
        border-radius: 4px;
        width: 100%;
      }
      .type-filters {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
      }
      .filter-btn {
        padding: 0.5rem 1rem;
        border: 1px solid #e74c3c;
        background: transparent;
        color: #e74c3c;
        border-radius: 20px;
        cursor: pointer;
        font-size: 0.9rem;
        transition: all 0.2s;
      }
      .filter-btn:hover {
        background: #fdf2f2;
      }
      .filter-btn.active {
        background: #e74c3c;
        color: white;
      }
      .packs-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 1.5rem;
      }
      .pack-card {
        border: 1px solid #ddd;
        padding: 1.5rem;
        border-radius: 12px;
        text-decoration: none;
        color: #333;
        transition: transform 0.2s, box-shadow 0.2s;
        background: white;
        position: relative;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
      }
      .pack-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        border-color: #e74c3c;
      }
      .pack-number {
        position: absolute;
        top: 1rem;
        right: 1rem;
        font-weight: bold;
        color: #ccc;
      }
      .badge {
        font-size: 0.8rem;
        background: #f0f0f0;
        padding: 0.2rem 0.5rem;
        border-radius: 4px;
        align-self: flex-start;
      }
      .no-results {
        text-align: center;
        padding: 4rem;
        color: #666;
      }
    </style>
  </template>
}
