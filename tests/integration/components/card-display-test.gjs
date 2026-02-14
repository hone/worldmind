import { module, test } from 'qunit';
import { setupRenderingTest } from 'worldmind/tests/helpers';
import { render } from '@ember/test-helpers';
import CardDisplay from 'worldmind/components/card-display';

module('Integration | Component | card-display', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><CardDisplay /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <CardDisplay>
        template block text
      </CardDisplay>
    </template>);

    assert.dom().hasText('template block text');
  });
});
