# https://github.com/soyjavi/QuoJS
# http://hammerjs.github.io/
# 触摸事件库

ANIMATE_DURATION = 250

jQuery ->
  jQuery('.tiles a').attr('target', '_blank')
  load_page location.hash

jQuery ->
  jQuery('.tiles.thread .tile.member .m').each ->
    $i = jQuery('<i>').addClass('fa').addClass('fa-user')
    $span = jQuery('<span>').text '查看个人详情'
    $a = jQuery('<a>').addClass('show-member-detail')
      .attr('href', 'javascript:;')
      .append $i
      .append $span
      .appendTo jQuery(this)

jQuery ->
  jQuery('.tile.summary .t').each ->
    $i = jQuery('<i>').addClass('fa').addClass('fa-chevron-up')
    $span = jQuery('<span>').text '返回列表'
    $a = jQuery('<a>').addClass('back')
      .attr('href', 'javascript:;')
      .append $i
      .append $span
      .appendTo jQuery(this)

jQuery ->
  jQuery('.tile.summary .t').each ->
    $i = jQuery('<i>').addClass('fa').addClass('fa-chevron-right')
    $span = jQuery('<span>').text '显示主线详情'
    $a = jQuery('<a>').addClass('detail')
      .attr('href', 'javascript:;')
      .append $i
      .append $span
      .appendTo jQuery(this)


# 查看主线详情
jQuery(document).on 'click', 'body.mobile.index .tile.summary', (evt)->
  thread = jQuery(this).closest('.tiles').data('thread')
  location.hash = "detail/#{thread}"

# 返回主线列表
jQuery(document).on 'click', 'body.mobile.detail .tile.summary a.back', (evt)->
  location.hash = ''

# 查看个人详情
jQuery(document).on 'click', 'body.mobile.detail .tile.member a.show-member-detail', (evt)->
  member = jQuery(this).closest('.tile.member').data('member')
  location.hash = "member/#{member}"

# 在个人详情页查看主线详情
jQuery(document).on 'click', 'body.mobile.member-detail .tile.summary a.detail', (evt)->
  thread = jQuery(this).closest('.tiles').data('thread')
  location.hash = "detail/#{thread}"

jQuery(window).on 'hashchange', (evt)->
  load_page location.hash

# 重置网页上的 dom 状态
# 每次触发 hashchange 导致 load_page 时要调用此方法
reset_page = ->
  jQuery(document.body)
    .removeClass('detail')
    .removeClass('member-detail')
    .addClass('index')

  jQuery('.tiles')
    .removeClass('current')
    .css
      'margin-left': 0
    .show()

  jQuery('.tile.member').css 'display', ''

load_page = (hash)->
  console.debug "hash: #{hash}"
  if hash is ''
    reset_page()
    return

  if hash.indexOf('#detail/') is 0
    reset_page()
    thread = hash.split('/')[1]

    jQuery(document.body)
      .removeClass('index')
      .addClass('detail')
    
    jQuery('.tiles').hide()
    jQuery(".tiles[data-thread=#{thread}]")
      .addClass('current')
      .show()

    return

  if hash.indexOf('#member/') is 0
    reset_page()
    member = hash.split('/')[1]

    jQuery(document.body)
      .removeClass('index')
      .addClass('member-detail')

    jQuery(".tiles").hide()
    jQuery(".tile.member[data-member=#{member}]").each ->
      $tiles = jQuery(this).closest('.tiles')
      $tiles.show()
      jQuery(this).show()

    return



jQuery('.tiles.thread').hammer().bind 'swipeleft', (evt)->
  console.debug 'swipeleft'
  return if not jQuery(this).hasClass('current')
  return if jQuery(this).parent().find('.tiles.thread').length is 1

  $current = jQuery(this)
  $next = $current.next('.tiles.thread')
  if $next.length is 0
    $next = $current.parent().find('.tiles.thread').first()

  $current.removeClass('current').show()
    .animate
      'margin-left': '-100%' 
    , ANIMATE_DURATION, ->
      $current.hide()

  $next.show()
    .css
      'margin-left': '100%'
    .animate
      'margin-left': '0'
    , ANIMATE_DURATION, ->
      $next.addClass('current')
      location.hash = "detail/#{$next.data('thread')}"


jQuery('.tiles.thread').hammer().bind 'swiperight', (evt)->
  console.debug 'swiperight'
  return if not jQuery(this).hasClass('current')
  return if jQuery(this).parent().find('.tiles.thread').length is 1

  $current = jQuery(this)
  $prev = $current.prev('.tiles.thread')
  if $prev.length is 0
    $prev = $current.parent().find('.tiles.thread').last()

  $current.show()
    .animate
      'margin-left': '100%' 
    , ANIMATE_DURATION, ->
      $current.hide()

  $prev.show()
    .css
      'margin-left': '-100%'
    .animate
      'margin-left': '0'
    , ANIMATE_DURATION, ->
      $prev.addClass('current')
      location.hash = "detail/#{$prev.data('thread')}"