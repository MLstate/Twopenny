/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

MsgFactory = {{

  submit(user : User.ref)(content : string) =
    msg = Msg.create(content)
    do Data.new_message(user, msg)
    index =
    | ~{user} -> Data.new_user_mention(user, msg)
    | ~{label} -> Data.new_label_msg(label, msg)
    | {url=_}
    | {text=_} -> void
    do List.iter(index, Msg.parse(msg))
    void

}}
