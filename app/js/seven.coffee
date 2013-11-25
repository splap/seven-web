# create a namespace for sevenWeb globals
this.sevenWeb = {}

sevenWeb.workPages = [
  [0, "nschat", "No Such Chat",     [1,2,3]],
  [1, "whatsgood", "WhatsGOOD",     [0,6,5]],
  [2, "smile", "Smile by Webshots", [2,4,7]],
  [3, "enrapt", "Enrapt",           [0,1,4]],
  [4, "stealth", "Stealthy Co.",    [2,4]],
  [5, "tippoint", "Tipping Point",  [2,3,7]],
  [6, "arc9", "ARC9",               [1,3,7]],
  [7, "livefyre", "Livefyre",       [0,1]],
  [8, "sso", "Google Apps SSO",     [0,2,3]]
]

if typeof console is "undefined"
  console = log: (logMsg) ->  

sevenWeb.showRelatedClients = ->
  lastSelector = null
  for clientInfo in sevenWeb.workPages
    if clientInfo[1] == $("#modal-container").data("client-name")
      for relatedIndex in clientInfo[3]
        lastSelector = '#' + sevenWeb.workPages[relatedIndex][1] + '-related'
        $(lastSelector).show()
  $(lastSelector).css 'padding-right', '0px'

sevenWeb.preload = ( image_names ) ->
    preloads = []
    for imageName, i in image_names
        preloads[i] = new Image()
        preloads[i].src = imageName

logoHover = (e) ->
  $(e.currentTarget).closest('div').addClass 'hover-nav'
  #$(".small-logo").attr 'src', "/images/logo_over_100x23.jpg"
  $(".small-logo").attr 'src', "/images/logo_nav.png"

logoUnhover = (e) ->
  $(e.currentTarget).closest('div').removeClass 'hover-nav'
  #$(".small-logo").attr 'src', "/images/logo_off_100x23.jpg"
  $(".small-logo").attr 'src', "/images/logo_nav.png"

navHover = (e) ->
  $(e.currentTarget).closest('div').addClass 'hover-nav'

navUnhover = (e) ->
  $(e.currentTarget).closest('div').removeClass 'hover-nav'

handleNavClicks = (e) ->
  # clear active nav item
  $('.nav-item').each ->
    $(this).removeClass 'active-nav'
  $('.logo-nav-item').removeClass 'active-nav'

  $(e.currentTarget).closest('div').addClass 'active-nav'
  e.preventDefault

  anchor = $(e.currentTarget).find('a')[0] || $(e.currentTarget).closest('a')[0]

  showSelectedSection anchor.hash, e

showSelectedSection = (sectionSelector, e = null) ->
  divSectionSelector = sectionSelector.replace("#", ".") #cray!!
  offset = $(divSectionSelector).offset().top - 58
 
  if $.browser.mozilla? || $.browser.msie?
    console.log 'moz -- scrollTo: ' + offset + ' based on ' + divSectionSelector
    window.scrollTo 0, offset
    return false

  console.log 'animating to ' + offset
  $('body').animate { scrollTop: offset }, {
      duration: 'fast',
      complete: (e) ->
        #console.log 'animation complete'
      done: (e) ->
        #console.log 'animation done'
      fail: (e) ->
        #console.log 'animation complete'
  }
  false

workHover = (e) ->
  $(this).find("img, ul").fadeTo(0, 0.4)
  workHover = $("#work-hover-template").children().clone()
  workHover.attr('id', 'work-hover')
  $(this).find("ul").after($(workHover))
  $(this).parent().height( $(this).height() )
  $("#work-hover").css( 'left', ( ($(this).width() - $("#work-hover").outerWidth()) / 2 ) )
    .css( 'bottom', ( ($(this).height() - $("#work-hover").outerHeight()) / 2 ) + $("#work-hover").outerHeight() )

workUnhover = (e) ->
  $("img, ul").fadeTo(0, 1)
  $("#work-hover").remove()

showWorkDetailHandler = (e) ->
  showSelectedSection '#work'
  showWorkDetail $(e.target).closest(".work-container").attr("id")

showWorkDetail = (clientName) ->
  $('#work-modal').removeData('modal')
  $(".modal.fade.in, .modal").css "top", -975

  $('#work-modal').on 'show', ->
    $('#work-modal').css "max-height", $(window).height()
    $("body").css "overflow-y", "hidden"

  $('#work-modal').on 'hide', ->
    $("body").css "overflow-y", "scroll"

  $('#work-modal').on 'shown', ->
    $(".bottom-nav .prev").html "« Previous: " + prevPageInfo()[2]
    $(".bottom-nav .next").html "Next: " + nextPageInfo()[2] + " »"
    $('#work-modal').css "max-height", $(window).height()
    $('#work-modal').css "overflow-x", 'hidden'

  $('#work-modal').modal {'remote': "work/#{clientName}"}

setupMap = ->
  coordinate = new google.maps.LatLng(37.798793,-122.404789)
  myOptions =
    center: coordinate
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  map = new google.maps.Map($("#map_canvas")[0], myOptions)
  marker = new google.maps.Marker(position: coordinate, map: map)
  return

handleNextWorkDetail = ->
  changeWorkDetail nextPageInfo()[1]

handlePrevWorkDetail = ->
  changeWorkDetail prevPageInfo()[1]

changeWorkDetail = (newPageClientName) ->
  $('.modal-body').load "/work/" + newPageClientName, (response, status, xhr) ->
    if status == "error"
      console.log "Failed to load work detail."
      return

    $(".bottom-nav .prev").html "« Previous: " + prevPageInfo()[2]
    $(".bottom-nav .next").html "Next: " + nextPageInfo()[2] + " »"

nextPageInfo = () ->
  clientName = $("#modal-container").data("client-name")
  return unless clientName?
  for pageInfo, index in sevenWeb.workPages
    if pageInfo[1] == clientName
      return if index == sevenWeb.workPages.length-1 then sevenWeb.workPages[0] else sevenWeb.workPages[index+1]

prevPageInfo = () ->
  clientName = $("#modal-container").data("client-name")
  return unless clientName?
  for pageInfo, index in sevenWeb.workPages
    if pageInfo[1] == clientName
      return if index == 0 then sevenWeb.workPages[sevenWeb.workPages.length-1] else sevenWeb.workPages[index-1]

handlePageWidth = (forceSetWidth = false) ->
  # listen to window resize to set width on the right background
  if window.innerWidth >= 1920
    bgWidth = 490
  else if window.innerWidth > 980
    #console.log 'outside 980 grid: ' + window.innerWidth
    bgWidth = (window.innerWidth - 980) / 2
   
    # if $.browser.mozilla
    #   bgWidth = bgWidth - 2
    #   console.log 'zillllllaaaa'
  else
    bgWidth = 0

  if window.innerWidth % 2 == 0 || forceSetWidth
    $('#sf-right, .section-bg-layer div').css 'width', bgWidth

jQuery ->
  setupMap()
  handlePageWidth(true)

  $(".work-hover").hide
  $(".logo-nav-item").hover logoHover, logoUnhover
  $(".nav-item").hover navHover, navUnhover

  $(".work-container").hover(workHover, workUnhover)
    .click showWorkDetailHandler

  $("#nav .logo-nav-item, #nav .nav-item, #nav a, .down-btn").click (e) ->
    handleNavClicks e
   
  $("#contact-button").click ->
    $("#contact-form").submit()

  $("#contact-form").submit ->
    alert("Thanks!")
    form = $(this)
    $.post form.attr('action'), form.serialize(), (r) ->
      console.log(r)
      alert("TODO: Error handling.")
    return false

  $('#modal-parent').on "click", ".close", ->
    $('#work-modal').modal('hide')

  $('#modal-parent').on "click", ".prev", handlePrevWorkDetail
  $('#modal-parent').on "click", ".next", handleNextWorkDetail
  $("#modal-parent").on 'click', ".related-item img", ->
    changeWorkDetail $(this).data("client-name")

  $(document).keydown (e) ->
    switch e.keyCode
      when 37
        handlePrevWorkDetail()
        false
      when 39
        handleNextWorkDetail()
        false

  document.body.style.overflowX = 'hidden';

  $(window).resize (e) ->
    handlePageWidth e













