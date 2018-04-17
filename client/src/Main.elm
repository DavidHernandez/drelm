module Main exposing (main)

import Dict exposing (Dict)
import Html exposing (Html, div, text, beginnerProgram)
import Html.Events exposing (onClick)
import List


type alias Model =
    { posts : Dict PostId Post
    , activePage : Page
    }


type Page
    = BlogList
    | Blog PostId


type alias PostId =
    Int


type alias Post =
    String


model : Model
model =
    { posts = Dict.fromList [ ( 1, "First blog" ), ( 2, "Second blog" ) ]
    , activePage = BlogList
    }


type Msg
    = NavigateTo Page


update : Msg -> Model -> Model
update msg model =
    case msg of
        NavigateTo page ->
            { model | activePage = page }


view : Model -> Html Msg
view model =
    case model.activePage of
        BlogList ->
            viewBlogList model.posts

        Blog postId ->
            let
                post =
                    Dict.get postId model.posts
            in
                case post of
                    Just aPost ->
                        div
                            [ onClick <| NavigateTo BlogList ]
                            [ text aPost ]

                    Nothing ->
                        div
                            [ onClick <| NavigateTo BlogList ]
                            [ text "Blog post not found" ]


viewBlogList : Dict PostId Post -> Html Msg
viewBlogList posts =
    div
        []
        (Dict.map viewPost model.posts |> Dict.values)


viewPost : PostId -> Post -> Html Msg
viewPost postId post =
    div
        [ onClick <| NavigateTo <| Blog postId ]
        [ text post ]


main : Program Never Model Msg
main =
    beginnerProgram
        { model = model
        , view = view
        , update = update
        }
