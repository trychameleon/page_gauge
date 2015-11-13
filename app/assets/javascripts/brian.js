pagegauge.addGauge(function bodyLength(site) {
  return Promise.resolve(site.body.length);
});

pagegauge.addGauge(function isResponsive(site) {
  return new Promise(function(resolve) {
    pagegauge.util.fetchAllStyles(site, function(styles) {
      resolve(/@media/.test(styles) ? 'Is Responsive' : 'Is not Responsive')
    });
  });
});

pagegauge.addGauge(function hasColorSimplicity(site) {
  return new Promise(function(resolve) {
    pagegauge.util.fetchAllStyles(site, function(styles) {
      var colors = {},
        hexes = styles.match(/#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/g) || [],
        rgbs = styles.match(/rgba?\(\d+,\s*\d+,\s*\d+(?:,\s*\d+(?:\.\d+)?)?\)/g) || [];

      hexes = hexes.concat.apply(hexes, rgbs);

      for(var i=0; i<hexes.length; i++) {
        var key = hexes[i].toLowerCase();

        colors[key] || (colors[key] = 0);
        colors[key] += 1;
      }

      console.log('We have colors!', colors);

      resolve('Has #'+Object.keys(colors).length+' colors');
    });
  });
});

pagegauge.addGauge(function tooManyActions() {

});

pagegauge.addGauge(function has404Page(site) {
  return new Promise(function(resolve) {
    var url = pagegauge.util.buildUrl(site, site.uid);

    pagegauge.createSite(url, function(site404) {
      var has404Text = /sorry|error|404|mistake|not found|exist/i,
        has404 = false;

      if(site404.code === 404 && has404Text.test(site.body)) {
        has404 = true;
      }

      resolve(has404 ? 'Has a 404' : 'No 404');
    });
  });
});
