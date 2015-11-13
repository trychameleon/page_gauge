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
  var bodyNoScript = /\<body([\s\S]*?)\<\/body\>/.exec(site.body)[0].replace(/\<script([\s\S]*?)\<\/script\>/g, '').replace(/\son(.*?)\"([\s\S]*?)\"/g, ''),
      possibleNavSelectors = ['nav', 'menu'],
      possibleNavs = [],
      proudestParentMenu;

    $(bodyNoScript).find('*').filter(function(){
      var possibleNav = false;
      for(var i = 0; i < possibleNavSelectors.length; i++ ){
        if(this.id.match(possibleNavSelectors[i]) || this.className.match(possibleNavSelectors[i])){
          possibleNav = true;
        }
      }
      if(possibleNav && possibleNavs.indexOf(this) < 0 && this.children.length > 1){
        possibleNavs.push(this);
        return true;
      }
    });

    //find shallowest descendant with most amount of children
    for(var i = 0; i < possibleNavs.length; i++ ){
      if(!proudestParentMenu || (possibleNavs[i].children.length > proudestParentMenu.children.length && $(proudestParentMenu).not(possibleNavs).length < 1)){
        proudestParentMenu = possibleNavs[i];
      }
    };

    return Promise.resolve(proudestParentMenu.children.length > 7 ? 0 : 1);
});
