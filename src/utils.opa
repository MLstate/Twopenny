/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

debug = Log.debug("[twopenny]", _)

apply_css(css_style, dom) =
  WStyler.add(WStyler.make_style(css_style), dom)

show_photo(~{max_width_px; max_height_px}, img_url) : xhtml =
  size_css = css
    { max-width: {max_width_px}px
    ; max-height: {max_height_px}px
    }
  <img class="image" src={img_url} />
  |> apply_css(size_css, _)
