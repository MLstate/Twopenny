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
    <div class="error">
      Whoooaa, take it easy, I cannot remember anything longer
      than 140 characters, you know? You'll have too be a tad
      more terse.
    </>

  get_input_text_id(id) = id
  get_controls_id(id) = "{id}_controls"
  get_counter_id(id) = "{id}_counter"
  get_preview_id(id) = "{id}_preview"
  get_submit_button_id(id) = "{id}_submit_button"

  submit_button_cfg =
    { WButton.default_config with
      common_style = WStyler.merge([ WButton.default_config.common_style
                                   , { class=["submit_btn"] }
                                   ])
    }

  get_content(id) = Dom.get_value(#{get_input_text_id(id)})

  set_content(id, val) = Dom.set_value(#{get_input_text_id(id)}, val)

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
    do Dom.transform([#{get_counter_id(id)} <- counter_xhtml])
    preview =
      if remaining > 0 then
        mk_msg(content) |> Msg.render(_, {preview})
      else
        MSG_TOO_LONG_WARNING
    do Dom.transform([#{get_preview_id(id)} <- preview])
    enabled = not(String.is_empty(content) || remaining < 0)
    do WButton.set_enabled_state(submit_button_cfg, get_submit_button_id(id),
         enabled)
    void

  @private msgbox_state(id : string, mk_msg, state : {active} / {inactive}) = evt ->
    style = match state with
            | {active} -> css
                { border: 2px solid #C0C000
                ; margin: 0px
                }
            | {inactive} -> css
                { margin: 1px
                ; border: 1px solid #C0CAED
                }
     // REMARK explain how to move from immediate Dom.show/Dom.hide to animation
    animate(f) =
      Dom.transition(_, Dom.Effect.with_duration({millisec = 200}, f()))
    f = match state with
        | {active} -> animate(Dom.Effect.show)
        | {inactive} -> animate(Dom.Effect.hide)
    do update(id, mk_msg)(evt)
    _ = f(#{get_preview_id(id)})
    _ = f(#{get_controls_id(id)})
    do WStyler.set_dom(~{style}, get_input_text_id(id))
    void

  html(id : string, mk_msg : string -> Msg.t, submit : Msg.t -> void) : xhtml =
    do debug("called html")
    inputbox =
       /* WARNING! If we change the function call below
          into a closure then we have to be careful with
          slicing, as at the moment this whole function ends
          up on the server. But there must be a better
          way of doing it than the repetition below... */
      <textarea id=#{get_input_text_id(id)} onready={update(id, mk_msg)}
        onkeyup={update(id, mk_msg)} onchange={update(id, mk_msg)}
        onblur={msgbox_state(id, mk_msg, {inactive})}
        onfocus={msgbox_state(id, mk_msg, {active})}
      />
    counter = <span class="counter" id=#{get_counter_id(id)}></>
    submit_msg(_) =
      do get_content(id) |> mk_msg(_) |> submit(_)
      do set_content(id, "")
      void
    accept = WButton.html(submit_button_cfg, get_submit_button_id(id),
      [({click}, submit_msg)], MSG_SUBMIT)
    hide = apply_css(css{display: none}, _)
    prompt = <h2>What's on your mind?</>
    controls =
      <div id=#{get_controls_id(id)} class="controls">
        {counter}
        {accept}
      </div> |> hide
    preview = <div id=#{get_preview_id(id)} class="preview" /> |> hide
    <div class="msg_box">
      {prompt}
      {inputbox}
      {controls}
      {preview}
    </>

}}

msg_box_css = css
  div {} // FIXME
  .msg_box {
    width: 540px;
  }
  .msg_box textarea {
    height: 80px;
    background: #E8EDFF;
    margin: 1px;
    border: 1px solid #C0CAED;
    border-radius: 10px;
    resize: vertical;
    outline: none;
    font-size: 14px;
    font-family: Verdana;
    width: 100%;
  }
  .msg_box .error {
    border: 1px solid red;
    padding: 5px;
    background: #EEE;
    border-radius: 5px;
  }
  .msg_box .controls {
    text-align: right;
    margin-right: 10px;
  }
  .msg_box .counter {
    margin-right: 10px;
  }
