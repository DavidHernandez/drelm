module Main exposing (main)

import Html exposing (Html, div, text)
import List


type alias Model =
    { posts : List Post
    , activePage : Page
    }


type Page
    = BlogList
    | Blog


type alias Post =
    String


type Msg
    = NoOp


model : Model
model =
    { posts = [ "First blog", "Second blog" ]
    , activePage = BlogList
    }


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    div
        []
        (List.map viewPost model.posts)


viewPost : Post -> Html Msg
viewPost post =
    div
        []
        [ text post ]


main =
    view model
