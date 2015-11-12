window.pagegauge.addGauge(function bodyLength(site) {
  return Promise.resolve(site.body.length);
});
