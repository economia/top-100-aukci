monthsHuman = <[leden únor březen duben květen červen červenec srpen září říjen listopad prosinec]>

window.Graph = class Graph
    (@parentSelector, @datapoints, {width=970_px, height=600_px}={}) ->
        @margin = [10 10 20 34] # trbl
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
        max_date = Math.max ...dates
        prices = @datapoints.map (.price)
        min_price = Math.min ...prices
        max_price = Math.max ...prices

        @scale_x = d3.time.scale!
            ..domain [min_date, max_date]
            ..range [0 @width]
        @scale_y = d3.scale.log!
            ..domain [min_price, max_price]
            ..range [@height, 0]

        @datapointSymbol = d3.svg.symbol!
            ..size 45

    draw: ->
        @drawDatapointSymbols!
        @drawAxes!

    drawDatapointSymbols: (scaleIsExpanding) ->
        selection = @drawing.selectAll \path
            .data @datapoints
            .enter!append \path
                ..attr \class (line) -> "symbol notHiding #{line.partyId} #{line.agencyId}"
                ..attr \opacity 1
                ..attr \d (pt) ~> @datapointSymbol!
                ..attr \transform (pt) ~> "translate(#{@scale_x pt.date}, #{@scale_y pt.price}) scale(1)"

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
            ..tickValues [1 3 5 10 15 20 30 40]
            ..tickFormat -> "#it%"
            ..orient \right
        @yAxisGroup
            ..call yAxis
            ..selectAll "text"
                ..attr \x -30
                ..attr \dy 5
            ..selectAll "line"
                ..filter( -> it % 10)
                    ..classed \minor yes
