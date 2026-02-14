import { module, test } from 'qunit';
import { setupTest } from 'worldmind/tests/helpers';

module('Unit | Service | cerebro-api', function (hooks) {
  setupTest(hooks);

  // TODO: Replace this with your real tests.
  test('it exists', function (assert) {
    let service = this.owner.lookup('service:cerebro-api');
    assert.ok(service);
  });
});
