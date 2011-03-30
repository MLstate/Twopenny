/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.{core,button}

WMsgBox =
  MAXIMUM_MESSAGE_LENGTH = 140
  REMAINING_MESSAGE_LENGTH = 20

  get_input_text_id(id) = id
  get_counter_id(id) = "{id}_counter"
  get_submit_button_id(id) = "{id}_submit_button"

  apply_css(css_style, dom) =
    WStyler.add(WStyler.make_style(css_style), dom)

  get_content(id) =
    Dom.get_value(#{get_input_text_id(id)})
{{

  @client update_msg(id : string) = _ ->
    remaining = get_content(id)
             |> String.length(_)
             |> MAXIMUM_MESSAGE_LENGTH - _
    counter_css =
      if remaining < REMAINING_MESSAGE_LENGTH then
        css { color: red }
      else
        []
    counter_xhtml = <span>{remaining}</>
                 |> apply_css(counter_css, _)
    do exec([#{get_counter_id(id)} <- counter_xhtml])
    void

  html(id : string, submit : string -> void) : xhtml =
    text_id = get_input_text_id(id)
    inputbox =
       /* WARNING! If we change the function call below
          into a closure then we have to be careful with
          slicing, as at the moment this whole function ends
          up on the server. But there must be a better
          way of doing it than the repetition below... */
      <textarea id=#{text_id} onready={update_msg(id)}
        onkeypress={update_msg(id)} onchange={update_msg(id)} />
    counter =
      <div id=#{get_counter_id(id)}></>
    submit_msg(_) = submit(get_content(id))
    accept = WButton.html(WButton.default_config, get_submit_button_id(id),
      [({click}, submit_msg)], <>Tweet!</>)
    <>
      {inputbox}
      {counter}
      {accept}
    </>

}}
