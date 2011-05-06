/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.loginbox
import components.login

type Login.credentials =
  { login : string
  ; passwd : string
  }

type Login.private_state =
  { user : option(User.ref)
  }

type Login.public_state = Login.private_state

type Login.config = CLogin.config(Login.credentials, Login.private_state,
                      Login.public_state)

type Login.component = CLogin.t(Login.credentials, Login.private_state,
                         Login.public_state)

Login =

   dom_id = "login"

{{

  @publish @server authenticate(cred : Login.credentials, state : Login.private_state)
    : option(Login.private_state) =
    do Log.debug("[LOGIN]", "authentication: [login:{cred.login}, passwd:{cred.passwd}]")
    user_ref = User.mk_ref(cred.login)
    match User.get(user_ref) with
    | {none} -> none
    | {some=user} ->
        passwd = User.mk_passwd(cred.passwd)
        if passwd == user.passwd then
          some({user = some(user_ref)})
        else
          none

  @private loginbox(onchange : Login.credentials -> void, state : Login.public_state)
    : xhtml =
    login_action(login, passwd) = onchange(~{login passwd})
    user_opt = Option.map((user_ref -> <>{User.ref_to_string(user_ref)}</>), state.user)
    WLoginbox.html(WLoginbox.default_config, dom_id, login_action, user_opt)

  @private login_conf : Login.config =
    { ~authenticate
    ; get_credential(state : Login.private_state) : Login.public_state  = state
    ; ~loginbox
    ; on_change(_, _) = void
    ; dbpath = none
    ; prelude = none
    }

  @private default_state : Login.private_state =
    { user = none }

  init() : Login.component =
    CLogin.make(default_state, login_conf)

  html(component : Login.component) : xhtml =
    CLogin.html(component)

}}
