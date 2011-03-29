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
    | word=([a-zA-Z0-9_\-]*) -> Text.to_string(word)
    segment_parser = parser
    | [@] user=word -> { user = User.mk_ref(user) }
    | [#] label=word -> { label = Label.mk_ref(label) }
    | &"http://" url=Uri.uri_parser -> ~{ url }
    | txt=((![@#] .)*) -> { text = Text.to_string(txt) }
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

}}
