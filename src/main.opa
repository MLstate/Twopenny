/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * {1 Server definition, URL dispatching}
**/

/**
 * The Twopenny server
 */
server =
  urls = parser
  | "/" -> Pages.main_page()
  | "/user/" user=(.*) ->
    Text.to_string(user)
    |> User.mk_ref(_)
    |> Pages.user_page(_)
  | "/label/" label=(.*) ->
    Text.to_string(label)
    |> Label.mk_ref(_)
    |> Pages.label_page(_)
  Server.simple_server(urls)
