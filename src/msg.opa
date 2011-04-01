/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.dateprinter

type Msg.t = private(
   { author: User.ref
   ; content : string
   ; created_at : Date.date
   })

type Msg.segment =
    { text : string }
  / { label : Label.ref }
  / { url : Uri.uri }
  / { user : User.ref }

Msg = {{

  create(author : User.ref, content : string) : Msg.t =
    msg = { ~author ~content created_at=Date.now() }
    @wrap(msg)

  get_creation_date(msg : Msg.t) : Date.date =
    @unwrap(msg).created_at

  get_author(msg : Msg.t) : User.ref =
    @unwrap(msg).author

  get_content(msg : Msg.t) : string =
    @unwrap(msg).content

  parse(msg : Msg.t) : list(Msg.segment) =
    word = parser
    /* FIXME we probably want to extend the character set
             below. */
    | word=([a-zA-Z0-9_\-]*) -> Text.to_string(word)
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
    | txt=((!special_prefix (. word))+) -> // Warning! + not * ; otherwise it will loop
        { text = Text.to_string(txt) }
    msg_parser = parser res=segment_parser* -> res
    Parser.parse(msg_parser, Msg.get_content(msg))

  render(msg : Msg.t, mode : {preview} / {final}) : xhtml =
    render_segment =
    | ~{ text } -> <>{text}</>
    | ~{ url } ->
       // we add spaces around URLs to avoid collapsing them together with adjacent text
      <> <a href={url}>{Uri.to_string(url)}</> </>
    | ~{ label } -> Label.to_anchor(label)
    | ~{ user } -> User.to_anchor(user)
    content = List.map(render_segment, parse(msg))
    date = WDatePrinter.html(WDatePrinter.default_config,
      uniq(), Msg.get_creation_date(msg))
    <div class="msg">
      <img class="image" src="/img/user.png" />
      <div class="content">
        <div class="user">{Msg.get_author(msg) |> User.to_anchor}</>
        <div class="text">{content}</>
        {match mode with
        | {final} -> <div class="date">{date}</>
        | {preview} -> <></> // don't display date in preview
        }
      </>
    </>

  // FIXME WDatePrinter -> "now ago" -> "now"
}}

css = css
  .msg {
    border-top: 1px dotted black;
    border-bottom: 1px dotted black;
    width: 540px;
    min-height: 48px;
    font-size: 15px;
    font-family: Helvetica;
    background: #F0FFF9;
    padding: 15px 0px;
  }
  .msg:hover {
    background: #D9FFF6;
    border-top: 1px solid black;
    border-bottom: 1px solid black;
  }
  .msg .image {
    width: 48px;
    height: 48px;
    margin-left: 3px;
    float: left;
  }
  .msg .content {
    margin-left: 60px;
  }
  .msg .user {
    line-height: 15px;
    color: #333;
    font-weight: bold;
  }
  .msg .text {
    line-height: 19px;
    color: #444;
  }
  .msg .date {
    font-size: 11px;
    color: #999;
  }
