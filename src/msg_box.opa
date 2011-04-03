/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.{core,button}

@client WMsgBox =
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

  get_content(id) =
    Dom.get_value(#{get_input_text_id(id)})
{{

  @private update(id : string, mk_msg) = _ ->
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
        mk_msg(content) |> Msg.render(_, {preview})
      else
        MSG_TOO_LONG_WARNING
    do exec([#{get_preview_id(id)} <- preview])
    enabled = not(String.is_empty(content) || remaining < 0)
    do WButton.set_enabled_state(submit_button_cfg, get_submit_button_id(id),
         enabled)
    void

  @private msgbox_style(text_id : string, active : bool) = _ ->
    style =
      if active then
        css {
          border: 2px solid #C0C000;
          margin: 0px;
        }
      else
        css {
          margin: 1px;
          border: 1px solid #C0CAED;
        }
    WStyler.set_dom(~{style}, text_id)

  html(id : string, mk_msg : string -> Msg.t, submit : Msg.t -> void) : xhtml =
    do debug("called html")
    text_id = get_input_text_id(id)
    inputbox =
       /* WARNING! If we change the function call below
          into a closure then we have to be careful with
          slicing, as at the moment this whole function ends
          up on the server. But there must be a better
          way of doing it than the repetition below... */
      <textarea id=#{text_id} onready={update(id, mk_msg)}
        onkeyup={update(id, mk_msg)} onchange={update(id, mk_msg)}
        onblur={msgbox_style(text_id, false)}
        onfocus={msgbox_style(text_id, true)}
      />
    counter =
      <div id=#{get_counter_id(id)}></>
    preview =
      <div id=#{get_preview_id(id)}></>
    submit_msg(_) = get_content(id) |> mk_msg(_) |> submit(_)
    accept = WButton.html(submit_button_cfg, get_submit_button_id(id),
      [({click}, submit_msg)], MSG_SUBMIT)
    <div class="msg_box">
      {inputbox}
      {counter}
      {preview}
      {accept}
    </>

}}

msg_box_css = css
  div {} // FIXME
  .msg_box textarea {
    width: 350px;
    height: 80px;
    background: #E8EDFF;
    border-radius: 10px;
    resize: vertical;
    outline: none;
    font-size: 14px;
    font-family: Verdana;
  }
