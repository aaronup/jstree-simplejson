#globals jQuery, define, exports, require
do ->
    "use strict"
    get_children = ->
        children = []
        $(this).each((index, child) ->
            link = 
                text: child.text
                href: child.a_attr.href
                weight: children.length
            if child.children.length > 0 then link.links = get_children.call( child.children )
            children.push( link )
            return
        )
        children

    build_dom = (links) ->
        ul = $( '<ul></ul>' )
        $( links ).each( (index, link) ->
            li = $( '<li><a href=""></a></li>' )
            a = li.children().first()
            a.text( link.text )
            a.attr( href: link.href )
            if link.links isnt undefined and link.links.length > 0
                li.append( build_dom( link.links ) )
            ul.append( li )
        )
        ul

    get_simplejson = (obj, options, flat) ->
        json = @get_json.call(@, obj, options, flat)

        simplejson = get_children.call(json)
        return simplejson
        # Do stuff

    load_simplejson = (json) ->
        if typeof json is 'string' 
            $.when($.getJSON(json)).then( $.proxy(load_simplejson, @) )
        else
            if typeof json is 'object' and json.links isnt undefined then json = json.links
            dom = build_dom( json )
            @_append_html_data( @get_node( '#' ), dom )
            return @

    ((factory) ->
        "use strict"

        if typeof define is 'function' and define.amd
            # AMD Register as an anonymouse module
            define('jstree.simplejson', ['jquery', 'jstree'], factory)
        else if typeof exports is 'object' then factory( require['jquery'], require['jstree'] )
        else factory( jQuery, jQuery.jstree )
        return
    )(($, jstree = $.jstree) ->
        "use strict"
        if jstree.core.prototype.get_simplejson then return

        jstree.core.prototype.get_simplejson = get_simplejson
        jstree.core.prototype.load_simplejson = load_simplejson
        return
    )
    return
