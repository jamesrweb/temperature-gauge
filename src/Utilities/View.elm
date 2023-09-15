module Utilities.View exposing (if_)

import Html exposing (Html)


if_ : Bool -> Html msg -> Html msg
if_ condition view =
    if condition then
        view

    else
        Html.text ""
