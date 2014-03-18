#= require bootstrap/collapse
#= require jquery.smooth-scroll
#= require jquery_ujs

$ ->
  $('.navbar a[href*="#"]').smoothScroll()
  enableSorting()

compareSortEls = (el1, el2, sort, sortDirection) ->
  [sort1, sort2] = [$(el1).data(sort), $(el2).data(sort)]
  if sort == 'date'
    [date1, date2] = [parseInt(sort1), parseInt(sort2)]
    if date1 == date2
      return compareSortEls(el1, el2, 'version', sortDirection)
    else if sortDirection == 'asc'
      if date1 > date2 then return 1 else return -1
    else
      if date1 < date2 then return 1 else return -1
  else
    [v1, v2] = [sort1.toString().split(/[.-]/), sort2.toString().split(/[.-]/)]
    if v1 == v2
      console.error "Found version #{v1} twice."
      return 0
    longestLength = Math.max(v1.length, v2.length)
    for i in [0..longestLength]
      if v1[i] != v2[i]
        if sortDirection == 'asc'
          if v1[i]? then return v1[i].localeCompare(v2[i]) else return 1
        else
          if v2[i]? then return v2[i].localeCompare(v1[i]) else return 1

enableSorting = ->
  $('a[data-sort]').click (e) ->
    e.preventDefault()
    $notice = $(@).siblings('.sorted')
    $select = $(@).parents('.select-wrapper').find('select')
    $options = $select.find('option')
    sort = $(@).data('sort')
    sortDirection = if $select.data('sort') == sort && $select.data('sort-direction') == 'desc' then 'asc' else 'desc'
    $select.data 'sort-direction', sortDirection
    $select.data 'sort', sort
    $options.sort (el1, el2) =>
      compareSortEls el1, el2, sort, sortDirection
    $select.html $options
    $notice.text("Sorted by #{sort} #{sortDirection}").show()
    clearTimeout($notice.data('timeout')) if $notice.data('timeout')?
    $notice.data 'timeout', setTimeout ->
      $notice.fadeOut('slow')
    , 2000
