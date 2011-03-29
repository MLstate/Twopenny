/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

/**
 * {1 HTML generation for Twopenny pages}
**/

Pages = {{

  unimplemented =
    <>
      Coming soon... stay tuned
    </>

  main_page() =
    html("Twopenny", unimplemented)

  user_page(user) =
    html("Twopenny :: {user}", unimplemented)

  label_page(label) =
    html("Twopenny :: {label}", unimplemented)

}}
