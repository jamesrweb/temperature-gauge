module Main exposing (main)

import Browser
import Components.TemperatureGuage
import Html exposing (Html)
import Html.Attributes
import Models.TemperatureSettings exposing (TemperatureSettings)



-- Main


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- Model


type alias Model =
    { temperatureSettings : TemperatureSettings
    }


init : Model
init =
    { temperatureSettings =
        Models.TemperatureSettings.fromValues
            { min = 0
            , current = 40
            , max = 100
            }
    }



-- Update


type alias Msg =
    ()


update : Msg -> Model -> Model
update _ model =
    model



-- View


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.style "font-family" "sans-serif"
        , Html.Attributes.style "margin" "0 auto"
        , Html.Attributes.style "max-width" "50rem"
        ]
        [ Components.TemperatureGuage.view model.temperatureSettings
        ]
