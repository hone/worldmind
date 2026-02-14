import { module, test } from 'qunit';
import { setupRenderingTest } from 'worldmind/tests/helpers';
import { render } from '@ember/test-helpers';
import SearchBar from 'worldmind/components/search-bar';

module('Integration | Component | search-bar', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    await render(<template><SearchBar /></template>);

    assert.dom('input').exists();
    assert.dom('input').hasAttribute('placeholder', "Search (e.g. 't:ally tr:avenger')...");
  });
});
