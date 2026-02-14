import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';
import { eq } from 'ember-truth-helpers';
import { fn } from '@ember/helper';

export default class SetsViewer extends Component {
  @tracked searchQuery = '';
  @tracked activeType = 'All';

  types = ['All', 'Hero Set', 'Villain Set', 'Modular Set', 'Nemesis Set', 'Campaign Set'];

  get filteredSets() {
    let sets = this.args.model.sets;

    if (this.activeType !== 'All') {
      sets = sets.filter(s => s.Type === this.activeType);
    }

    if (this.searchQuery) {
      const query = this.searchQuery.toLowerCase();
      sets = sets.filter(s => s.Name.toLowerCase().includes(query));
    }

    return sets;
  }

  updateSearch = (event) => {
    this.searchQuery = event.target.value;
  };

  setType = (type) => {
    this.activeType = type;
  };

  <template>
    <div class="sets-header">
      <h1>Official Sets</h1>
      
      <div class="filter-controls">
        <input 
          type="text" 
          placeholder="Search sets by name..." 
          class="set-search"
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

    {{#if this.filteredSets}}
      <div class="sets-grid">
        {{#each this.filteredSets as |set|}}
          <LinkTo @route="set" @model={{set.Id}} class="set-card">
            <h3>{{set.Name}}</h3>
            <span class="badge">{{set.Type}}</span>
          </LinkTo>
        {{/each}}
      </div>
    {{else}}
      <div class="no-results">
        <p>No sets found matching your criteria. 🕸️</p>
      </div>
    {{/if}}

    <style>
      .sets-header {
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
      .set-search {
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
        border: 1px solid #3498db;
        background: transparent;
        color: #3498db;
        border-radius: 20px;
        cursor: pointer;
        font-size: 0.9rem;
        transition: all 0.2s;
      }
      .filter-btn:hover {
        background: #ebf5fb;
      }
      .filter-btn.active {
        background: #3498db;
        color: white;
      }
      .sets-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 1.5rem;
      }
      .set-card {
        border: 1px solid #ddd;
        padding: 1.5rem;
        border-radius: 12px;
        text-decoration: none;
        color: #333;
        transition: transform 0.2s, box-shadow 0.2s;
        background: white;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
      }
      .set-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        border-color: #3498db;
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
