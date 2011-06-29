/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

import stdlib.widgets.{loginbox, switch}
import stdlib.components.login

type Toolbar.state = option(User.ref)

type Login.credentials = option((string, string))

type Login.config = CLogin.config(Login.credentials, Toolbar.state, Toolbar.state)

type Login.component = CLogin.t(Login.credentials, Toolbar.state, Toolbar.state)

Toolbar =

   dom_id = "login"

   sign_in_switch_id = "{dom_id}_sis"
   login_box_id = "{dom_id}_lb"

{{

  @private guest_state : Toolbar.state =
    none

  @publish @server authenticate(cred : Login.credentials, state : Toolbar.state)
    : option(Toolbar.state) =
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

  login_btn_cfg = WButton.default_config

  login : Login.component =
    CLogin.make(guest_state, login_conf)

  login_box() =
    btn_txt = "Register"
    onclick = ({click}, (_ -> void))
    signup = WButton.html(login_btn_cfg, Random.string(8), [onclick], <>{btn_txt}</>)
    <span id=#{login_box_id} class=loginbox>
      {CLogin.html(login)}
      <span class="signup">
        Don't have an account yet? {signup}
      </>
    </>

  @client login_switch_btn(on, action) =
    control = if on then "↑" else "↓"
    btn_txt = "Sign in/up {control}"
    onclick = ({click}, action)
    xhtml = WButton.html(login_btn_cfg, Random.string(8), [onclick], <>{btn_txt}</>)
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
    <div id=#toolbar_container>
      <div id=#toolbar>
        <div id=#signin>
          {login_switch()}
          {login_box()}
        </>
      </>
    </>

}}

toolbar_css = css
  td{}
  #toolbar_container {
    position: fixed;
    top: 0px;
    overflow: hidden;
    width: 100%;
    height: 30px;
    z-index: 9999;
    border: 1px dotted ;
    border-top: none;
    background: #666;
  }
  #toolbar {
    width: 600px;
    margin: auto;
  }
  #signin {
    float: right;
  }
  .loginbox {
    position: fixed;
    top: 30px;
    background: #666;
    border: 1px dotted black;
    border-top: none;
    padding: 12px;
    border-bottom-left-radius: 8px;
    border-bottom-right-radius: 8px;
  }
