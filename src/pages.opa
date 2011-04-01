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

  @client setup_msg_updates(_) =
    show_new_message(msg) =
      exec([#msgs -<- Msg.render(msg, {final})])
    do MsgFactory.subscribe_to_all(show_new_message)
    void

  user_page(user : User.ref) =
    submission = WMsgBox.html("msgbox", Msg.create(user, _), MsgFactory.submit)
    content =
      <>
        <div class="header">{User.to_string(user)}</>
        {submission}
        <div id=#msgs onready={setup_msg_updates} />
      </>
    ("Twopenny :: {User.to_string(user)}", content)

  label_page(label) =
    ("Twopenny :: {Label.to_string(label)}", unimplemented)

}}

css = [ page_css, msg_css, msg_box_css ]

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
  .header {
    border-top: 1px dotted black;
    border-bottom: 1px dotted black;
    font-variant: small-caps;
    font-size: 20pt;
    margin: 15px -16px;
  }
/* marking external links
  a[rel="external"], a.external {
    white-space: nowrap;
    padding-right: 10px;
    background: url('/img/link.png') no-repeat 100% 50%;
    zoom: 1;
  }
*/
