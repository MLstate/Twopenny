/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.button

type Msg.t = private(string)

type Msg.segment =
    { text : string }
  / { label : Label.ref }
  / { url : Uri.uri }
  / { user : User.ref }

@both_implem Msg = {{

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

  submit_msg(user : User.ref, msgbox : dom, _) : void =
    content = Dom.get_value(msgbox)
    msg = create(content)
    do Data.new_message(user, msg)
    index =
    | ~{user} -> Data.new_user_mention(user, msg)
    | ~{label} -> Data.new_label_msg(label, msg)
    | {url=_}
    | {text=_} -> void
    do List.iter(index, parse(msg))
    do exec([#msgs +<- render(msg)])
    void

  msgbox(user : User.ref) : xhtml =
    accept = WSimpleButton.html(uniq(), submit_msg(user, #msgbox, _), "Tweet")
    inputbox = <textarea id=#msgbox />;
    <>
      {inputbox}
      {accept}
      <div id=#msgs />
    </>

}}
