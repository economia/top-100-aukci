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
    technik   : it.technika
    rozmer    : it.rozmer
    width     : +it.sirka
    height    : +it.vyska
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
