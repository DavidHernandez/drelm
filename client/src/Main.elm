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


model : Model
model =
    { posts = [ "First blog", "Second blog" ]
    , activePage = BlogList
    }


type Msg
    = NavigateTo Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo page ->
            ( { model | activePage = page }, Cmd.none )


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
