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
    init: function() {
      $('#gauge_button').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();

        var url = $('#gauge_url').val();

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
      $.ajax('/sites/', {
        data: { url: url },
        method: 'POST',
        success: function(){
          window.pagegauge.gauge().then(window.pagegauge.completed());
        }
      })
    },
    gauge: function(){
      var started_gauges = [];
      for(var i = 0; i < this.gauges.length; i++){
        started_gauges.push(this.gauge[i]);
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

$(window.pagegauge.init);
