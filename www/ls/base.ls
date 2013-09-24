kategorie =
    \1: "moderna"
    \2: "19.stol"
    \3: "staří mistři"
    \4: "poválečné"
    \5: "zahraničí"
rowAssigner = (it, index) ->
    id      : index + 1
    autor   : it.autor
    nazev   : it.nazev
    rok     : it.rok
    price   : +it.cena
    technik : it.technika
    rozmer  : it.rozmer
    width   : +it.sirka
    height  : +it.vyska
    date    : new Date it.datum
(err, paintings) <~ d3.csv "../data/data.csv", rowAssigner
width = 650_px
height = 600_px
paintings .= filter -> it.date.getFullYear! > 2003
graph = new Graph \#content paintings, { width, height }
    ..draw!
