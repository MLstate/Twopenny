/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type Label.ref = private(string)

Label = {{

  mk_ref(label : string) : Label.ref =
    @wrap(label)

  to_anchor(label : Label.ref) : xhtml =
    <A href="/label/{@unwrap(label)}">#{label}</>

}}
