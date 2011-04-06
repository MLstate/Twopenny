/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type User.photo =
  { small : image
  ; full : image
  }

type User.t =
    /** Name of the user (this is not the login) **/
  { name : string
    /** A short self-presentation of the user **/
  ; motto : string
   /* FIXME actually I want [Url.url] not [string] below but I don't know
            how to store that in DB.
      This data query is ambiguous (it may match several cases in a sum type):
      /users[_]/url/query
    */
    /** User-provided URL (for instance to his homepage, visible in the profile) **/
  ; url : string
    /** User's email **/
  ; email : Email.email
    /** User's password (actually an MD5 hash of the password) **/
  ; passwd : string
    /** User's photo **/
  ; photo : option(User.photo)
  }

type User.ref = private(string)

type User.map('a) = ordered_map(User.ref, 'a, String.order)

User = {{

  mk_ref(user : string) : User.ref =
    @wrap(user)

  to_anchor(user_ref : User.ref) : xhtml =
    user = @unwrap(user_ref)
    <a href="/user/{user}">@{user}</>

  to_string(user_ref : User.ref) : string =
    @unwrap(user_ref)

  show_photo(~{size_px}, user_ref : User.ref) : xhtml =
    size_css = css
      { max-width: {size_px}px
      ; max-height: {size_px}px
      }
    <img class="image" src="/img/user.png" />
      |> apply_css(size_css, _)

}}
