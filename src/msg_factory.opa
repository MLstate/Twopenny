/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * @private
**/
type MsgFactory.msg_subscription = channel(
  { newmsg : Msg.t }
)

MsgFactory = {{

  @private on_subscription(callbacks, msg) =
    match msg with
    | { SubscribeToAll=callback } ->
      {set = [callback | callbacks]}
    | { NewMessage=newmsg } ->
       /* REMARK Type annotation below needed to avoid value
          restriction error */
      notify(callback) = callback(newmsg : Msg.t)
      do List.iter(notify, callbacks)
      {unchanged}

  @private @server subscribers =
    Session.make([], on_subscription)

  submit(msg : Msg.t) =
    do Data.new_message(msg)
    index =
    | ~{user} -> Data.new_user_mention(user, msg)
    | ~{label} -> Data.new_label_msg(label, msg)
    | {url=_}
    | {text=_} -> void
    do List.iter(index, Msg.parse(msg))
    do Session.send(subscribers, {NewMessage=msg})
    void

  subscribe_to_all(callback : Msg.t -> void) : void =
    do Session.send(subscribers, {SubscribeToAll=callback})
    void

}}
