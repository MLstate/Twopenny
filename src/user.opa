/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type User.ref = private(string)

User = {{

  mk_ref(user : string) : User.ref =
    @wrap(user)

}}
