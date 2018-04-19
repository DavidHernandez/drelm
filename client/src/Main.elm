module Main exposing (main)

import Html exposing (Html, a, div, h2, text, program)
import Http
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, decodeString, int, string, list)
import Json.Decode.Pipeline exposing (decode, required)
import List
import Task exposing (Task)


type alias Model =
    { posts : WebData String PostList
    , activePage : Page
    }


type WebData error data
    = NotAsked
    | Loading
    | Error error
    | Success data


type alias PostList =
    List Post


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
    { posts = NotAsked
    , activePage = BlogList
    }


init : ( Model, Cmd Msg )
init =
    ( model
    , fetchPosts
    )


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
    | FetchPosts (Result Http.Error PostList)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo page ->
            ( { model | activePage = page }, Cmd.none )

        FetchPosts (Ok posts) ->
            ( { model | posts = Success posts }, Cmd.none )

        FetchPosts (Err err) ->
            let
                _ =
                    Debug.log "Error" err
            in
                ( { model | posts = Error "error" }, Cmd.none )


view : Model -> Html Msg
view model =
    case model.posts of
        NotAsked ->
            div [] [ text "Loading..." ]

        Loading ->
            div [] [ text "Loading..." ]

        Success posts ->
            case model.activePage of
                BlogList ->
                    viewBlogList posts

                Blog postId ->
                    let
                        post =
                            List.head posts

                        -- List.filter by postId
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

        Error error ->
            div [] [ text error ]


viewBlogList : PostList -> Html Msg
viewBlogList posts =
    div
        []
        (List.map viewPostTeaser posts)


viewPostTeaser : Post -> Html Msg
viewPostTeaser post =
    div
        [ onClick <| NavigateTo <| Blog post.id ]
        [ text post.title ]


fetchPosts : Cmd Msg
fetchPosts =
    let
        url =
            "http://drelm.local/jsonapi/blog"
    in
        Http.send FetchPosts (httpGet url postListDecoder)


httpGet : String -> Decoder value -> Http.Request value
httpGet url decoder =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Access-Control-Allow-Origin" "*"
            , Http.header "Content-type" "application/vnd.api+json"
            , Http.header "Accept" "application/vnd.api+json"
            , Http.header "Origin" "http://drelm.local"
            , Http.header "Access-Control-Allow-Methods" "GET"
            , Http.header "Access-Control-Request-Headers" "X-Custom-Header"
            ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


postListDecoder : Decoder PostList
postListDecoder =
    Decode.at [ "data" ] (list postDecoder)


postDecoder : Decoder Post
postDecoder =
    Decode.at [ "attributes" ]
        (decode Post
            |> required "id" int
            |> required "title" string
            |> required "body" string
            |> required "created" string
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
