return if not Modernizr.svg
d3.selectAll \.hiddenIfIncapableBrowser .classed \hiddenIfIncapableBrowser no
d3.selectAll \.fallback .remove!
sidebar = d3.selectAll \#sidebar
backButton = sidebar.select "a.backButton"
    ..on \click -> sidebar.classed \active no
window.drawSidebar = (item) ->
    sidebar.classed \active yes
    sidebar.selectAll ".content" .remove!
    sidebar.selectAll ".content"
        .data [item]
        .enter!append \div
            ..attr \class \content
            ..append \h1
                ..html (.nazev)
            ..append \img
                ..attr \src -> "../data/top100/#{it.id}.jpg"
            ..append \h2
                ..html -> "#{it.autor}, #{it.rok}"
            ..append \h3
                ..html -> "#{it.technika}, #{it.rozmer}"
            ..append \h4
                ..html -> "#{formatPrice it.price} Kč, #{it.id}. nejdražší<br />#{it.dum}, #{formatDate it.date}"
            ..append \a
                ..html "Dílo v databázi ART+"
                ..attr \href (.link)
                ..attr \target \_blank

formatDate = ->
    "#{it.getDate!}. #{it.getMonth! + 1}. #{it.getFullYear!}"
formatPrice = (price) ->
    price .= toString!
    out = []
    len = price.length
    for i in [0 til len]
        out.unshift price[len - i - 1]
        if 2 == i % 3 and i isnt len - 1
            out.unshift ' '
    out.join ''

kategorie =
    \1 : "Moderna"
    \2 : "19. století"
    \3 : "Staří mistři"
    \4 : "Poválečné"
    \5 : "Zahraničí"
rowAssigner = (it, index) ->
    id        : index + 1
    autor     : it.autor
    nazev     : it.nazev
    rok       : it.rok
    price     : +it.cena
    technika  : it.technika
    rozmer    : it.rozmer
    dum       : it.dum
    link      : it.link
    width     : +it.vyska
    height    : +it.sirka
    kategorie : kategorie[it.kategorie]
    date      : new Date it.datum
(err, paintings) <~ d3.csv "../data/data.csv", rowAssigner
width = 970_px
height = 680_px
paintings .= filter -> it.date.getFullYear! > 2003
paintings .= sort (a, b) ->
    b.width * b.height - a.width * a.height

category_values = for id, name of kategorie
    name
graph = new Graph \#content paintings, category_values, { width, height }
    ..draw!
