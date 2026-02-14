import { LinkTo } from '@ember/routing';
import SearchBar from '../components/search-bar';

<template>
  <div class="home-container">
    <header class="hero">
      <div class="hero-content">
        <h1>Worldmind</h1>
        <p class="tagline">The definitive Marvel Champions collection database.</p>
        
        <div class="search-wrap">
          <SearchBar />
        </div>
      </div>
    </header>

    <div class="browse-grid">
      <LinkTo @route="packs" class="browse-card packs">
        <div class="card-icon">📦</div>
        <div class="card-info">
          <h3>Browse Packs</h3>
          <p>Explore official releases in chronological order.</p>
        </div>
        <div class="card-arrow">→</div>
      </LinkTo>
      
      <LinkTo @route="sets" class="browse-card sets">
        <div class="card-icon">🛡️</div>
        <div class="card-info">
          <h3>Browse Sets</h3>
          <p>Find specific heroes, villains, and modular encounters.</p>
        </div>
        <div class="card-arrow">→</div>
      </LinkTo>
    </div>

    <style>
      .home-container {
        max-width: 1000px;
        margin: 0 auto;
        padding: 2rem 0;
      }
      .hero {
        text-align: center;
        padding: 4rem 1rem;
        background: white;
        border-radius: 24px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        margin-bottom: 3rem;
      }
      .hero h1 {
        font-size: 4rem;
        margin: 0;
        letter-spacing: -0.05em;
        background: linear-gradient(135deg, #2c3e50 0%, #000000 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
      }
      .tagline {
        font-size: 1.25rem;
        color: var(--text-muted);
        margin-bottom: 3rem;
      }
      .search-wrap {
        max-width: 600px;
        margin: 0 auto;
      }

      .browse-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2rem;
      }
      .browse-card {
        display: flex;
        align-items: center;
        padding: 2rem;
        background: white;
        border-radius: 20px;
        text-decoration: none;
        color: inherit;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid var(--border);
        position: relative;
      }
      .browse-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        border-color: #3498db;
      }
      .browse-card.packs:hover { border-color: var(--accent); }

      .card-icon {
        font-size: 3rem;
        margin-right: 1.5rem;
      }
      .card-info h3 { margin: 0; font-size: 1.5rem; }
      .card-info p { margin: 0.5rem 0 0 0; color: var(--text-muted); }
      .card-arrow {
        margin-left: auto;
        font-size: 1.5rem;
        opacity: 0.3;
        transition: transform 0.3s;
      }
      .browse-card:hover .card-arrow {
        transform: translateX(5px);
        opacity: 1;
        color: var(--accent);
      }

      @media (max-width: 768px) {
        .browse-grid { grid-template-columns: 1fr; }
        .hero h1 { font-size: 2.5rem; }
      }
    </style>
  </div>
</template>
