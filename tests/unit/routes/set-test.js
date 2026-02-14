import { module, test } from 'qunit';
import { setupTest } from 'worldmind/tests/helpers';

module('Unit | Route | set', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    let route = this.owner.lookup('route:set');
    assert.ok(route);
  });
});
