$ ->
  (->
    special = jQuery.event.special
    uid1 = "D" + (+new Date())
    uid2 = "D" + (+new Date() + 1)
    special.scrollstart =
      setup: ->
        timer = undefined
        handler = (evt) ->
          _self = this
          _args = arguments
          if timer
            clearTimeout timer
          else
            evt.type = "scrollstart"
            jQuery.event.handle.apply _self, _args
          timer = setTimeout(->
            timer = null
          , special.scrollstop.latency)

        jQuery(this).bind("scroll", handler).data uid1, handler

      teardown: ->
        jQuery(this).unbind "scroll", jQuery(this).data(uid1)

    special.scrollstop =
      latency: 50
      setup: ->
        timer = undefined
        handler = (evt) ->
          _self = this
          _args = arguments
          clearTimeout timer  if timer
          timer = setTimeout(->
            timer = null
            evt.type = "scrollstop"
            jQuery.event.handle.apply _self, _args
          , special.scrollstop.latency)

        jQuery(this).bind("scroll", handler).data uid2, handler

      teardown: ->
        jQuery(this).unbind "scroll", jQuery(this).data(uid2)
  )()
  
  resizeContainerBlocks = ->
    containerHeight = $(window).height()
    $('.container').css('height',containerHeight)
  
  hideTriggers = ->
    
    windowHeight = $(window).height()
    scrollTop = $(document).scrollTop()
    scrollBottom = $(document).height() - windowHeight - scrollTop
    
    display = if ((windowHeight - scrollTop) > 0) then 'none' else 'block'
    $('a.trigger.trigger-up').css('display',display)

    display = if ((windowHeight - scrollBottom) > 0) then 'none' else 'block'
    $('a.trigger.trigger-down').css('display',display)

  
  changeContainerOpacity = ->
    
    # windowHeight = $(window).height()
    # scrollTop = $(document).scrollTop()
    # 
    # containerNo = Math.round(scrollTop / windowHeight)
    # 
    # console.log ((scrollTop + (windowHeight/2)) % windowHeight)
    # console.log "You are #{} from container no. #{containerNo}"
      
  correctScroll = ->
    
    windowHeight = $(window).height()
    scrollTop = $(document).scrollTop()
    
    offset = (scrollTop % windowHeight)
    
    if offset <= 0
      return false
    else
      scrollAmmount = Math.round(scrollTop / windowHeight) * windowHeight
      $("html, body").animate
        scrollTop: scrollAmmount
      , 300
      return true
    
  $(window).bind 'resize', (e) =>
    resizeContainerBlocks()
    hideTriggers()
  
  $(document).bind 'scroll', (e) ->
    hideTriggers()
    changeContainerOpacity()
  .bind 'scrollstop', () ->
    correctScroll()
    
  # Initialize
  resizeContainerBlocks()
  hideTriggers()
  
  $('a.trigger').bind 'click', (e) ->
    
    windowHeight = $(window).height()
    scrollTop = $(document).scrollTop()
    scrollBottom = $(document).height() - windowHeight - scrollTop
    
    scrollAmmount = 0
    
    if $(e.target).hasClass('trigger-down')
      scrollAmmount = scrollTop + windowHeight
        
    else if $(e.target).hasClass('trigger-up')
      scrollAmmount = scrollTop - windowHeight
    
    $("html, body").animate
      scrollTop: scrollAmmount
    , 300
    
    false