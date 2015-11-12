window.pagegauge.addGauge(function contentQuantity(site) {
  var bodyNoScript = /\<body([\s\S]*?)\<\/body\>/.exec(site.body)[0].replace(/\<script([\s\S]*?)\<\/script\>/g, '').replace(/\son(.*?)\"([\s\S]*?)\"/g, ''),
    wordcount = $(bodyNoScript).text().split(' ').length,
      score = _.min([1, (_.max([0, wordcount - 3000])/ 10000)]);
  return Promise.resolve(score);
});
