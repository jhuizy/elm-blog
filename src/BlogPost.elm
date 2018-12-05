module BlogPost exposing (BlogPost, viewBlogPost)

import Html exposing (..)

type alias BlogPost =
  { title : String 
  , body : String
  }

viewBlogPost : BlogPost -> Html a
viewBlogPost blog =
  div [] 
    [ h1 [] [ text blog.title ]
    , text blog.body
    ]
