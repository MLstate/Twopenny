/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type Msg.t = private(string)

type Msg.segment =
    { text : string }
  / { label : Label.ref }
  / { url : Url.url }
  / { user : User.ref }

Msg = {{

  create(s : string) : Msg.t =
    @wrap(s)

  parse(msg : Msg.t) : list(Msg.segment) =
    word = parser
    /* FIXME we probably want to extend the character set
             below. */
    | word=([a-zA-Z0-9_\-]*) -> Text.to_string(word)
    segment_parser = parser
    | [@] user=word -> { user = User.mk_ref(user) }
    | [#] label=word -> { label = Label.mk_ref(label) }
    | &"http://" url=UriParser.uri -> ~{ url }
    | txt=((![@#] .)*) -> { text = Text.to_string(txt) }
    msg_parser = parser res=segment_parser* -> res
    Parser.parse(msg_parser, @unwrap(msg))

}}
