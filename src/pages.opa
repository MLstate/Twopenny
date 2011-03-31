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
    html("Twopenny", unimplemented)

  user_page(user : User.ref) =
    submission = WMsgBox.html("msgbox", Msg.create(user, _), MsgFactory.submit)
    show_new_msg(msg) =
      exec([#msgs +<- Msg.render(msg)])
    content =
      <>
        <h1>User: {@unwrap(user)}</>
        {submission}
        <div id=#msgs />
      </>
    do MsgFactory.subscribe_to_all(show_new_msg)
    html("Twopenny :: {user}", content)

  label_page(label) =
    html("Twopenny :: {label}", unimplemented)

}}
