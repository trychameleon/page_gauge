window.pagegauge.addGauge(function contentQuantity(site) {
  var bodyNoScript = /\<body([\s\S]*?)\<\/body\>/.exec(site.body)[0].replace(/\<script([\s\S]*?)\<\/script\>/g, '').replace(/\son(.*?)\"([\s\S]*?)\"/g, ''),
    wordcount = $(bodyNoScript).text().split(' ').length,
    score = _.min([1, (_.max([0, wordcount - 3000])/ 10000)]);
  return Promise.resolve(score);
});

window.pagegauge.addGauge(function (site) {
  startScore = 0.2,
  ieTagsPresent = /[\s]*\[if[\s]*IE/g.exec(site.body);

  return new Promise(function(resolve) {

    var matches = /<head>([\s\S]*)<\/head>/.exec(site.body);

    if(!matches || !matches.length)
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
      var prefixes = ["linear-gradient", "box-shadow", "border-radius"];
      for(var i=0; i< datas.length; i++) {
        allStyles += datas[i].site.body;
        allStyles += "\n\n";
      }

      prefixes = prefixes.map(function(value, index){
        return {
          'webkit': new RegExp(value,"g").test(allStyles) == new RegExp('-webkit-' + value,"g").test(allStyles),
          'moz': new RegExp(value,"g").test(allStyles) == new RegExp('-webkit-' + value,"g").test(allStyles)
        };
      });

      var webKitStyles = _.every(prefixes, 'moz', true) ? 0.5 : 0,
          mozStyles = _.every(prefixes, 'moz', true) ? 0.13 : 0;

      resolve(startScore + ieTagsPresent + webKitStyles + mozStyles);
    });
  });
});

