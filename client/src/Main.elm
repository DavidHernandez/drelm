module Main exposing (main)

import Dict exposing (Dict)
import Html exposing (Html, a, div, h2, text, beginnerProgram)
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
    { id : PostId
    , title : String
    , body : String
    , created : String
    }


model : Model
model =
    { posts = Dict.fromList [ ( 1, firstPost ), ( 2, secondPost ) ]
    , activePage = BlogList
    }


firstPost : Post
firstPost =
    { id = 1
    , title = "First blog"
    , body = "This is the body of the first blog post"
    , created = "2018-04-18 19:00"
    }


secondPost : Post
secondPost =
    { id = 2
    , title = "Second blog"
    , body = "This is the body of the another blog post"
    , created = "2018-05-18 20:00"
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
                            []
                            [ h2 [] [ text aPost.title ]
                            , div [] [ text aPost.created ]
                            , div [] [ text aPost.body ]
                            , a [ onClick <| NavigateTo BlogList ] [ text "Go back" ]
                            ]

                    Nothing ->
                        div
                            [ onClick <| NavigateTo BlogList ]
                            [ text "Blog post not found" ]


viewBlogList : Dict PostId Post -> Html Msg
viewBlogList posts =
    div
        []
        (Dict.map viewPostTeaser model.posts |> Dict.values)


viewPostTeaser : PostId -> Post -> Html Msg
viewPostTeaser postId post =
    div
        [ onClick <| NavigateTo <| Blog postId ]
        [ text post.title ]


main : Program Never Model Msg
main =
    beginnerProgram
        { model = model
        , view = view
        , update = update
        }
