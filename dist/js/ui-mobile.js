(function() {
  var ANIMATE_DURATION, load_page, reset_page;

  ANIMATE_DURATION = 250;

  jQuery(function() {
    jQuery('.tiles a').attr('target', '_blank');
    return load_page(location.hash);
  });

  jQuery(function() {
    return jQuery('.tiles.thread .tile.member .m').each(function() {
      var $a, $i, $span;
      $i = jQuery('<i>').addClass('fa').addClass('fa-user');
      $span = jQuery('<span>').text('查看个人详情');
      return $a = jQuery('<a>').addClass('show-member-detail').attr('href', 'javascript:;').append($i).append($span).appendTo(jQuery(this));
    });
  });

  jQuery(function() {
    return jQuery('.tile.summary .t').each(function() {
      var $a, $i, $span;
      $i = jQuery('<i>').addClass('fa').addClass('fa-chevron-up');
      $span = jQuery('<span>').text('返回列表');
      return $a = jQuery('<a>').addClass('back').attr('href', 'javascript:;').append($i).append($span).appendTo(jQuery(this));
    });
  });

  jQuery(function() {
    return jQuery('.tile.summary .t').each(function() {
      var $a, $i, $span;
      $i = jQuery('<i>').addClass('fa').addClass('fa-chevron-right');
      $span = jQuery('<span>').text('显示主线详情');
      return $a = jQuery('<a>').addClass('detail').attr('href', 'javascript:;').append($i).append($span).appendTo(jQuery(this));
    });
  });

  jQuery(document).on('click', 'body.mobile.index .tile.summary', function(evt) {
    var thread;
    thread = jQuery(this).closest('.tiles').data('thread');
    return location.hash = "detail/" + thread;
  });

  jQuery(document).on('click', 'body.mobile.detail .tile.summary a.back', function(evt) {
    return location.hash = '';
  });

  jQuery(document).on('click', 'body.mobile.detail .tile.member a.show-member-detail', function(evt) {
    var member;
    member = jQuery(this).closest('.tile.member').data('member');
    return location.hash = "member/" + member;
  });

  jQuery(document).on('click', 'body.mobile.member-detail .tile.summary a.detail', function(evt) {
    var thread;
    thread = jQuery(this).closest('.tiles').data('thread');
    return location.hash = "detail/" + thread;
  });

  jQuery(window).on('hashchange', function(evt) {
    return load_page(location.hash);
  });

  reset_page = function() {
    jQuery(document.body).removeClass('detail').removeClass('member-detail').addClass('index');
    jQuery('.tiles').removeClass('current').css({
      'margin-left': 0
    }).show();
    return jQuery('.tile.member').css('display', '');
  };

  load_page = function(hash) {
    var member, thread;
    console.debug("hash: " + hash);
    if (hash === '') {
      reset_page();
      return;
    }
    if (hash.indexOf('#detail/') === 0) {
      reset_page();
      thread = hash.split('/')[1];
      jQuery(document.body).removeClass('index').addClass('detail');
      jQuery('.tiles').hide();
      jQuery(".tiles[data-thread=" + thread + "]").addClass('current').show();
      return;
    }
    if (hash.indexOf('#member/') === 0) {
      reset_page();
      member = hash.split('/')[1];
      jQuery(document.body).removeClass('index').addClass('member-detail');
      jQuery(".tiles").hide();
      jQuery(".tile.member[data-member=" + member + "]").each(function() {
        var $tiles;
        $tiles = jQuery(this).closest('.tiles');
        $tiles.show();
        return jQuery(this).show();
      });
    }
  };

  jQuery('.tiles.thread').hammer().bind('swipeleft', function(evt) {
    var $current, $next;
    console.debug('swipeleft');
    if (!jQuery(this).hasClass('current')) {
      return;
    }
    if (jQuery(this).parent().find('.tiles.thread').length === 1) {
      return;
    }
    $current = jQuery(this);
    $next = $current.next('.tiles.thread');
    if ($next.length === 0) {
      $next = $current.parent().find('.tiles.thread').first();
    }
    $current.removeClass('current').show().animate({
      'margin-left': '-100%'
    }, ANIMATE_DURATION, function() {
      return $current.hide();
    });
    return $next.show().css({
      'margin-left': '100%'
    }).animate({
      'margin-left': '0'
    }, ANIMATE_DURATION, function() {
      $next.addClass('current');
      return location.hash = "detail/" + ($next.data('thread'));
    });
  });

  jQuery('.tiles.thread').hammer().bind('swiperight', function(evt) {
    var $current, $prev;
    console.debug('swiperight');
    if (!jQuery(this).hasClass('current')) {
      return;
    }
    if (jQuery(this).parent().find('.tiles.thread').length === 1) {
      return;
    }
    $current = jQuery(this);
    $prev = $current.prev('.tiles.thread');
    if ($prev.length === 0) {
      $prev = $current.parent().find('.tiles.thread').last();
    }
    $current.show().animate({
      'margin-left': '100%'
    }, ANIMATE_DURATION, function() {
      return $current.hide();
    });
    return $prev.show().css({
      'margin-left': '-100%'
    }).animate({
      'margin-left': '0'
    }, ANIMATE_DURATION, function() {
      $prev.addClass('current');
      return location.hash = "detail/" + ($prev.data('thread'));
    });
  });

}).call(this);
