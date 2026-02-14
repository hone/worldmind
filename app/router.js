import EmberRouter from '@embroider/router';
import config from 'worldmind/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('sets');

  this.route('set', {
    path: '/sets/:set_id',
  });
  this.route('search');
  this.route('packs');

  this.route('pack', {
    path: '/packs/:pack_id'
  });
  this.route('search-guide');
});
