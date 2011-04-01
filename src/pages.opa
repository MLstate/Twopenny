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
        <h1>User: {@unwrap(user)}</>
        {submission}
        <div id=#msgs onready={setup_msg_updates} />
      </>
    ("Twopenny :: {user}", content)

  label_page(label) =
    ("Twopenny :: {label}", unimplemented)

}}
