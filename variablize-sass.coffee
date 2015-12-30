fs = require('fs')

vars = {}
count = 0

ParseSass =
  myRegexp: /url\((".+?")\)/g
  path:""
  output: "./output.scss"

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
    @outputAllLines(lines)

  forEachMatch:(match,lines, index)->

    url = match[1]
    varName = if vars[url] then vars[url] else "$lifelock-asset-url-"+count++

    # save url to vars
    unless vars[url]? then vars[url] = varName
    # replace with var name
    lines[index] = lines[index].replace(url, varName)

  outputAllLines: (lines)->
    fs.writeFileSync @output, ""

    for k,v of vars
      output = "#{v}: #{k};"
      fs.appendFileSync @output, output+"\n"

    fs.appendFileSync @output, "\n\n\n"

    for line in lines
      fs.appendFileSync @output, line+"\n"



ParseSass.inti('/Users/james.kiely/partner-offers/resources/styles/compiled-offers.scss')
