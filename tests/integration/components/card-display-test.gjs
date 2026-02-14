import { module, test } from 'qunit';
import { setupRenderingTest } from 'worldmind/tests/helpers';
import { render } from '@ember/test-helpers';
import CardDisplay from 'worldmind/components/card-display';

module('Integration | Component | card-display', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    this.card = {
      Id: 'hero-1',
      Name: 'Spider-Man',
      Type: 'Hero',
      Classification: 'Hero',
      Rules: 'Great responsibility.'
    };

    await render(<template><CardDisplay @card={{this.card}} /></template>);

    assert.dom('.card-title h4').hasText('Spider-Man');
    assert.dom('.rules').hasText('Great responsibility.');
  });
});
