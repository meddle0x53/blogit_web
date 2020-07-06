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

import { MultyCode } from "./multicode"


var Markit = {
  param: function(name) {
    var url = window.location.search.substring(1);
    var vars = url.split('&');
    var i;

    for (i = 0; i < vars.length; i++) {
      var current = vars[i].split('=');
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

    if(keyword) {
      $(".post-stream").mark(keyword);
    }
  }
};

$(document).ready(function () {
  Markit.mark();
  var ias = jQuery.ias({
    container: '.post-stream',
    item: '.post-row',
    pagination: '#pagination',
    next:       '.next-posts'
  });
  ias.extension(new IASSpinnerExtension());
  ias.extension(new IASTriggerExtension({offset: 5}));
  ias.extension(new IASPagingExtension());
  ias.on('rendered', function(items) {
    $('.post-stream').unmark();
    Markit.mark();

    $('.post-stream .post pre').not('.hljs').each(function(i, block) {
      hljs.highlightBlock(block);
    });
  });

  document.addEventListener("turbolinks:render", function() {
    $('.post pre').not('.hljs').each(function(i, block) {
      hljs.highlightBlock(block);
    });
  });

  MultyCode.run();
});
