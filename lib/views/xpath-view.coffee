{SelectListView, $, $$} = require 'atom-space-pen-views'
XPathEngine = require '../xpath-engine'

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

            html += '<span>' + item.value + '</span></li>'
            return html

        confirmed: (item) ->
            @editor.setCursorBufferPosition([item.line - 1, 0])
            @cancel()
