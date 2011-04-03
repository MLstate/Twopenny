/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

debug = Log.debug("[twopenny]", _)

apply_css(css_style, dom) =
  WStyler.add(WStyler.make_style(css_style), dom)

