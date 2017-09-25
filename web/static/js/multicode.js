var MultyCode = {
  run() {
    let hash = MultyCode.getURLLang();
    let hashed = false;
    let allLanguages = null;

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

      let languages = [];
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

        languages.push(language);
      });

      if (allLanguages === null) {
        allLanguages = languages.reverse();
      }

      if (!hashed) {
        $activeLink.addClass('active');
        $activePane.addClass('active');
      }

      $('.multi-code-container a').click(function (e) {
        e.preventDefault();

        MultyCode.deactivateAll();

        let id = $(this).attr('href');

        $('.multi-code-container ' + id).addClass('active');
        $('code.multi-inline' + id).addClass('active');
      });

      $('a.multi-code').click(function (e) {
        e.preventDefault();

        let language =$(this).text();
        let id = '#' + language;
        MultyCode.deactivateAll();

        $('.multi-code-container ' + id).addClass('active');
        $('code.multi-inline' + id).addClass('active');
      });

      $(el).removeClass('multi-code')
    });

    if (allLanguages === null || allLanguages.length === 0) {
      return;
    }
    let currentLanguage = allLanguages[0];
    if (hashed) {
      currentLanguage = hash;
    }

    $('em:contains(multi-code)').each((index, el) => {
      let $codes = $(el).prevUntil(':not(code)');
      $codes.length = allLanguages.length;
      $codes.addClass('multi-inline');

      $codes.each((index, el) => {
        $(el).attr('id', allLanguages[allLanguages.length - 1 - index]);
      });
    }).remove();

    $('code.multi-inline#' + currentLanguage).addClass('active');
  },

  deactivateAll() {
    $('.multi-code-container li').removeClass('active');
    $('.multi-code-container pre.tab-pane').removeClass('active');
    $('code.multi-inline').removeClass('active');
  },

  getURLLang() {
    let queryRegex = new RegExp('[?&]lang=([^&]*)');
    let match = queryRegex.exec(window.location.search)

    if (match === null) {
      return null;
    }
    return window.decodeURIComponent(match[1]);
  }
};

export { MultyCode };
