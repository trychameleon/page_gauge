window.pagegauge = function(){
  var urlWaitTimeout = null;
  return {
    page: {
      url: '',
      requests: [],
      responses: [],
      content: ''
    },
    gauges: [],
    init: function(){
      $('#gauge_url').on('input', function(){
        var url = $(this).val();

        window.pagegauge.fetch(url);
        /*
        clearTimeout(urlWaitTimeout);
        urlWaitTimeout = null;
        urlWaitTimeout = setTimeout(function(){
          window.pagegauge.fetch(url);
        }, 500);*/
      });
    },
    fetch: function(url){
      var self = this;
      self.page.requests.push($.ajax('/sites/', {
        data: {url: url},
        method: 'POST',
        success: function(results){
          self.page.responses.push(results);
          self.page.content = results.body;
          window.pagegauge.gauge().then(window.pagegauge.completed);
        }
      }));
    },
    gauge: function(){
      var self = this,
        started_gauges = [];
      for(var i = 0; i < this.gauges.length; i++){
        started_gauges.push(this.gauges[i](self.page.content));
      }
      return Promise.all(started_gauges);
    },
    addgauge: function(gaugefn){
      this.gauges.push(gaugefn);
    },
    completed: function(results){
      console.log(results)
    }
  };
}();

window.pagegauge.addgauge(function(){return Promise.resolve("hello");});
window.pagegauge.addgauge(function(){return Promise.resolve("world");});
$(document).ready(function(){
  window.pagegauge.init();
});
