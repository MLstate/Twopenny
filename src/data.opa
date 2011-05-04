/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/** Users in the system */
db /users : stringmap(User.t)
db /users[_]/photo full
db /users[_]/wallpaper full

/** Messages posted by the users */
 // msg_ref -> msg
db /msgs : Msg.map(Msg.t)

/** Messages posted by users */
 // user -> date -> msg_ref
db /user_msg : User.map(Date.map(Msg.ref))

/** References to messages mentioning given users */
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

init_data_store() =
  match ?/users["mlstate"] with
  | {none} ->
      mlstate : User.t =
        { name       = "OPA by MLstate"
        ; location   = "Paris, France"
        ; motto      = "MLstate, creators of the OPA platform for web-development"
        ; email      = Email.of_string("contact@mlstate.com")
        ; url        = "http://mlstate.com"
        ; photo      = some({png = @static_binary_content("img/mlstate.png")})
        ; passwd     = ""
        ; wallpaper  =
            { img = some({png = @static_binary_content("img/mlstate-bg.png")})
            ; tile = false
            ; color = Color.of_string("#155B9C")
            }
        }
      /users["mlstate"] <- mlstate
  | _ ->
    void

_ = init_data_store()
