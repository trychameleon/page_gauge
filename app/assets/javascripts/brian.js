window.pagegauge.addGauge(function bodyLength(site) {
  return Promise.resolve(site.body.length);
});

window.pagegauge.addGauge(function isResponsive(site) {
  return new Promise(function(resolve) {

    var matches = /<head>([\s\S]*)<\/head>/.exec(site.body);

    if(!matches.length)
      return resolve('No head content found');

    var allStyles = '', sheets = [];

    $.each($(matches[1]), function() {
      var $this = $(this);

      if(this.tagName === 'LINK' && $this.attr('rel') === 'stylesheet') {
        var url =  pagegauge.util.buildUrl(site, $this.attr('href'));

        sheets.push(pagegauge.createSite(url));
      }
    });

    Promise.all(sheets).then(function(datas) {
      for(var i=0; i< datas.length; i++) {
        allStyles += datas[i].site.body;
        allStyles += "\n\n";
      }

      resolve(/@media/.test(allStyles) ? 'Is Responsive' : 'Is not Responsive');
    });
  });
});
