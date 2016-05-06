#= require bootstrap/collapse
#= require bootstrap/modal
#= require jquery.smooth-scroll
#= require jquery-cookie
#= require jquery_ujs
#= require select2

$ ->
  $('.navbar a[href*="#"]').smoothScroll()
  showCookieBar()

  if $('body#home').length
    enableVersionSorting()
    enableSelect2()
    enableProjectSearch()
    autoProjectSearch()
    fixSelect2InDocCollectionModal()
    submitNewProjectFormViaAjax()

$searchInput = $('form#project-search input#search')

showCookieBar = ->
  unless $.cookie('cookie-consent')?
    cookieBar = $('#cookie-bar')
    cookieBar
      .slideDown()
      .find('a')
      .click (e) ->
        e.preventDefault()
        $.cookie 'cookie-consent', 'true',
          expires: 365
          path:    '/'
        cookieBar.slideUp()

compareSortEls = (el1, el2, sort, sortDirection) ->
  [sort1, sort2] = [$(el1).data(sort), $(el2).data(sort)]
  if sort == 'date'
    [date1, date2] = [parseInt(sort1), parseInt(sort2)]
    if date1 == date2
      return compareSortEls(el1, el2, 'version', 'desc')
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

enableVersionSorting = ->
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

enableSelect2 = ->
  $('select.version').select2
    theme: 'bootstrap'

enableProjectSearch = ->
  $projects = $('.projects .project')
  $searchInput
    .keyup ->
      query = $(@).val()
      found = false
      if query.length
        query = query.toUpperCase()
        $projects.each ->
          $this = $(@)
          title = $this.find('.project-title').text().toUpperCase()
          if title.indexOf(query) >= 0
            found = true
            $this.slideDown()
          else
            $this.slideUp()
      else
        found = true
        $projects.slideDown()
      $('.projects .not-found').toggle !found
    .trigger('keyup')

autoProjectSearch = ->
  queryMatch = window.location.search.match(/search=([^&]+)/)
  if queryMatch?
    $searchInput
      .val(queryMatch[1])
      .trigger('keyup')
    $('html, body').animate
      scrollTop: $searchInput.offset().top - 20
    , 'slow'

fixSelect2InDocCollectionModal = ->
  $('#combined-docs').on 'shown.bs.modal', (e) ->
    enableSelect2()

submitNewProjectFormViaAjax = ->
  $('#add-project form').submit (e) ->
    e.preventDefault()

    $submit = $(@).find(':submit')
    $submit.data('original-text', $submit.text())
    $submit.text($submit.data('loading'))
    $submit.addClass('disabled')

    $.ajax @action,
      type:     'POST'
      data:     $(@).serialize()
      dataType: 'json'
    .always =>
      $submit.removeClass('disabled')
      $submit.text($submit.data('original-text'))
    .done =>
      $(@)
        .slideUp()
        .siblings('.note.note-confirm')
        .slideDown()
    .fail (xhr, status) =>
      if Rollbar?
        Rollbar.error 'Error submitting form.', xhr: xhr, status: status
      $(@)
        .siblings('.note.note-error')
        .slideDown()
