/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import widgets.{loginbox, switch}
import components.login

type Login.credentials = option((string, string))

type Login.state = option(User.ref)

type Login.config = CLogin.config(Login.credentials, Login.state, Login.state)

type Login.component = CLogin.t(Login.credentials, Login.state, Login.state)

Login =

   dom_id = "login"

   sign_in_switch_id = "{dom_id}_sis"
   login_box_id = "{dom_id}_lb"

{{

  @private guest_state : Login.state =
    none

  @publish @server authenticate(cred : Login.credentials, state : Login.state)
    : option(Login.state) =
    do Log.debug("[LOGIN]", "authentication: [{cred}]")
    match cred with
    | {none} -> none
    | {some=(login, passwd)} ->
        do jlog("Authenticating with [{login}, {passwd}]")
        user_ref = User.mk_ref(login)
        res =
        match User.get(user_ref) with
        | {none} -> none
        | {some=user} ->
           passwd = User.mk_passwd(passwd)
           if passwd == user.passwd then
             some(some(user_ref))
           else
             none
        do jlog("Authenticating result: {res}")
        res

  @private login_conf : Login.config =
    CLogin.default_config(Random.string(8), authenticate)

  login : Login.component =
    CLogin.make(guest_state, login_conf)

  login_box() =
    <span id=#{login_box_id} class=loginbox>
      {CLogin.html(login)}
    </>

  @client login_switch_btn(on, action) =
    btn_cfg = WButton.default_config
    btn_txt = "Sign in/up"
    actions = [({click}, action)]
    xhtml = WButton.html(btn_cfg, Random.string(8), actions, <>{btn_txt}</>)
    update_dom = if on then Dom.show else Dom.hide
    do update_dom(#{login_box_id})
    { update_xhtml=xhtml }

  login_switch() =
    cfg : WSwitch.config =
      {
        get_switch_on(_, action, _) = login_switch_btn(true, action)
        get_switch_off(_, action, _) = login_switch_btn(false, action)
      }
    WSwitch.edit(cfg, sign_in_switch_id, (_ -> void), false)

  html() : xhtml =
    <>
      {login_switch()}
      {login_box()}
    </>

}}

login_css = css
  td{}
  .loginbox {
    position: fixed;
    top: 34px;
    background: #666;
    padding: 12px;
    border-radius: 8px;
    border: 1px dotted #CCC;
  }
