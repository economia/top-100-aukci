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
    technik : it.technika
    rozmer  : it.rozmer
    width   : +it.sirka
    height  : +it.vyska
    date    : new Date it.datum
(err, json) <~ d3.csv "../data/data.csv", rowAssigner
console.log err
console.log json
