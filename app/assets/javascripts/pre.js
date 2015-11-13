window.pagegauge = function() {
  return {
    uid: getUUID(),
    page: {
      url: '',
      requests: [],
      responses: [],
      content: ''
    },
    util: {
      uuid: getUUID,
      fetchAllStyles: function(site, done) {
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

          done(allStyles);
        });
      },
      buildUrl: function(site, href) {
        var url = '';

        if(/^\/\//.test(href)) {
          url = 'https:';
        } else if(!/https?:\/\//.test(href)) {
          var a = document.createElement('a');
          a.href = site.url;

          url += a.hostname;

          if(!/^\//.test(href)) {
            url += '/';
          }
        }

        return url + href;
      },
      getTopMenu: function(body){
        var possibleNavSelectors = ['nav', 'menu'],
            possibleNavs = [],
            proudestParentMenu;

        $(body).find('*').filter(function(){
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

        return proudestParentMenu;
      }
    },
    gauges: [],
    init: function() {
      $('#gauge_button').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();

        var url = $('#gauge_url').val();

        window.pagegauge.fetch(url);
      });
    },
    createSite: function(url, success) {
      return $.ajax('/sites.json', {
        data: { uid: pagegauge.uid, url: url },
        method: 'POST',
        success: success
      });
    },
    fetch: function(url) {
      pagegauge.createSite(url, function(data) {
        window.pagegauge.gauge(data.site).
          then(window.pagegauge.completed);
      });
    },
    gauge: function(site) {
      var started_gauges = [];

      for(var i = 0; i < this.gauges.length; i++){
        started_gauges.push(this.gauges[i](site));
      }

      return Promise.all(started_gauges);
    },
    addGauge: function(gaugefn) {
      this.gauges.push(gaugefn);
    },
    completed: function(results) {
      console.log(results);
    }
  };
}();

$(window.pagegauge.init);

function r() { return Math.random().toString(36).replace(/[^a-z0-9]+/g, ''); }
function getUUID() {
  return window.localStorage.getItem('uid') ||
    (window.localStorage.setItem('uid', r()+r()) || window.localStorage.getItem('uid'));
}
