/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.{core,button}

WMsgBox =
  MAXIMUM_MESSAGE_LENGTH = 140
  REMAINING_MESSAGE_LENGTH = 20

  MSG_SUBMIT = <>Submit!</>
  MSG_TOO_LONG_WARNING =
    <>Whoooaa, take it easy, I cannot remember anything longer
    than 140 characters, you know? You'll have too be a tad
    more terse.</>

  get_input_text_id(id) = id
  get_counter_id(id) = "{id}_counter"
  get_preview_id(id) = "{id}_preview"
  get_submit_button_id(id) = "{id}_submit_button"

  submit_button_cfg = WButton.default_config

  apply_css(css_style, dom) =
    WStyler.add(WStyler.make_style(css_style), dom)

  get_content(id) =
    Dom.get_value(#{get_input_text_id(id)})
{{

  @private @client update(id : string) = _ ->
    content = get_content(id)
    remaining = MAXIMUM_MESSAGE_LENGTH - String.length(content)
    counter_css =
      if remaining < 0 then
        css { color: red; font-decoration: underline }
      else if remaining < REMAINING_MESSAGE_LENGTH then
        css { color: red }
      else
        []
    counter_xhtml = <span>{remaining}</>
                 |> apply_css(counter_css, _)
    do exec([#{get_counter_id(id)} <- counter_xhtml])
    preview =
      if remaining > 0 then
        Msg.create(content) |> Msg.render(_)
      else
        MSG_TOO_LONG_WARNING
    do exec([#{get_preview_id(id)} <- preview])
    enabled = not(String.is_empty(content) || remaining < 0)
    do WButton.set_enabled_state(submit_button_cfg, get_submit_button_id(id),
         enabled)
    void

  html(id : string, submit : string -> void) : xhtml =
    text_id = get_input_text_id(id)
    inputbox =
       /* WARNING! If we change the function call below
          into a closure then we have to be careful with
          slicing, as at the moment this whole function ends
          up on the server. But there must be a better
          way of doing it than the repetition below... */
      <textarea id=#{text_id} onready={update(id)}
        onkeyup={update(id)} onchange={update(id)} />
    counter =
      <div id=#{get_counter_id(id)}></>
    preview =
      <div id=#{get_preview_id(id)}></>
    submit_msg(_) = submit(get_content(id))
    accept = WButton.html(submit_button_cfg, get_submit_button_id(id),
      [({click}, submit_msg)], MSG_SUBMIT)
    <>
      {inputbox}
      {counter}
      {preview}
      {accept}
    </>

}}
