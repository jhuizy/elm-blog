import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing (..)

import BlogPost as BP

type Route =
  Home
  | BlogPostList
  | BlogPost Int
 
routeParser : Parser (Route -> a) a
routeParser = 
  oneOf
    [ Url.Parser.map Home (Url.Parser.s "home") 
    , Url.Parser.map BlogPostList (Url.Parser.s "blogs")
    , Url.Parser.map BlogPost (Url.Parser.s "blogs" </> int)
    ]

-- MAIN

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

-- MODEL

type alias Model =
  { key : Nav.Key
  , route : Maybe Route
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key (Just Home), Cmd.none )

-- UPDATE

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | route = parse routeParser url }
      , Cmd.none
      )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- VIEW

routeView : Maybe Route -> Html Msg
routeView mayRoute = case mayRoute of
  Just route -> 
    case route of 
      Home -> div [] [ text "Home is where the heart is" ]
      BlogPostList -> div [] [ text "Listing all the blogs" ]
      BlogPost id -> div [] [ text <| "blog with id " ++ (String.fromInt id) ]
  Nothing ->
    div [] [ text "404" ]

view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [ text "The current URL is: "
      , navbar
      , routeView model.route
      , ul []
          [ viewLink "/home"
          , viewLink "/blogs"
          , viewLink "/blogs/1"
          ]
      ]
  }

navbar : Html Msg
navbar =
  div [ class "container" ] 
    [ div [ class "row" ] 
      [ div [ class "mx-auto text-center header-text"] [ text "My Blog" ] 
      ] 
    ]
  

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]

