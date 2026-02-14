import Component from '@glimmer/component';
import { eq, or, not } from 'ember-truth-helpers';
import { action } from '@ember/object';

export default class CardDisplay extends Component {
  get imageUrl() {
    return `https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/${this.args.card.Id}.jpg`;
  }

  get classColor() {
    const cl = (this.args.card.Classification || '').toLowerCase();
    if (cl.includes('aggression')) return 'var(--color-aggression)';
    if (cl.includes('justice')) return 'var(--color-justice)';
    if (cl.includes('leadership')) return 'var(--color-leadership)';
    if (cl.includes('protection')) return 'var(--color-protection)';
    if (cl.includes('hero') || cl.includes('alter-ego')) return 'var(--color-hero)';
    return 'var(--color-basic)';
  }

  get flavorText() {
    const card = this.args.card;
    const setId = this.args.setId;
    if (setId) {
      const printing = card.Printings?.find(p => p.SetId === setId);
      if (printing?.Flavor) return printing.Flavor;
    }
    return card.Printings?.find(p => p.Flavor)?.Flavor;
  }

  get hasStats() {
    const c = this.args.card;
    return c.Attack || c.Thwart || c.Defense || c.Scheme || c.Health || c.Hand || c.Recover;
  }

  <template>
    <div class="card-container mode-{{or @mode 'full'}}" style={{this.borderStyle}}>
      {{#if (or (eq @mode 'image') (eq @mode 'full') (not @mode))}}
        <div class="card-image-wrapper">
          <img src={{this.imageUrl}} alt={{@card.Name}} loading="lazy" />
        </div>
      {{/if}}

      {{#if (or (eq @mode 'text') (eq @mode 'full') (not @mode))}}
        <div class="card-text-form" style={{this.textBorderColor}}>
          <div class="card-header">
            <div class="card-title">
              <span class="card-type-tag" style={{this.tagStyle}}>{{@card.Type}}</span>
              <h4>{{@card.Name}}</h4>
              {{#if @card.Subname}}<div class="subname">{{@card.Subname}}</div>{{/if}}
            </div>
            <div class="card-cost-circle">
              {{#if @card.Cost}}
                <span class="cost">{{@card.Cost}}</span>
              {{else}}
                <span class="cost no-cost">-</span>
              {{/if}}
            </div>
          </div>

          <div class="card-body">
            {{#if @card.Traits}}
              <div class="traits">
                {{#each @card.Traits as |trait|}}
                  <span class="trait-pill">{{trait}}</span>
                {{/each}}
              </div>
            {{/if}}

            <div class="rules">{{@card.Rules}}</div>

            {{#if this.flavorText}}
              <div class="flavor">{{this.flavorText}}</div>
            {{/if}}

            {{#if @card.Resource}}
              <div class="resource-tag">
                <span class="res-label">Resource:</span> {{@card.Resource}}
              </div>
            {{/if}}

            {{#if this.hasStats}}
              <div class="stats-grid">
                {{#if @card.Thwart}}<div class="stat-box"><strong>THW</strong> {{@card.Thwart}}</div>{{/if}}
                {{#if @card.Attack}}<div class="stat-box"><strong>ATK</strong> {{@card.Attack}}</div>{{/if}}
                {{#if @card.Defense}}<div class="stat-box"><strong>DEF</strong> {{@card.Defense}}</div>{{/if}}
                {{#if @card.Scheme}}<div class="stat-box"><strong>SCH</strong> {{@card.Scheme}}</div>{{/if}}
                {{#if @card.Recover}}<div class="stat-box"><strong>REC</strong> {{@card.Recover}}</div>{{/if}}
                {{#if @card.Health}}<div class="stat-box accent"><strong>HP</strong> {{@card.Health}}</div>{{/if}}
                {{#if @card.Hand}}<div class="stat-box"><strong>Hand</strong> {{@card.Hand}}</div>{{/if}}
              </div>
            {{/if}}
          </div>
          
          <div class="card-footer">
            <span class="classification" style={{this.footerStyle}}>{{@card.Classification}}</span>
          </div>
        </div>
      {{/if}}
    </div>

    <style>
      .card-container {
        background: var(--card-bg);
        border-radius: 16px;
        overflow: hidden;
        display: flex;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.25s;
        border: 1px solid var(--border);
      }
      .card-container:hover {
        transform: translateY(-4px);
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
      }

      .mode-image { flex-direction: column; }
      .mode-text { flex-direction: column; min-height: 300px; }
      
      .mode-full { flex-direction: column; }
      @media (min-width: 900px) {
        .mode-full { flex-direction: row; }
        .mode-full .card-image-wrapper { width: 350px; flex-shrink: 0; }
        .mode-full .card-text-form { flex-grow: 1; border-left: 1px solid var(--border); }
      }

      .card-image-wrapper { background: #000; overflow: hidden; }
      .card-image-wrapper img {
        width: 100%;
        height: auto;
        display: block;
        transition: opacity 0.3s;
      }

      .card-text-form {
        padding: 1.5rem;
        display: flex;
        flex-direction: column;
        gap: 1.25rem;
        position: relative;
      }

      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
      }
      .card-type-tag {
        font-size: 0.65rem;
        font-weight: 900;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        padding: 0.2rem 0.5rem;
        border-radius: 4px;
        margin-bottom: 0.5rem;
        display: inline-block;
      }
      .card-title h4 { margin: 0; font-size: 1.4rem; line-height: 1.1; }
      .subname { font-size: 0.9rem; color: var(--text-muted); font-style: italic; margin-top: 0.2rem; }
      
      .card-cost-circle {
        background: var(--primary);
        color: white;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        font-weight: 900;
        font-size: 1.2rem;
        flex-shrink: 0;
        box-shadow: inset 0 2px 4px rgba(0,0,0,0.3);
      }
      .no-cost { opacity: 0.5; font-size: 1rem; }

      .traits { display: flex; flex-wrap: wrap; gap: 0.4rem; }
      .trait-pill {
        font-weight: 700;
        font-size: 0.75rem;
        background: #f1f2f6;
        padding: 0.2rem 0.6rem;
        border-radius: 12px;
        color: var(--primary);
      }

      .rules { 
        white-space: pre-wrap; 
        font-size: 1rem; 
        line-height: 1.6; 
        color: #2d3436; 
        background: #f9f9f9;
        padding: 1rem;
        border-radius: 8px;
        border-left: 4px solid var(--border);
      }
      
      .flavor {
        font-style: italic;
        color: var(--text-muted);
        font-size: 0.9rem;
        line-height: 1.4;
        padding: 0 0.5rem;
      }

      .resource-tag { 
        font-size: 0.9rem;
        background: #fff5eb;
        color: #d35400;
        padding: 0.5rem;
        border-radius: 6px;
        font-weight: 700;
      }
      .res-label { opacity: 0.7; font-weight: 400; }

      .stats-grid {
        margin-top: auto;
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(70px, 1fr));
        gap: 0.5rem;
      }
      .stat-box {
        background: white;
        padding: 0.5rem;
        border-radius: 8px;
        text-align: center;
        font-weight: 800;
        border: 1px solid var(--border);
        font-size: 1.1rem;
      }
      .stat-box strong { font-size: 0.65rem; display: block; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.1rem; }
      .stat-box.accent { border-color: var(--accent); color: var(--accent); }

      .card-footer {
        margin-top: 0.5rem;
        display: flex;
        justify-content: flex-end;
      }
      .classification {
        font-size: 0.7rem;
        font-weight: 900;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        opacity: 0.8;
      }
    </style>
  </template>

  get borderStyle() {
    return `border-top: 6px solid ${this.classColor}`;
  }
  
  get tagStyle() {
    return `background: ${this.classColor}20; color: ${this.classColor}`;
  }

  get footerStyle() {
    return `color: ${this.classColor}`;
  }
}
