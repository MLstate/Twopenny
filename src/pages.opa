/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * {1 HTML generation for Twopenny pages}
**/

Pages = {{

  unimplemented =
    <>
      Coming soon... stay tuned
    </>

  main_page() =
    ("Twopenny", unimplemented)

  @client show_new_message(~{newmsg}) =
    exec([#msgs -<- Msg.render(newmsg, {new})])

  @client setup_msg_updates(_) =
    chan = Session.make_callback(show_new_message)
    do MsgFactory.subscribe_to_all(chan)
    do debug("subscribing to new messages")
    void

  @client setup_newmsg_box(user)(_) =
    xhtml = WMsgBox.html("msgbox", Msg.create(user, _), MsgFactory.submit)
    exec([#newmsg <- xhtml])

  user_page(user_ref : User.ref) =
    user_string = User.ref_to_string(user_ref)
    content =
      match User.get(user_ref) with
      | {none} ->
          <div class="error_page">
            Sorry, but I know of no user <strong>{user_string}</>
          </>
      | {some=user} ->
          <>
            {User.get_header(user_ref, user)}
            <div id=#newmsg onready={setup_newmsg_box(user_ref)} />
            <div class="separator" />
            <div id=#msgs onready={setup_msg_updates} />
          </>
    ("Twopenny :: {user_string}", content)

  label_page(label) =
    ("Twopenny :: {Label.to_string(label)}", unimplemented)

}}

css = [ page_css, msg_css, msg_box_css, user_css ]

page_css = css
  body {
    margin: 0px;
  }
  html {
    width: 800px;
    margin: auto;
    height: 100%;
    padding: 15px;
    border-left: 1px dotted black;
    border-right: 1px dotted black;
  }
  h2 {
    color: #777;
     /* FIXME writing helvetica passes syntax checking and is interpreted
              as un-typed CSS, so goes verbose to the page as font:helvetica;
              Not cool! */
    font-family: Helvetica;
    font-size: 20px;
    margin: 0px 0px 5px 0px;
  }
  .hidden {
    display: none;
  }
  div.separator {
    margin: 30px -15px;
    border-top: 1px dotted black;
  }
/* marking external links
  a[rel="external"], a.external {
    white-space: nowrap;
    padding-right: 10px;
    background: url('/img/link.png') no-repeat 100% 50%;
    zoom: 1;
  }
*/
