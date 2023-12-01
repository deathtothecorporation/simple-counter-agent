port module Main exposing (main)

import Browser
import Html exposing (Html, button, div, pre, text)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import String


type alias Model =
    { counter : Int
    , error : String
    }


type Msg
    = Connect
    | Disconnect
    | Increment
    | Decrement
    | UpdateCounter Int
    | HandleError String


type PokeType
    = Inc
    | Dec


pokeTypeEncoder : PokeType -> Encode.Value
pokeTypeEncoder pokeType =
    case pokeType of
        Inc ->
            Encode.object [ ( "inc", Encode.null ) ]

        Dec ->
            Encode.object [ ( "dec", Encode.null ) ]


type alias EventData =
    { counter : Int }


type alias Update =
    { update : EventData }


eventDataDecoder : Decoder EventData
eventDataDecoder =
    Decode.map EventData
        (Decode.field "counter" Decode.int)


updateDecoder : Decoder Update
updateDecoder =
    Decode.map Update
        (Decode.field "update" eventDataDecoder)


port sendPoke : String -> Cmd msg


port receiveEvent : (String -> msg) -> Sub msg


port connect : String -> Cmd msg


port subscriptionFailed : (String -> msg) -> Sub msg


port disconnect : String -> Cmd msg


incrementCmd : Cmd Msg
incrementCmd =
    sendPoke (Encode.encode 0 (pokeTypeEncoder Inc))


decrementCmd : Cmd Msg
decrementCmd =
    sendPoke (Encode.encode 0 (pokeTypeEncoder Dec))



-- Update function to handle messages


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Connect ->
            ( model, connect "" )

        Disconnect ->
            ( model, disconnect "" )

        Increment ->
            ( model, incrementCmd )

        Decrement ->
            ( model, decrementCmd )

        UpdateCounter newCount ->
            ( { model | counter = newCount }, Cmd.none )

        HandleError errMsg ->
            ( { model | error = errMsg }, Cmd.none )



-- View function to render HTML


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Connect ] [ text "Connect" ]
        , button [ onClick Disconnect ] [ text "Disconnect" ]
        , pre [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "Up" ]
        , button [ onClick Decrement ] [ text "Down" ]
        , pre [] [ text model.error ]
        ]



-- Initialize the application


init : () -> ( Model, Cmd Msg )
init _ =
    ( { counter = 0, error = "" }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ receiveEvent (UpdateCounter << Maybe.withDefault 0 << String.toInt)
        , subscriptionFailed HandleError
        ]



-- Main entry point


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
