/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * {1 Server definition, URL dispatching}
**/

twopenny_page((title, body))(_conn) =
  Resource.full_page(title, body,
    <link rel="icon" type="image/png" href="./img/favicon.png" />,
    {success}, [])

urls : Parser.general_parser(connexion_id -> resource) =
  parser
  | "user/" user=(.*) ->
      Text.to_string(user)
      |> User.mk_ref(_)
      |> Pages.user_page(_)
      |> twopenny_page(_)
  | "label/" label=(.*) ->
      Text.to_string(label)
      |> Label.mk_ref(_)
      |> Pages.label_page(_)
      |> twopenny_page(_)
  | .* ->
      Pages.main_page()
      |> twopenny_page(_)

resources = @static_include_directory("img")

/**
 * The Twopenny server
 */
server = Server.make(Resource.add_auto_server(resources, urls))
