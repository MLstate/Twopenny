/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * {1 Server definition, URL dispatching}
**/

twopenny_page((title, content, style))(_req) =
  toolbar = Toolbar.html()
  page =
    <div id=#page>
      <div id=#main>
        {content}
      </>
    </>
    |> apply_css(style, _)
  body = <>{toolbar}{page}</>
  Resource.html(title, body)

resources = @static_include_directory("img")

urls : Parser.general_parser(http_request -> resource) =
  parser
  | {Rule.debug_parse_string(s -> jlog("URL: {s}"))} Rule.fail -> error("")
  | "/favicon." .* -> _req ->
      @static_resource("./img/favicon.png")
  | result={Server.resource_map(resources)} -> _req ->
      result
  | "/img/user-photo/" user=(.*) -> _req ->
      Text.to_string(user)
      |> User.mk_ref(_)
      |> User.get_user_photo_resource(_)
  | "/img/user-bg/" user=(.*) -> _req ->
      Text.to_string(user)
      |> User.mk_ref(_)
      |> User.get_user_wallpaper_resource(_)
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
