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
      latency: 100
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
  
  changeBackgroundColor = ->
    
    windowHeight = $(window).height()
    scrollTop = $(document).scrollTop()
    
    # Divergence
    divergence = ((scrollTop % windowHeight) / windowHeight)
    
    # Upper Div
    upperDivPos = Math.floor(scrollTop / windowHeight)
    upperDivPos = if upperDivPos <= 0 then 0 else upperDivPos
    
    # Lower Div
    lowerDivPos = Math.floor((scrollTop + windowHeight) / windowHeight)
    lowerDivPos = if lowerDivPos >= $('.container').length then $('.container').length - 1 else lowerDivPos
        
    fromColor = $(".container:nth-child(#{upperDivPos + 1})").data('color')
    toColor = $(".container:nth-child(#{lowerDivPos + 1})").data('color')
    
    $("body").css('background-color',blend(fromColor,toColor,divergence))
      
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
  
  blend = (start,end,divergence) ->
    
    start = hex2rgb(start)
    end   = hex2rgb(end)
    
    getDifference = (int1,int2,divergence) ->
      diff = int1 - int2
      val = int1 - (diff * divergence)
      return val
    
    color =
      r: getDifference(start.r, end.r, divergence)
      g: getDifference(start.g, end.g, divergence)
      b: getDifference(start.b, end.b, divergence)
        
    hex = rgb2hex(color)
        
  $(window).bind 'resize', (e) =>
    resizeContainerBlocks()
    hideTriggers()
  
  $(document).bind 'scroll', (e) ->
    hideTriggers()
    changeContainerOpacity()
    changeBackgroundColor()
    
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
    , 700
    
    false