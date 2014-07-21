(function() {
  "use strict";
  var build_dom, get_children, get_simplejson, load_simplejson;
  get_children = function() {
    var children;
    children = [];
    $(this).each(function(index, child) {
      var link;
      link = {
        text: child.text,
        href: child.a_attr.href,
        weight: children.length
      };
      if (child.children.length > 0) {
        link.links = get_children.call(child.children);
      }
      children.push(link);
    });
    return children;
  };
  build_dom = function(links) {
    var ul;
    ul = $('<ul></ul>');
    $(links).each(function(index, link) {
      var a, li;
      li = $('<li><a href=""></a></li>');
      a = li.children().first();
      a.text(link.text);
      a.attr({
        href: link.href
      });
      if (link.links !== void 0 && link.links.length > 0) {
        li.append(build_dom(link.links));
      }
      return ul.append(li);
    });
    return ul;
  };
  get_simplejson = function(obj, options, flat) {
    var json, simplejson;
    json = this.get_json.call(this, obj, options, flat);
    simplejson = get_children.call(json);
    return simplejson;
  };
  load_simplejson = function(json) {
    var dom;
    if (typeof json === 'string') {
      return $.when($.getJSON(json)).then($.proxy(load_simplejson, this));
    } else {
      if (typeof json === 'object' && json.links !== void 0) {
        json = json.links;
      }
      dom = build_dom(json);
      this._append_html_data(this.get_node('#'), dom);
      return this;
    }
  };
  (function(factory) {
    "use strict";
    if (typeof define === 'function' && define.amd) {
      define('jstree.simplejson', ['jquery', 'jstree'], factory);
    } else if (typeof exports === 'object') {
      factory(require['jquery'], require['jstree']);
    } else {
      factory(jQuery, jQuery.jstree);
    }
  })(function($, jstree) {
    if (jstree == null) {
      jstree = $.jstree;
    }
    "use strict";
    if (jstree.core.prototype.get_simplejson) {
      return;
    }
    jstree.core.prototype.get_simplejson = get_simplejson;
    jstree.core.prototype.load_simplejson = load_simplejson;
  });
})();
