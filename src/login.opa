/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.loginbox
import components.login

type Login.credentials = option((string, string))

type Login.state = option(User.ref)

type Login.config = CLogin.config(Login.credentials, Login.state, Login.state)

type Login.component = CLogin.t(Login.credentials, Login.state, Login.state)

Login =

   dom_id = "login"

{{

  @private guest_state : Login.state =
    none

  @publish @server authenticate(cred : Login.credentials, state : Login.state)
    : option(Login.state) =
    do Log.debug("[LOGIN]", "authentication: [{cred}]")
    match cred with
    | {none} -> none
    | {some=(login, passwd)} ->
        user_ref = User.mk_ref(login)
        match User.get(user_ref) with
        | {none} -> none
        | {some=user} ->
           passwd = User.mk_passwd(passwd)
           if passwd == user.passwd then
             some(some(user_ref))
           else
             none

  @private login_conf : Login.config =
    CLogin.default_config(dom_id, authenticate)

  login : Login.component =
    CLogin.make(guest_state, login_conf)

  html() : xhtml =
    CLogin.html(login)

}}
