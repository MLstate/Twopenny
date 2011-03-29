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
  | "/user/" user=(.*) -> Pages.user_page(user)
  | "/label/" label=(.*) -> Pages.label_page(label)
  Server.simple_server(urls)
