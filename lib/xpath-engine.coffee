libxmljs = require 'libxmljs'

module.exports =
    class XPathEngine
        constructor: (@editor) ->
            @parser = new DOMParser

        selectNodes: (query) ->
            results = []
            if @editor and @editor.getText()
                text = @editor.getText()
                xdoc = libxmljs.parseXmlString(text)

                # TODO pass errors up (can't get to show)
                xpathResult = xdoc.find(query, {"h": "urn:hl7-org:v3", "xsi": "http://www.w3.org/2001/XMLSchema-instance"})
                if xpathResult? && xpathResult.length > 0 && xpathResult[0].type() != 'document'
                    results = for result in xpathResult
                        query: query
                        value: result
                        isTerminalNode: result.type() != 'Element'
                        line: result.line()

            return results
