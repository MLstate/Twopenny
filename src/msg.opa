/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type Msg.t = private(string)

type Msg.segment =
    { text : string }
  / { label : Label.ref }
  / { url : Uri.uri }
  / { user : User.ref }

Msg = {{

  create(s : string) : Msg.t =
    @wrap(s)

  @private parse(msg : Msg.t) : list(Msg.segment) =
    word = parser
    /* FIXME we probably want to extend the character set
             below. */
    | word=([a-zA-Z0-9_\-]+) -> Text.to_string(word)
    user_prefix = parser "@" -> void
    label_prefix = parser "#" -> void
    url_prefix = parser "http://" -> void
    special_prefix = parser user_prefix | label_prefix | url_prefix;
    segment_parser = parser
    | user_prefix user=word -> { user = User.mk_ref(user) }
    | label_prefix label=word -> { label = Label.mk_ref(label) }
     /* careful here, Uri.uri_parser too liberal, as it parses things like
        hey.ho as valid URLs; so we use "http://" prefix to recognize URLs */
    | &url_prefix url=Uri.uri_parser -> ~{ url }
     /* below we eat a complete [word] or a single non-word character; the
        latter case alone may not be enough as we don't want:
        sthhttp://sth to pass for an URL. */
    | txt=((!special_prefix (word | .))+) -> // Warning! + not * ; otherwise it will loop
        { text = Text.to_string(txt) }
    msg_parser = parser res=segment_parser* -> res
    Parser.parse(msg_parser, @unwrap(msg))

  render(msg : Msg.t) : xhtml =
     render_segment =
    | ~{ text } -> <>{text}</>
    | ~{ url } ->
       // we add spaces around URLs to avoid collapsing them together with adjacent text
      <> <a href={url}>{Uri.to_string(url)}</> </>
    | ~{ label } -> Label.to_anchor(label)
    | ~{ user } -> User.to_anchor(user)
    content = List.map(render_segment, parse(msg))
    <div class="msg">{content}</>

  submit_msg(user : User.ref)(content : string) =
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

}}
