import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class CerebroApiService extends Service {
  API_BASE = 'https://cerebro-beta-bot.herokuapp.com';

  @tracked cards = [];
  @tracked packs = [];
  @tracked sets = [];
  @tracked loading = false;

  async fetchData(endpoint) {
    const response = await fetch(`${this.API_BASE}${endpoint}`);
    if (!response.ok) {
      throw new Error(`Failed to fetch ${endpoint}`);
    }
    return response.json();
  }

  async loadAll() {
    if (this.cards.length > 0) return;
    
    this.loading = true;
    try {
      const [cards, packs, sets] = await Promise.all([
        this.fetchData('/cards'),
        this.fetchData('/packs'),
        this.fetchData('/sets')
      ]);

      // Filter for official cards only as requested
      this.cards = cards.filter(c => c.Official);
      this.packs = packs.filter(p => p.Official);
      const officialSets = sets.filter(s => s.Official);

      // Create a map of PackId -> Number for sorting
      const packOrderMap = {};
      this.packs.forEach(p => {
        packOrderMap[p.Id] = parseInt(p.Number || '999', 10);
      });

      // For each set, find the minimum ArtificialId among its cards that match the set's PackId
      officialSets.forEach(set => {
        const matchingArtificialIds = this.cards.flatMap(card => 
          (card.Printings || [])
            .filter(p => p.SetId === set.Id && p.PackId === set.PackId)
            .map(p => p.ArtificialId)
        ).filter(Boolean);

        // We use string sorting for ArtificialId
        set.sortKey = matchingArtificialIds.length > 0 
          ? matchingArtificialIds.sort()[0] 
          : 'ZZZZZ'; 
      });

      // Sort sets by pack order, then by their minimum ArtificialId in that pack
      this.sets = officialSets.sort((a, b) => {
        const packA = packOrderMap[a.PackId] || 999;
        const packB = packOrderMap[b.PackId] || 999;

        if (packA !== packB) {
          return packA - packB;
        }
        
        return a.sortKey.localeCompare(b.sortKey);
      });

      // Collect unique values for autocomplete
      this._traits = [...new Set(this.cards.flatMap(c => c.Traits || []))].sort();
      this._types = [...new Set(this.cards.map(c => c.Type))].filter(Boolean).sort();
      this._classes = [...new Set(this.cards.map(c => c.Classification))].filter(Boolean).sort();

      // Create a map for set lookup by name
      this._setMap = {};
      this.sets.forEach(s => {
        this._setMap[s.Id] = s.Name;
      });
    } catch (error) {
      console.error('Error loading Cerebro data:', error);
    } finally {
      this.loading = false;
    }
  }

  get availableTraits() { return this._traits || []; }
  get availableTypes() { return this._types || []; }
  get availableClasses() { return this._classes || []; }
  get availableSets() { return this.sets.map(s => s.Name).sort(); }

  // Metadata for syntax hints
  get syntaxMeta() {
    return {
      't': { name: 'Type', description: 'Ally, Event, Upgrade, etc.', values: this.availableTypes },
      'tr': { name: 'Trait', description: 'Avenger, Mutant, Shield, etc.', values: this.availableTraits },
      'cl': { name: 'Classification', description: 'Aggression, Justice, Leadership, etc.', values: this.availableClasses },
      's': { name: 'Set', description: 'Search by set name (e.g. s:rhino)', values: this.availableSets },
      'c': { name: 'Cost', description: 'Number (e.g. c:0, c<3)', values: [] },
      'hp': { name: 'Health', description: 'Number (e.g. hp>=10)', values: [] },
      'n': { name: 'Name', description: 'Exact name of the card', values: [] },
      'x': { name: 'Text', description: 'Search rules text for keywords', values: [] },
      'atk': { name: 'Attack', description: 'Attack stat (e.g. atk:2)', values: [] },
      'thw': { name: 'Thwart', description: 'Thwart stat (e.g. thw:2)', values: [] },
      'def': { name: 'Defense', description: 'Defense stat (e.g. def:3)', values: [] },
      'b': { name: 'Boost', description: 'Number of boost icons (e.g. b:2, b>1)', values: [] },
      'bs': { name: 'Boost Star', description: 'Has star icon (bs:yes / bs:no)', values: ['yes', 'no'] },
    };
  }

  @tracked cacheProgress = 0;
  @tracked isCaching = false;

  async precacheAll() {
    if (this.isCaching) return;
    this.isCaching = true;
    this.cacheProgress = 0;

    try {
      // 1. Ensure API data is loaded and cached
      await this.loadAll();
      this.cacheProgress = 5;

      const total = this.cards.length;
      let count = 0;

      // 2. Batch-fetch images to populate the cache
      const batchSize = 10;
      for (let i = 0; i < total; i += batchSize) {
        const batch = this.cards.slice(i, i + batchSize);
        await Promise.all(batch.map(async (card) => {
          const url = `https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/${card.Id}.jpg`;
          try {
            await fetch(url, { mode: 'no-cors' }); 
          } catch (e) {
            // Ignore failures for individual images
          }
          count++;
        }));
        
        this.cacheProgress = 5 + Math.round((count / total) * 95);
      }
    } finally {
      // Small delay so the user sees the 100% completion
      setTimeout(() => {
        this.isCaching = false;
        this.cacheProgress = 0;
      }, 2000);
    }
  }

  getCardsBySet(setId) {
    return this.cards.filter(card => {
      return card.Printings?.some(p => p.SetId === setId);
    });
  }

  searchCards(query, cardsToSearch = null) {
    if (!query) return cardsToSearch || this.cards;
    
    const sourceCards = cardsToSearch || this.cards;
    const parts = query.match(/(?:[^\s"]+|"[^"]*")+/g) || [];
    
    return sourceCards.filter(card => {
      return parts.every(part => {
        // Match key, operator, and value. Operators: :, =, <, >, <=, >=
        const match = part.match(/^([\w-]+)([:=<>!]+)(.*)$/);
        
        if (match) {
          const key = match[1].toLowerCase();
          const op = match[2];
          const rawValue = match[3].replace(/^"(.*)"$/, '$1').toLowerCase();
          const values = rawValue.split(','); // Support OR via commas

          const compare = (cardValue, searchVal, operator) => {
            // Special handling for boost icons - count the {b} occurrences
            let cVal;
            if (key === 'b' || key === 'boost') {
              cVal = (cardValue || '').split('{b}').length - 1;
            } else {
              cVal = parseInt(cardValue, 10);
            }
            
            const sVal = parseInt(searchVal, 10);
            
            if (isNaN(cVal) || isNaN(sVal)) {
              if (operator === ':' || operator === '=') return (cardValue || '').toLowerCase().includes(searchVal);
              return false;
            }

            switch (operator) {
              case '<': return cVal < sVal;
              case '>': return cVal > sVal;
              case '<=': return cVal <= sVal;
              case '>=': return cVal >= sVal;
              case '=':
              case ':': return cVal === sVal;
              case '!=': return cVal !== sVal;
              default: return false;
            }
          };

          return values.some(val => {
            switch (key) {
              case 'n':
              case 'name':
                return card.Name?.toLowerCase().includes(val);
              case 't':
              case 'type':
                return card.Type?.toLowerCase().includes(val);
              case 's':
              case 'set':
                return (card.Printings || []).some(p => {
                  const setName = this._setMap[p.SetId] || '';
                  return setName.toLowerCase().includes(val);
                });
              case 'tr':
              case 'trait':
              case 'traits':
                return card.Traits?.some(t => t.toLowerCase().includes(val));
              case 'c':
              case 'cost':
                return compare(card.Cost, val, op);
              case 'cl':
              case 'class':
              case 'classification':
                return card.Classification?.toLowerCase().includes(val);
              case 'r':
              case 'rules':
              case 'x':
              case 'text':
                return card.Rules?.toLowerCase().includes(val);
              case 'h':
              case 'hp':
              case 'health':
                return compare(card.Health, val, op);
              case 'a':
              case 'atk':
              case 'attack':
                return compare(card.Attack, val, op);
              case 'th':
              case 'thw':
              case 'thwart':
                return compare(card.Thwart, val, op);
              case 'd':
              case 'def':
              case 'defense':
                return compare(card.Defense, val, op);
              case 's':
              case 'sch':
              case 'scheme':
                return compare(card.Scheme, val, op);
              case 'b':
              case 'boost':
                return compare(card.Boost, val, op);
              case 'bs':
              case 'star':
                const hasStar = (card.Boost || '').includes('{s}');
                return val === 'yes' || val === 'true' || val === '1' ? hasStar : !hasStar;
              default:
                return true;
            }
          });
        } else {
          const lowerPart = part.replace(/^"(.*)"$/, '$1').toLowerCase();
          return card.Name?.toLowerCase().includes(lowerPart) ||
                 card.Subname?.toLowerCase().includes(lowerPart) ||
                 card.Traits?.some(t => t.toLowerCase().includes(lowerPart)) ||
                 card.Rules?.toLowerCase().includes(lowerPart);
        }
      });
    });
  }
}