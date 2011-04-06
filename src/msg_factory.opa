/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * @private
**/
type MsgFactory.msg_listener = channel(
  { newmsg : Msg.t }
)

MsgFactory = {{

  @private on_subscription(listeners, msg) =
    match msg with
    | { NewListener=listener } ->
      {set = [listener | listeners]}
    | { NewMessage=newmsg } ->
      do Debug.jlog("Notifying {List.length(listeners)} clients about a new message")
      notify(listener) = Session.send(listener, ~{newmsg})
      do List.iter(notify, listeners)
      {unchanged}

  @private @server subscribers =
    Session.make([] : list(MsgFactory.msg_listener), on_subscription)

  @server submit(msg : Msg.t) =
    do Data.new_message(msg)
    index =
    | ~{user} -> Data.new_user_mention(user, msg)
    | ~{label} -> Data.new_label_msg(label, msg)
    | {url=_}
    | {text=_} -> void
    do List.iter(index, Msg.parse(msg))
    do Session.send(subscribers, {NewMessage=msg})
    void

  subscribe_to_all(listener : MsgFactory.msg_listener) : void =
    do Session.send(subscribers, {NewListener=listener})
    void

}}
