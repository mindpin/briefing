(function() {
  var YamlLoader;

  YamlLoader = (function() {
    function YamlLoader(yaml) {
      var members;
      members = {
        summary: -1
      };
      jQuery('th.member').each(function(idx) {
        return members[jQuery(this).data('id')] = idx;
      });
      this.members = members;
      jQuery.get("../yaml/" + yaml, (function(_this) {
        return function(res) {
          var data;
          data = jsyaml.load(res);
          return _this.load(data);
        };
      })(this));
    }

    YamlLoader.prototype.load = function(data) {
      var $tr, results, thread, trdata;
      results = [];
      for (thread in data) {
        trdata = data[thread];
        $tr = jQuery("tr[data-id=" + thread + "]");
        results.push(this.load_tr($tr, trdata));
      }
      return results;
    };

    YamlLoader.prototype.load_tr = function($tr, trdata) {
      var $td, member, results, tddata;
      results = [];
      for (member in trdata) {
        tddata = trdata[member];
        $td = $tr.find("td:not(.thread)").eq(this.members[member] + 1);
        this.load_td($td, tddata);
        if (member === 'summary' && (tddata[0].tr != null)) {
          results.push($tr.addClass(tddata[0].tr));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    YamlLoader.prototype.load_td = function($td, tddata) {
      var $commit, $desc, $suggestion, $work, _desc, commit, d, data, i, j, k, len, len1, len2, ref, results, suggestion, urltext;
      results = [];
      for (i = 0, len = tddata.length; i < len; i++) {
        data = tddata[i];
        $work = jQuery('<div>').addClass('work').addClass(data.status).appendTo($td);
        _desc = typeof data.desc === 'object' ? data.desc : [data.desc];
        for (j = 0, len1 = _desc.length; j < len1; j++) {
          d = _desc[j];
          $desc = jQuery('<div>').addClass('desc').html(d).appendTo($work);
        }
        if (data.commits != null) {
          ref = data.commits;
          for (k = 0, len2 = ref.length; k < len2; k++) {
            commit = ref[k];
            urltext = this.deal_url(commit.url);
            $commit = jQuery('<div>').addClass('a-commit').appendTo($work).append(jQuery('<div>').addClass('t').html(commit.t)).append(jQuery('<a>').attr('href', commit.url).attr('target', '_blank').html(urltext));
          }
        }
        if (data.suggestions != null) {
          results.push((function() {
            var l, len3, ref1, results1;
            ref1 = data.suggestions;
            results1 = [];
            for (l = 0, len3 = ref1.length; l < len3; l++) {
              suggestion = ref1[l];
              results1.push($suggestion = jQuery('<div>').addClass('suggestion').html(suggestion).appendTo($work));
            }
            return results1;
          })());
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    YamlLoader.prototype.deal_url = function(url) {
      var match;
      match = url.match(/^https:\/\/github.com\/mindpin\/(.+)\/issues\/(\d+)$/);
      if (match) {
        return "mindpin/" + match[1] + "#" + match[2];
      } else {
        return url;
      }
    };

    return YamlLoader;

  })();

  jQuery(function() {
    var yaml;
    jQuery('.main a').attr('target', '_blank');
    if (yaml = jQuery('body').data('yaml')) {
      return new YamlLoader(yaml);
    }
  });

}).call(this);
