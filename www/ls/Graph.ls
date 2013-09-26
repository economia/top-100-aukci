monthsHuman = <[leden únor březen duben květen červen červenec srpen září říjen listopad prosinec]>

window.Graph = class Graph
    (@parentSelector, @datapoints, @categories, {width=970_px, height=600_px}={}) ->
        @margin = [15 16 20 80] # trbl
        @width = width - @margin.1 - @margin.3
        @height = height - @margin.0 - @margin.2
        @svg = d3.select parentSelector .append \svg
            ..attr \height @height + @margin.0 + @margin.2
            ..attr \width  @width + @margin.1 + @margin.3
        @drawing = @svg.append \g
            ..attr \transform "translate(#{@margin.3}, #{@margin.0})"
            ..attr \class \drawing
        @xAxisGroup = @drawing.append \g
            ..attr \class "x axis"
        @yAxisGroup = @drawing.append \g
            ..attr \class "y axis"

        dates = @datapoints.map (.date)
        min_date = Math.min ...dates
        min_date -= 1e10
        max_date = Math.max ...dates
        prices = @datapoints.map (.price)
        min_price = Math.min ...prices
        min_price -= 4e5
        max_price = Math.max ...prices

        @scale_x = d3.time.scale!
            ..domain [min_date, max_date]
            ..range [0 @width]
        @scale_y = d3.scale.log!
            ..domain [min_price, max_price]
            ..range [@height, 0]
        @fillColor = d3.scale.ordinal!
            ..domain @categories
            ..range <[ #F50F0F #FAE317 #0D7FBE #FFFFFF #000000 ]>

    draw: ->
        @drawDatapointSymbols!
        @drawAxes!

    drawDatapointSymbols: ->
        rectScale     = 0.23
        getRectWidth  = (d) ~> d.width * rectScale
        getRectHeight = (d) ~> d.height * rectScale

        selection = @drawing.selectAll \rect
            .data @datapoints
            .enter!append \rect
                ..attr \x ~>
                    x = @scale_x it.date
                    x - 0.5 * getRectWidth it
                ..attr \y ~>
                    y = @scale_y it.price
                    y - 0.5 * getRectHeight it
                ..attr \fill ~>
                    @fillColor it.kategorie
                ..attr \width getRectWidth
                ..attr \height getRectHeight
                ..attr \class (line) -> "symbol notHiding #{line.partyId} #{line.agencyId}"
                ..attr \opacity 1
                ..on \click window.drawSidebar


    drawAxes: ->
        @drawYAxis!
        @drawXAxis!

    drawXAxis: ->
        xAxis = d3.svg.axis!
            ..scale @scale_x
            ..ticks d3.time.years
            ..tickSize 3
            ..outerTickSize 0
            ..orient \bottom
        @xAxisGroup
            ..attr \transform "translate(0, #{@height})"
            ..call xAxis
            ..selectAll \text
                ..attr \dy 9

    drawYAxis: ->
        yAxis = d3.svg.axis!
            ..scale @scale_y
            ..tickSize @width
            ..outerTickSize 0
            ..tickFormat -> "#{Math.round it / 1e6} 000 000"
            ..orient \right
        @yAxisGroup
            ..call yAxis
            ..selectAll "text"
                ..attr \x -10
                ..attr \dy 5
                ..style \text-anchor \end
            ..selectAll "line"
                ..filter( -> it % 10)
                    ..classed \minor yes
