/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type Label.ref = private(string)

Label = {{

  mk_ref(label : string) : Label.ref =
    @wrap(label)

  to_anchor(label_ref : Label.ref) : xhtml =
    label = @unwrap(label_ref)
    <a href="/label/{label}">#{label}</>

}}
