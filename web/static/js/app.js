// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

//import { Posts } from "./posts"
//Posts.setup();

var Markit = {
  param: function(name) {
    var url = window.location.search.substring(1);
    var vars = url.split('&');
    var i;

    for (i = 0; i < vars.length; i++) {
      var current = vars[i].split('=');
      console.log(current)
      if (current[0] === name) {
        return current[1];
      }
    }
  },
  mark: function() {
    var keyword = decodeURIComponent(
      Markit.param("q") || Markit.param("search%5Bq%5D") ||
        Markit.param("search[q]")
    );
    console.log(keyword);

    if(keyword) {
      $(".post-stream").mark(keyword);
    }
  }
};

$(document).ready(function () {
  Markit.mark();
  var ias = jQuery.ias({
    container: '.post-stream',
    item: '.post',
    pagination: '#pagination',
    next:       '.next-posts'
  });
  ias.extension(new IASSpinnerExtension());
  ias.extension(new IASTriggerExtension({offset: 5}));
  ias.extension(new IASPagingExtension());
  ias.on('pageChange', function(pageNum, scrollOffset, url) {
    $('.post-stream').unmark();
    Markit.mark();
  });
});
