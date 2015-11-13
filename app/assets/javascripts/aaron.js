window.pagegauge.addGauge(function contentQuantity(site) {
  var bodyNoScript = /\<body([\s\S]*?)\<\/body\>/.exec(site.body)[0].replace(/\<script([\s\S]*?)\<\/script\>/g, '').replace(/\son(.*?)\"([\s\S]*?)\"/g, ''),
    wordcount = $(bodyNoScript).text().replace(/\s+/g, " ").split(' ').length,
    score = 1 - _.min([1, (_.max([0, wordcount - 500])/ 1000)]);
  return Promise.resolve(score);
});

window.pagegauge.addGauge(function (site) {
  var startScore = 0.2,
      ieTagsPresent = /[\s]*\[if[\s]*IE/g.exec(site.body);

  return new Promise(function browserCompatability(resolve) {
    pagegauge.util.fetchAllStyles(site, function(styles) {
      var prefixes = ["linear-gradient", "box-shadow", "border-radius"];
      prefixes = prefixes.map(function(value, index) {
        return {
          'webkit': new RegExp(value, "g").test(styles) == new RegExp('-webkit-' + value, "g").test(styles),
          'moz': new RegExp(value, "g").test(styles) == new RegExp('-webkit-' + value, "g").test(styles)
        };
      });

      var webKitStyles = _.every(prefixes, 'moz', true) ? 0.5 : 0,
        mozStyles = _.every(prefixes, 'moz', true) ? 0.13 : 0;
      resolve(startScore + ieTagsPresent + webKitStyles + mozStyles);
    });
  });
});


window.pagegauge.addGauge(function baseMenuSize(site) {
  var bodyNoScript = /\<body([\s\S]*?)\<\/body\>/.exec(site.body)[0].replace(/\<script([\s\S]*?)\<\/script\>/g, '').replace(/\son(.*?)\"([\s\S]*?)\"/g, '');

  return Promise.resolve(window.pagegauge.util.getTopMenu($(bodyNoScript)).children.length > 7 ? 0 : 1);
});

window.pagegauge.addGauge(function baseMenuDepth(site) {
  var bodyNoScript = /\<body([\s\S]*?)\<\/body\>/.exec(site.body)[0].replace(/\<script([\s\S]*?)\<\/script\>/g, '').replace(/\son(.*?)\"([\s\S]*?)\"/g, ''),
      proudestParentMenu = window.pagegauge.util.getTopMenu($(bodyNoScript)),
      depth;

  //from the proudestParent
  var testMenuChildrenDepth = function(menu, level){
    level = level || 1;
    var children = $(menu).children(),
        childDepth = [level];
    //for each of children
    for(var i = 0; i < children.length; i++){
      childDepth.push(testMenuChildrenDepth(children[i], level+1));
    }
    return _.max(childDepth);
  };
  depth = testMenuChildrenDepth(proudestParentMenu);

  var score = depth <= 3 ? 1 : depth < 6 ? 0.5 : 0;

  return Promise.resolve(score);
});
