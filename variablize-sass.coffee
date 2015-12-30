fs = require('fs')

vars = {}
count = 0

ParseSass =
  myRegexp: /url\((".+?")\)/g
  path:""
  output: "./output.sass"

  inti: (path)->
    @path = path
    @readFile()

  readFile: ()->
    fs.readFile @path, 'utf8', (err, data) =>
      if err
        return console.log(err)
      else
        @onSuccessFullRead(data)

  onSuccessFullRead: (data)->
    lines = data.split('\n')

    for line, index in lines
      if lines[index].indexOf('url(') isnt -1

        match = @myRegexp.exec(lines[index])
        while match?
          @forEachMatch(match,lines, index)
          match = @myRegexp.exec(line)
    @printAllLines(lines)

  forEachMatch:(match,lines, index)->

    url = match[1]
    varName = "$lifelock-asset-url-"+count++

    # save url to vars
    vars[url] = varName
    # replace with var name
    lines[index] = lines[index].replace(url, varName)

  printAllLines: (lines)->
    for line in lines
      fs.appendFile @output, line+"\n", ->



ParseSass.inti('/Users/james.kiely/partner-offers/resources/styles/compiled-offers.scss')
