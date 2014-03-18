#= require bootstrap/collapse
#= require jquery.smooth-scroll
#= require jquery_ujs

$ ->
  $('.navbar a[href*="#"]').smoothScroll()

  $('a[data-sort]').click (e) ->
    e.preventDefault()
    $notice = $(@).siblings('.sorted')
    $select = $(@).parents('.select-wrapper').find('select')
    $options = $select.find('option')
    sort = $(@).data('sort')
    sortDirection = if $select.data('sort') == sort && $select.data('sort-direction') == 'desc' then 'asc' else 'desc'
    $select.data 'sort-direction', sortDirection
    $select.data 'sort', sort
    $options.sort (a, b) =>
      [aData, bData] = [$(a).data(sort), $(b).data(sort)]
      return 0 if aData == bData
      if sort == 'date'
        if sortDirection == 'asc'
          if parseInt(aData) > parseInt(bData) then return 1 else return -1
        else
          if parseInt(aData) < parseInt(bData) then return 1 else return -1
      else
        debugger if aData == '1.9.1-rc2' && bData == '1.9.2-rc2'
        [v1, v2] = [aData.toString().split(/[.-]/), bData.toString().split(/[.-]/)]
        longestLength = Math.max(v1.length, v2.length)
        for i in [0..longestLength]
          if v1[i] != v2[i]
            if sortDirection == 'asc'
              if v1[i]? then return v1[i].localeCompare(v2[i]) else return 1
            else
              if v2[i]? then return v2[i].localeCompare(v1[i]) else return 1
    $select.html $options
    $notice.text("Sorted by #{sort} #{sortDirection}").show()
    clearTimeout($notice.data('timeout')) if $notice.data('timeout')?
    $notice.data 'timeout', setTimeout ->
      $notice.fadeOut('slow')
    , 2000
