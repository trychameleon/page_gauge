window.pagegauge = function() {
  return {
    uid: getUID(),
    page: {
      url: '',
      requests: [],
      responses: [],
      content: ''
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
    fetch: function(url) {
      $.ajax('/sites.json', {
        data: { uid: pagegauge.uid, url: url },
        method: 'POST',
        success: function(data) {
          window.pagegauge.gauge(data.site).
            then(window.pagegauge.completed);
        }
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
function getUID() {
  return window.localStorage.getItem('uid') ||
    (window.localStorage.setItem('uid', r()+r()) || window.localStorage.getItem('uid'));
}
