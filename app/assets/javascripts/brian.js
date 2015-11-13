window.pagegauge.addGauge(function bodyLength(site) {
  return Promise.resolve(site.body.length);
});

window.pagegauge.addGauge(function isResponsive(site) {
  return new Promise(function(resolve) {
    pagegauge.util.fetchAllStyles(site, function(styles) {
      resolve(/@media/.test(styles) ? 'Is Responsive' : 'Is not Responsive')
    });
  });
});

window.pagegauge.addGauge(function hasColorSimplicity(site) {
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
