/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

Data = {{

  new_message(msg) =
    debug("New message: {msg}")

  new_user_mention(user, msg) =
    debug("New user mention: '{user}' in '{msg}'")

  new_label_msg(label, msg) =
    debug("New label occurrence: '{label}' -> '{msg}'")


}}
