class YamlLoader
  constructor: (yaml)->
    members = {
      summary: -1
    }
    jQuery('th.member').each (idx)->
      members[jQuery(this).data('id')] = idx
    @members = members

    jQuery.get "../yaml/#{yaml}", (res)=>
      data = jsyaml.load res
      @load data

  load: (data)->
    for thread, trdata of data
      $tr = jQuery("tr[data-id=#{thread}]")
      @load_tr $tr, trdata

  load_tr: ($tr, trdata)->
    for member, tddata of trdata
      $td = $tr.find("td:not(.thread)").eq @members[member] + 1
      @load_td $td, tddata

      if member is 'summary' and tddata[0].tr?
        $tr.addClass tddata[0].tr

  load_td: ($td, tddata)->
    for data in tddata
      $work = jQuery('<div>')
        .addClass('work').addClass(data.status)
        .appendTo $td

      _desc = if typeof data.desc is 'object' then data.desc else [data.desc]

      for d in _desc
        $desc = jQuery('<div>')
          .addClass('desc').html(d)
          .appendTo $work

      if data.bundle?
        $bundle = jQuery('<div>').addClass('bundle')
          .appendTo $work
          .append '<div class="bundle-title">提交物组合</div>'
        $task = jQuery('<div>').addClass('bundle-task')
          .append '<span>任务</span>'
          .append @make_link data.bundle.task
          .appendTo $bundle
        $project = jQuery('<div>').addClass('bundle-project')
          .append '<span>工程</span>'
          .append @make_link data.bundle.project
          .appendTo $bundle
        $demo = jQuery('<div>').addClass('bundle-demo')
          .append '<span>演示</span>'
          .append @make_link data.bundle.demo
          .appendTo $bundle

      if data.commits?
        for commit in data.commits
          $commit = jQuery('<div>').addClass('a-commit')
            .appendTo $work
            .append(jQuery('<div>').addClass('t').html(commit.t))
            .append @make_link commit.url

      if data.suggestions?
        for suggestion in data.suggestions
          $suggestion = jQuery('<div>').addClass('suggestion')
            .html(suggestion)
            .appendTo $work

  make_link: (url)->
    jQuery('<a>')
      .attr('href', url)
      .attr('target', '_blank')
      .html(@deal_url url)

  deal_url: (url)->
    match = url.match /^https:\/\/github.com\/mindpin\/(.+)\/issues\/(\d+)$/
    if match
      return "mindpin/#{match[1]}##{match[2]}"
    else
      return url




jQuery ->
  jQuery('.main a').attr('target', '_blank')

  if yaml = jQuery('body').data('yaml')
    new YamlLoader yaml