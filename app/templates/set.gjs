import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import CardDisplay from '../components/card-display';

export default class SetView extends Component {
  @tracked displayMode = 'image'; // Default to images for sets

  @action
  setDisplayMode(event) {
    this.displayMode = event.target.value;
  }

  <template>
    <div class="set-page">
      <div class="set-header">
        <h1>{{@model.set.Name}}</h1>
        <div class="view-controls">
          <label for="display-mode">View:</label>
          <select id="display-mode" {{on "change" this.setDisplayMode}}>
            <option value="image">Images Only</option>
            <option value="text">Text Only</option>
            <option value="full">Full (Image + Text)</option>
          </select>
        </div>
      </div>

      <div class="cards-grid mode-{{this.displayMode}}">
        {{#each @model.cards as |card|}}
          <CardDisplay @card={{card}} @mode={{this.displayMode}} @setId={{@model.set.Id}} />
        {{/each}}
      </div>
    </div>

    <style>
      .set-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid #eee;
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
    </style>
  </template>
}
