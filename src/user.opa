/*
 * Twopenny. (C) MLstate - 2011
 * @author Adam Koprowski
**/

package mlstate.twopenny

type User.wallpaper =
  { img : option(image)
  ; tile : bool
  ; color : option(color)
  }

@abstract type passwd = string

type User.t =
    /** Name of the user (this is not the login) **/
  { name : string
    /** User's location **/
  ; location : string
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
  ; passwd : passwd
    /** User's profile photo **/
  ; photo : option(image)
    /** User's wallpaper **/
  ; wallpaper : User.wallpaper
  }

type User.ref = private(string)

type User.map('a) = ordered_map(User.ref, 'a, String.order)

User =

  default_user_photo : image =
    {png = @static_binary_content("img/user.png")}

  default_user_wallpaper_img : image =
    {png = @static_binary_content("img/default_bg.png")}

  default_user_wallpaper : User.wallpaper =
    { img = some(default_user_wallpaper_img)
    ; tile = false
    ; color = Color.of_string("#155B9C")
    }

  max_profile_photo_size =
    { max_height_px = 80 max_width_px = 80 }

  max_thumb_photo_size =
    { max_height_px = 50 max_width_px = 50 }

  get_user_photo_url(user_ref : User.ref) : string =
    "/img/user-photo/{@unwrap(user_ref)}"

{{

  mk_ref(user : string) : User.ref =
    @wrap(user)

  get(user_ref : User.ref) : option(User.t) =
    ?/users[@unwrap(user_ref)]

  @private get_user_optional_image(user_ref, get_photo, default_photo) =
    img =
      match get(user_ref) with
      | {none} -> default_photo
      | ~{some=user} ->
         match get_photo(user) with
         | {some=photo} -> photo
         | {none} -> default_photo
    Resource.image(img)

  get_user_photo_resource(user_ref : User.ref) : resource =
    get_user_optional_image(user_ref, (user -> user.photo), default_user_photo)

  get_user_wallpaper_resource(user_ref : User.ref) : resource =
    get_user_optional_image(user_ref, (user -> user.wallpaper.img), default_user_wallpaper_img)

  ref_to_anchor(user_ref : User.ref) : xhtml =
    user = @unwrap(user_ref)
    <a href="/user/{user}">@{user}</>

  ref_to_string(user_ref : User.ref) : string =
    @unwrap(user_ref)

  show_msg_photo(user_ref : User.ref) : xhtml =
    get_user_photo_url(user_ref)
    |> show_photo(max_thumb_photo_size, _)

  get_header(user_ref : User.ref, user : User.t) : xhtml =
    <div class="user_header">
      {show_photo(max_profile_photo_size, get_user_photo_url(user_ref))}
      {User.ref_to_string(user_ref)}
    </>

  get_wallpaper_css(user_ref : User.ref) : css_properties =
    wallpaper = Option.map((user -> user.wallpaper), get(user_ref)) ? default_user_wallpaper
    user_bg =
      { Css_build.no_background with
          url = some(Url.make("/img/user-bg/{user_ref}"))
          repeat = if wallpaper.tile then none else some({css_none})
          position = some({x = {left}; y = {size = {px = 30}}})
          color = wallpaper.color
          attached = some(void)
      }
    css {
      background: {user_bg}
    }

  mk_passwd(pass : string) : passwd =
    md5(pass)

}}

user_css = css
  td{} // FIXME problems with CSS parsing... remove when resolved
  .user_header .image {
    margin: -15px 0px;
  }
  .user_header {
    border-top: 1px dotted black;
    border-bottom: 1px dotted black;
    font-variant: small-caps;
    font-size: 20pt;
    height: 50px;
    margin: 30px -16px;
    background: #F8F8F8;
    padding: 0px 15px;
  }
