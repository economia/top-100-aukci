require! fs
dir = "#__dirname/../support/top100"
(err, files) <~ fs.readdir dir
files.forEach (file) ->
    newName = parseInt file, 10
    fs.rename "#dir/#file" "#dir/#newName.jpg"
