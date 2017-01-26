{SelectListView, $, $$} = require 'atom-space-pen-views'
XPathEngine = require '../xpath-engine'
escape = require 'escape-html'

module.exports =
    class XPathView extends SelectListView

        constructor: (@editor) ->
            @engine = new XPathEngine(@editor)
            @storeFocusedElement()
            super

        initialize: ->
            super
            @addClass('xml-tools')

        getFilterKey: ->
            return 'query'

        getEmptyMessage: ->
            return 'No Results'

        getLoading: ->
            return 'Enter an XPath query.'

        cancelled: ->
            @hide()

        toggle: ->
            if @panel?.isVisible()
                @cancel()
            else
                @show()

        show: ->
            @panel ?= atom.workspace.addModalPanel(item: this)
            @panel.show()

            @setItems([])
            @focusFilterEditor()

        hide: ->
            @panel?.hide()

        populateList: ->
            query = @getFilterQuery()
            @items = @engine.selectNodes(query)

            super

        viewForItem: (item) ->
            html = '<li class="event">'

            if !item.isTerminalNode
                html += '<strong>[Concatenated]</strong> '

            if item.value.type() == 'element'
                line = item.value.line()
                # text = escape(@editor.lineTextForBufferRow(line - 1))
                text = escape(item.value.toString())

            if item.value.type() == 'text'
                text = item.value.text()

            if item.value.type() == 'attribute'
                text = item.value.value()

            html += '<span>' + text + '</span></li>'
            return html

        confirmed: (item) ->
            # TODO Node.line() is sensitive to blank lines in the file
            @editor.setCursorBufferPosition([item.line - 1, 0])
            @cancel()
