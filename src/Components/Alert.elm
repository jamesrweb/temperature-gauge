module Components.Alert exposing (view)

import Html exposing (Html)
import Html.Attributes


view : String -> Html msg
view text =
    Html.article
        [ Html.Attributes.style "background-color" "#ffffcc"
        , Html.Attributes.style "color" "black"
        , Html.Attributes.style "padding" "0.5rem 1rem"
        , Html.Attributes.attribute "role" "alert"
        ]
        [ Html.p [ Html.Attributes.style "margin" "0" ]
            [ Html.text ("⚠️:" ++ text)
            ]
        ]
