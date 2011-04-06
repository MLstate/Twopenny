/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/** Users in the system **/
db /users : stringmap(User.t)
db /users[_]/photo full

/** Messages posted by users **/
 // msg_ref -> msg
db /msgs : Msg.map(Msg.t)

/** Messages posted by users **/
 // user -> date -> msg_ref
db /user_msg : User.map(Date.map(Msg.ref))

/** References to messages mentioning given users **/
 // user -> date -> msg_ref
db /user_mentions : User.map(Date.map(Msg.ref))

@both_implem Data = {{

  new_message(msg) =
    debug("New message: {msg}")

  new_user_mention(user, msg) =
    debug("New user mention: '{user}' in '{msg}'")

  new_label_msg(label, msg) =
    debug("New label occurrence: '{label}' -> '{msg}'")


}}
