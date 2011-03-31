/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * {1 Server definition, URL dispatching}
**/

twopenny_page((title, body))(_conn_id) =
  Resource.html(title, body)

resources = @static_include_directory("img")

urls : Parser.general_parser(connexion_id -> resource) =
  parser
  | "/favicon." .* -> _conn_id ->
      @static_resource("./img/favicon.png")
  | result={Server.resource_map(resources)} -> _conn_id ->
      result
  | "/user/" user=(.*) ->
      Text.to_string(user)
      |> User.mk_ref(_)
      |> Pages.user_page(_)
      |> twopenny_page(_)
  | "/label/" label=(.*) ->
      Text.to_string(label)
      |> Label.mk_ref(_)
      |> Pages.label_page(_)
      |> twopenny_page(_)
  | .* ->
      Pages.main_page()
      |> twopenny_page(_)

/**
 * The Twopenny server
 */
server = Server.make(urls)
