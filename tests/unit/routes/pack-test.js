import { module, test } from 'qunit';
import { setupTest } from 'worldmind/tests/helpers';

module('Unit | Route | pack', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    let route = this.owner.lookup('route:pack');
    assert.ok(route);
  });
});
