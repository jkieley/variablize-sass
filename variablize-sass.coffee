fs = require('fs')

vars = {}
count = 0

ParseSass =
  myRegexp: /url\((".+?")\)/g

  readFile: (path)->
    fs.readFile path, 'utf8', (err, data) =>
      if err
        return console.log(err)
      else
        @onSuccessFullRead(data)

  onSuccessFullRead: (data)->
    lines = data.split('\n')

    for line in lines
      if line.indexOf('url(') isnt -1
        match = @myRegexp.exec(line)
        while match?
          @forEachMatch(match,line)
          match = @myRegexp.exec(line)

  forEachMatch:(match,line)->
    url = match[1]
    varName = "$lifelock-asset-url-"+count++

    # save url to vars
    vars[url] = varName
    # replace with var name
    line = line.replace(url, varName)

    console.log line


ParseSass.readFile('./resources/styles/compiled-offers.scss')
