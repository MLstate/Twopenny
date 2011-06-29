/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

@abstract
type Label.ref = string

Label = {{

  mk_ref(label : string) : Label.ref =
    label

  to_anchor(label_ref : Label.ref) : xhtml =
    label = label_ref
    <a href="/label/{label}">#{label}</>

  to_string(label: Label.ref) : string =
    label

}}
