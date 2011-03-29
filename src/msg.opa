/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.{core,button}

type Msg.t = private(string)

type Msg.segment =
    { text : string }
  / { label : Label.ref }
  / { url : Uri.uri }
  / { user : User.ref }

Msg =
  MAXIMUM_MESSAGE_LENGTH = 140
  REMAINING_MESSAGE_LENGTH = 20
{{

  create(s : string) : Msg.t =
    @wrap(s)

  @private parse(msg : Msg.t) : list(Msg.segment) =
    word = parser
    /* FIXME we probably want to extend the character set
             below. */
    | word=([a-zA-Z0-9_\-]*) -> Text.to_string(word)
    segment_parser = parser
    | [@] user=word -> { user = User.mk_ref(user) }
    | [#] label=word -> { label = Label.mk_ref(label) }
    | &"http://" url=Uri.uri_parser -> ~{ url }
    | txt=((![@#] .)+) -> // Warning! + not * ; otherwise it will loop
        { text = Text.to_string(txt) }
    msg_parser = parser res=segment_parser* -> res
    Parser.parse(msg_parser, @unwrap(msg))

  render(msg : Msg.t) : xhtml =
    render_segment =
    | ~{ text } -> <>{text}</>
    | ~{ url } ->
      url_string = Uri.to_string(url)
      <A href={url_string}>{url_string}</>
    | ~{ label } -> Label.to_anchor(label)
    | ~{ user } -> User.to_anchor(user)
    content = List.map(render_segment, parse(msg))
    <div class="msg">{content}</>

  submit_msg(user : User.ref, msgbox : dom) = _ ->
    content = Dom.get_value(msgbox)
    msg = create(content)
    do Data.new_message(user, msg)
    index =
    | ~{user} -> Data.new_user_mention(user, msg)
    | ~{label} -> Data.new_label_msg(label, msg)
    | {url=_}
    | {text=_} -> void
    do List.iter(index, parse(msg))
    do exec([#msgs +<- <>{render(msg)}</>])
    void

  @private apply_css(css_style, dom) =
    WStyler.add(WStyler.make_style(css_style), dom)

  @client update_msg_counter(msgbox : dom, counter_id : string) = _ ->
    remaining = Dom.get_value(msgbox)
             |> String.length(_)
             |> MAXIMUM_MESSAGE_LENGTH - _
    counter_css =
      if remaining < REMAINING_MESSAGE_LENGTH then
        css { color: red }
      else
        []
    counter_xhtml = <span>{remaining}</>
                 |> apply_css(counter_css, _)
    do exec([#{counter_id} <- counter_xhtml])
    void

  msgbox(id : string, user : User.ref) : xhtml =
    counter_id = "{id}_counter"
    accept = WButton.html(WButton.default_config, uniq(),
      [({click}, submit_msg(user, #{id}))], <>Tweet!</>)
    inputbox =
       /* WARNING! If we change the function call below
          into a closure then we have to be careful with
          slicing, as at the moment this whole function ends
          up on the server. But there must be a better
          way of doing it than the repetition below... */
      <textarea id=#{id}
        onready={update_msg_counter(#{id}, counter_id)}
        onkeypress={update_msg_counter(#{id}, counter_id)}
        onchange={update_msg_counter(#{id}, counter_id)} />
    counter =
      <div id=#{counter_id}></>;
    <>
      {inputbox}
      {counter}
      {accept}
      <div id=#msgs />
    </>

}}
