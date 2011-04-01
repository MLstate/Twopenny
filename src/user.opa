/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type User.ref = private(string)

User = {{

  mk_ref(user : string) : User.ref =
    @wrap(user)

  to_anchor(user_ref : User.ref) : xhtml =
    user = @unwrap(user_ref)
    <a href="/user/{user}">@{user}</>

  to_string(user_ref : User.ref) : string =
    @unwrap(user_ref)

}}
