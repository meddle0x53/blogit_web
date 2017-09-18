var MultyCode = {
  run() {
    let hash = window.location.hash.substr(1);
    let hashed = false;

    $('pre.multi-code').each((index, el) => {
      let tags = [];

      let $current = $(el);
      tags.push($current);

      while ($current.prev().is('pre')) {
        $current = $current.prev();
        tags.push($current);
      }

      let $parent = $current.parent();
      let $container = $('<div class="tabbable tabs-below multi-code-container"><div class="tab-content"></div><ul class="nav nav-tabs"></ul></div>');
      $current.replaceWith($container);

      let $activeLink = null;
      let $activePane = null;

      tags.forEach($pre => {
        $pre.remove();

        let language = $pre.find('code').attr("class").split(' ')[0];
        $pre.addClass('tab-pane');
        $pre.attr('id', language);
        $container.find('.tab-content').prepend($pre);

        $activePane = $pre;
        $activeLink = $('<li id="' + language + '"><a href="#' + language + '" data-toggle="tab">' + language + '</a></li>');

        $container.find('ul.nav').prepend($activeLink);

        if (hash && language === hash) {
          $activeLink.addClass('active');
          $activePane.addClass('active');

          hashed = true;
        }
      });

      if (!hashed) {
        $activeLink.addClass('active');
        $activePane.addClass('active');
      }

      $('.multi-code-container a').click(function (e) {
        e.preventDefault();

        MultyCode.deactivateAll();

        let id = $(this).attr('href');

        $('.multi-code-container ' + id).addClass('active');
      });

      $('a.multi-code').click(function (e) {
        e.preventDefault();

        let language =$(this).text();
        let id = '#' + language;
        MultyCode.deactivateAll();

        $('.multi-code-container ' + id).addClass('active');
      });
    });
  },

  deactivateAll() {
    $('.multi-code-container li').removeClass('active');
    $('.multi-code-container pre.tab-pane').removeClass('active');
  }
};

export { MultyCode };
