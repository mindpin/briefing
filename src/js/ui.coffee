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
          .addClass('desc').html d
          .appendTo $work

      if data.commits?
        for commit in data.commits
          urltext = @deal_url commit.url
          $commit = jQuery('<div>').addClass('a-commit')
            .appendTo $work
            .append(jQuery('<div>').addClass('t').html(commit.t))
            .append(jQuery('<a>').attr('href', commit.url).attr('target', '_blank').html(urltext))

      if data.suggestions?
        for suggestion in data.suggestions
          $suggestion = jQuery('<div>').addClass('suggestion')
            .html(suggestion)
            .appendTo $work

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