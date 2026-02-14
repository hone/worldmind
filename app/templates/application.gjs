import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import Component from '@glimmer/component';

export default class Application extends Component {
  @service cerebroApi;

  get progressStyle() {
    return `width: ${this.cerebroApi.cacheProgress}%`;
  }

  startSync = () => {
    this.cerebroApi.precacheAll();
  }

  <template>
    {{pageTitle "Worldmind"}}
    
    <nav class="navbar">
      <div class="nav-left">
        <LinkTo @route="index" class="nav-brand">
          <span class="logo-icon">💠</span> Worldmind
        </LinkTo>
        <div class="nav-links">
          <LinkTo @route="packs">Packs</LinkTo>
          <LinkTo @route="sets">Sets</LinkTo>
          <LinkTo @route="search">Search</LinkTo>
        </div>
      </div>

      <div class="nav-right">
        {{#if this.cerebroApi.isCaching}}
          <div class="cache-progress">
            <div class="progress-bar">
              <div class="progress-fill" style={{this.progressStyle}}></div>
            </div>
            <span class="progress-text">Syncing {{this.cerebroApi.cacheProgress}}%</span>
          </div>
        {{else}}
          <button type="button" class="sync-btn" {{on "click" this.startSync}} title="Download all data for offline use">
            Sync for Offline
          </button>
        {{/if}}
      </div>
    </nav>

    <main class="container">
      {{outlet}}
    </main>

    <style>
      .navbar {
        background: #1a1a1a;
        color: white;
        padding: 0.5rem 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        height: 64px;
      }
      .nav-left {
        display: flex;
        align-items: center;
        gap: 3rem;
      }
      .navbar a {
        color: #a0a0a0;
        text-decoration: none;
        font-weight: 600;
        font-size: 0.95rem;
        transition: all 0.2s;
        padding: 0.5rem 0;
        border-bottom: 2px solid transparent;
      }
      .navbar a:hover, .navbar a.active {
        color: white;
      }
      .navbar a.active {
        border-bottom-color: var(--accent);
      }
      .nav-brand {
        font-size: 1.4rem;
        font-weight: 900;
        color: white !important;
        letter-spacing: -0.03em;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        border: none !important;
      }
      .logo-icon { font-size: 1.2rem; }
      
      .nav-links {
        display: flex;
        gap: 2rem;
      }
      
      .sync-btn {
        background: transparent;
        border: 1px solid #444;
        color: #fff;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        cursor: pointer;
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        transition: all 0.2s;
      }
      .sync-btn:hover {
        background: white;
        color: black;
        border-color: white;
      }

      .cache-progress {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        gap: 0.3rem;
      }
      .progress-bar {
        width: 150px;
        height: 4px;
        background: #333;
        border-radius: 2px;
        overflow: hidden;
      }
      .progress-fill {
        height: 100%;
        background: #2ecc71;
        box-shadow: 0 0 10px rgba(46, 204, 113, 0.5);
        transition: width 0.3s ease;
      }
      .progress-text {
        font-size: 0.65rem;
        font-weight: 700;
        color: #888;
        text-transform: uppercase;
      }
    </style>
  </template>
}
