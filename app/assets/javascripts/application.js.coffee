#= require bootstrap/collapse
#= require jquery.smooth-scroll
#= require jquery_ujs

$ ->
  $('.navbar a[href*="#"]').smoothScroll()

  $('a[data-sort]').click (e) ->
    e.preventDefault()
    $select = $(this).parents('.select-wrapper').find('select')
    $options = $select.find('option')
    sort = $(this).data('sort')
    sortDirection = if $select.data('sort') == sort && $select.data('sort-direction') == 'desc' then 'asc' else 'desc'
    $select.data 'sort-direction', sortDirection
    $select.data 'sort', sort
    $options.sort (a, b) =>
      aData = $(a).data(sort)
      bData = $(b).data(sort)
      return 0 if aData == bData
      if sortDirection == 'asc'
        if aData > bData then 1 else -1
      else
        if aData < bData then 1 else -1
    $select.html $options
