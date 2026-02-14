<template>
  <div class="guide">
    <h1>Advanced Search Syntax</h1>
    <p>Worldmind supports a powerful Scryfall-style syntax for finding exactly the cards you need.</p>

    <section>
      <h2>Basic Search</h2>
      <p>Enter any text to search card names, subnames, traits, and rules text.</p>
      <div class="example"><code>Avenger</code> - Finds cards with "Avenger" in the name or traits.</div>
      <div class="example"><code>"Captain America"</code> - Use quotes to search for exact phrases.</div>
    </section>

    <section>
      <h2>Property Prefixes</h2>
      <p>Use <code>key:value</code> to search specific fields. You can also use <code>=</code> instead of <code>:</code>.</p>
      <table class="syntax-table">
        <thead>
          <tr>
            <th>Prefix</th>
            <th>Description</th>
            <th>Example</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><code>n:</code>, <code>name:</code></td>
            <td>Card Name</td>
            <td><code>name:stark</code></td>
          </tr>
          <tr>
            <td><code>t:</code>, <code>type:</code></td>
            <td>Card Type</td>
            <td><code>t:ally</code></td>
          </tr>
          <tr>
            <td><code>tr:</code>, <code>trait:</code></td>
            <td>Traits</td>
            <td><code>tr:avenger</code></td>
          </tr>
          <tr>
            <td><code>cl:</code>, <code>class:</code></td>
            <td>Classification</td>
            <td><code>cl:aggression</code></td>
          </tr>
          <tr>
            <td><code>s:</code>, <code>set:</code></td>
            <td>Set Name</td>
            <td><code>s:rhino</code>, <code>s:"core set"</code></td>
          </tr>
          <tr>
            <td><code>x:</code>, <code>rules:</code></td>
            <td>Rules Text</td>
            <td><code>x:stun</code></td>
          </tr>
        </tbody>
      </table>
    </section>

    <section>
      <h2>Numeric Comparisons</h2>
      <p>For numeric fields, you can use <code>:</code>, <code>=</code>, <code>&lt;</code>, <code>&gt;</code>, <code>&lt;=</code>, <code>&gt;=</code>, and <code>!=</code>.</p>
      <table class="syntax-table">
        <thead>
          <tr>
            <th>Prefix</th>
            <th>Description</th>
            <th>Example</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><code>c:</code>, <code>cost:</code></td>
            <td>Card Cost</td>
            <td><code>c&lt;2</code>, <code>c:0</code></td>
          </tr>
          <tr>
            <td><code>h:</code>, <code>hp:</code></td>
            <td>Health Points</td>
            <td><code>hp&gt;=10</code></td>
          </tr>
          <tr>
            <td><code>a:</code>, <code>atk:</code></td>
            <td>Attack</td>
            <td><code>atk:2</code>, <code>atk&gt;1</code></td>
          </tr>
          <tr>
            <td><code>th:</code>, <code>thw:</code></td>
            <td>Thwart</td>
            <td><code>thw:2</code></td>
          </tr>
          <tr>
            <td><code>d:</code>, <code>def:</code></td>
            <td>Defense</td>
            <td><code>def:3</code></td>
          </tr>
          <tr>
            <td><code>b:</code></td>
            <td>Boost Icons</td>
            <td><code>b:2</code>, <code>b&gt;1</code></td>
          </tr>
          <tr>
            <td><code>bs:</code></td>
            <td>Boost Star</td>
            <td><code>bs:yes</code>, <code>bs:no</code></td>
          </tr>
        </tbody>
      </table>
    </section>

    <section>
      <h2>Logical Operators</h2>
      <h3>OR Logic (Comma)</h3>
      <p>Use a comma within a single tag to find any of the values.</p>
      <div class="example"><code>cl:justice,leadership</code> - Finds Justice OR Leadership cards.</div>

      <h3>AND Logic (Space)</h3>
      <p>Separate multiple tags with spaces to find cards that match <strong>all</strong> conditions.</p>
      <div class="example"><code>t:ally tr:avenger c&lt;3</code> - Finds Avenger allies that cost less than 3.</div>
    </section>
  </div>

  <style>
    .guide {
      max-width: 800px;
      margin: 0 auto;
      background: white;
      padding: 2rem;
      border-radius: 12px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    h1 { color: #2c3e50; border-bottom: 2px solid #eee; padding-bottom: 0.5rem; }
    h2 { color: #3498db; margin-top: 2rem; }
    h3 { margin-bottom: 0.5rem; }
    p { color: #555; }
    .example {
      background: #f8f9fa;
      padding: 0.75rem;
      border-left: 4px solid #3498db;
      margin: 0.5rem 0;
      font-family: monospace;
    }
    code {
      background: #eee;
      padding: 0.2rem 0.4rem;
      border-radius: 4px;
      font-weight: bold;
    }
    .syntax-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
    }
    .syntax-table th, .syntax-table td {
      text-align: left;
      padding: 0.75rem;
      border-bottom: 1px solid #eee;
    }
    .syntax-table th { background: #f8f9fa; }
  </style>
</template>