import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { LinkTo } from '@ember/routing';
import { eq, and, or } from 'ember-truth-helpers';
import { fn } from '@ember/helper';

export default class SearchBar extends Component {
  @service cerebroApi;
  @service router;
  
  @tracked query = this.args.initialQuery || '';
  @tracked activeSuggestionIndex = -1;
  @tracked showSuggestions = false;

  get currentWord() {
    const parts = this.query.split(/\s+/);
    return parts[parts.length - 1];
  }

  get suggestions() {
    const word = this.currentWord;
    if (!word) return [];

    const meta = this.cerebroApi.syntaxMeta;
    
    if (word.includes(':')) {
      const [key, value] = word.split(':');
      const keyMeta = meta[key.toLowerCase()];
      if (keyMeta && keyMeta.values) {
        return keyMeta.values
          .filter(v => v.toLowerCase().includes(value.toLowerCase()))
          .slice(0, 10)
          .map(v => ({
            label: v,
            value: `${key}:${v}`,
            type: 'value',
            description: keyMeta.name
          }));
      }
    }

    return Object.entries(meta)
      .filter(([key]) => key.startsWith(word.toLowerCase()))
      .map(([key, m]) => ({
        label: `${key}:`,
        value: `${key}:`,
        type: 'prefix',
        description: m.name
      }));
  }

  @action
  updateQuery(event) {
    this.query = event.target.value;
    this.showSuggestions = true;
    this.activeSuggestionIndex = -1;
    
    // If we're in "local" mode, notify the parent component immediately
    if (this.args.onInput) {
      this.args.onInput(this.query);
    }
  }

  @action
  handleKeyDown(event) {
    if (!this.showSuggestions || this.suggestions.length === 0) return;

    if (event.key === 'ArrowDown') {
      event.preventDefault();
      this.activeSuggestionIndex = Math.min(this.activeSuggestionIndex + 1, this.suggestions.length - 1);
    } else if (event.key === 'ArrowUp') {
      event.preventDefault();
      this.activeSuggestionIndex = Math.max(this.activeSuggestionIndex - 1, 0);
    } else if (event.key === 'Enter' && this.activeSuggestionIndex >= 0) {
      event.preventDefault();
      this.selectSuggestion(this.suggestions[this.activeSuggestionIndex]);
    } else if (event.key === 'Escape') {
      this.showSuggestions = false;
    }
  }

  @action
  selectSuggestion(suggestion) {
    const words = this.query.split(/\s+/);
    words[words.length - 1] = suggestion.value;
    this.query = words.join(' ') + ' ';
    this.showSuggestions = false;
    
    if (this.args.onInput) {
      this.args.onInput(this.query);
    }
  }

  @action
  submitSearch(event) {
    event.preventDefault();
    this.showSuggestions = false;
    
    // Only navigate if we're NOT in local mode
    if (!this.args.onInput) {
      this.router.transitionTo('search', { queryParams: { q: this.query.trim() } });
    }
  }

  <template>
    <div class="search-container {{if @local 'is-local'}}">
      <form {{on "submit" this.submitSearch}} class="search-form">
        <div class="input-group">
          <input 
            type="text" 
            value={{this.query}} 
            {{on "input" this.updateQuery}}
            {{on "keydown" this.handleKeyDown}}
            placeholder={{or @placeholder "Search (e.g. 't:ally tr:avenger')..."}}
            autocomplete="off"
          />
          <LinkTo @route="search-guide" class="help-link" title="Search Syntax Guide">?</LinkTo>
        </div>
        {{#unless @local}}
          <button type="submit">Search</button>
        {{/unless}}
      </form>

      {{#if (and this.showSuggestions this.suggestions.length)}}
        <div class="suggestions-dropdown">
          {{#each this.suggestions as |suggestion index|}}
            <button 
              type="button"
              class="suggestion-item {{if (eq this.activeSuggestionIndex index) 'active'}}"
              {{on "click" (fn this.selectSuggestion suggestion)}}
            >
              <span class="suggestion-label">{{suggestion.label}}</span>
              <span class="suggestion-meta">
                <span class="suggestion-type">{{suggestion.type}}</span>
                <span class="suggestion-desc">{{suggestion.description}}</span>
              </span>
            </button>
          {{/each}}
        </div>
      {{/if}}
    </div>

    <style>
      .search-container { position: relative; width: 100%; }
      .search-form { display: flex; gap: 0.5rem; }
      
      .is-local .search-form { margin-bottom: 0; }
      .is-local .input-group input { border-radius: 20px; padding: 0.6rem 2.5rem 0.6rem 1rem; }

      .input-group { flex: 1; position: relative; display: flex; align-items: center; }
      .input-group input {
        width: 100%;
        padding: 0.75rem 2.5rem 0.75rem 0.75rem;
        font-size: 1rem;
        border: 2px solid var(--border);
        border-radius: 8px;
        outline: none;
        background: white;
      }
      .input-group input:focus { border-color: #3498db; }
      
      .help-link {
        position: absolute;
        right: 0.75rem;
        background: #eee;
        width: 1.4rem;
        height: 1.4rem;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        text-decoration: none;
        color: #666;
        font-size: 0.9rem;
      }

      .suggestions-dropdown {
        position: absolute;
        top: calc(100% + 4px);
        left: 0;
        right: 0;
        background: white;
        border: 1px solid var(--border);
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        z-index: 1000;
        overflow: hidden;
        max-height: 300px;
        overflow-y: auto;
      }
      .suggestion-item {
        width: 100%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 1.25rem;
        border: none;
        background: transparent;
        text-align: left;
        cursor: pointer;
        border-bottom: 1px solid #f8f9fa;
      }
      .suggestion-item:last-child { border-bottom: none; }
      .suggestion-item.active, .suggestion-item:hover { background: #f0f7ff; }
      .suggestion-label { font-weight: 700; color: var(--primary); font-family: monospace; }
      .suggestion-meta { font-size: 0.75rem; color: var(--text-muted); display: flex; gap: 0.5rem; align-items: center; }
      .suggestion-type { background: #eee; padding: 0.1rem 0.4rem; border-radius: 4px; text-transform: uppercase; font-size: 0.65rem; font-weight: 800; }

      .search-form button {
        padding: 0.5rem 1.5rem;
        background: #3498db;
        color: white;
        border: none;
        border-radius: 8px;
        font-weight: 700;
        cursor: pointer;
      }
    </style>
  </template>
}
