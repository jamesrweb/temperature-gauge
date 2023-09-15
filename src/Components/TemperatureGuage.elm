module Components.TemperatureGuage exposing (view)

import Aviary.Birds
import Components.Alert
import Html exposing (Html)
import Models.TemperatureSettings exposing (Temperature, TemperatureSettings)
import Svg
import Svg.Attributes
import Utilities.Range exposing (mapFloatRange)
import Utilities.View


type TemperatureGaugeSettings
    = TemperatureGaugeSettings
        { temperatureSettings : TemperatureSettings
        , centerX : Float
        , centerY : Float
        , radius : Int
        }


view : TemperatureSettings -> Html msg
view temperatureSettings =
    let
        { min, current, max } =
            Models.TemperatureSettings.toValues temperatureSettings

        viewBoxWidth : Int
        viewBoxWidth =
            300

        viewBoxHeight : Int
        viewBoxHeight =
            150

        viewBox : String
        viewBox =
            [ 0, 0, viewBoxWidth, viewBoxHeight ]
                |> List.map String.fromInt
                |> String.join " "

        temperatureGaugeSettings : TemperatureGaugeSettings
        temperatureGaugeSettings =
            TemperatureGaugeSettings
                { temperatureSettings = temperatureSettings
                , centerX = toFloat viewBoxWidth / 2
                , centerY = toFloat viewBoxHeight / 2
                , radius = viewBoxHeight // 4
                }
    in
    Html.div []
        [ Svg.svg
            [ Svg.Attributes.viewBox viewBox
            , Svg.Attributes.preserveAspectRatio "none"
            , Svg.Attributes.fontSize "0.5rem"
            ]
            [ temperatureGauge temperatureGaugeSettings
            , minimumTemperature temperatureGaugeSettings min
            , currentTemperature temperatureGaugeSettings (clamp min max current)
            , maximumTemperature temperatureGaugeSettings max
            ]
        , Utilities.View.if_ (current > max) (Components.Alert.view "The temperature cannot be higher than the maximum, capping at the maximum.")
        , Utilities.View.if_ (current < min) (Components.Alert.view "The temperature cannot be lower than the minimum, capping at the minimum.")
        ]


temperatureGauge : TemperatureGaugeSettings -> Html msg
temperatureGauge (TemperatureGaugeSettings { temperatureSettings, centerX, centerY, radius }) =
    let
        { min, current, max } =
            Models.TemperatureSettings.toValues temperatureSettings

        delta : Float
        delta =
            mapFloatRange ( min, max ) ( 0, 360 ) (clamp min max current)

        theta : Float
        theta =
            mapFloatRange ( 0, 360 ) ( 135, 405 ) delta

        indicatorSettings : IndicatorPointerSettings
        indicatorSettings =
            { x1 = centerX
            , y1 = centerY
            , x2 = centerX + toFloat radius * cos (degrees theta)
            , y2 = centerY + toFloat radius * sin (degrees theta)
            }
    in
    Svg.g []
        [ indicatorPointer indicatorSettings
        , Svg.circle
            [ Svg.Attributes.cx <| String.fromFloat centerX
            , Svg.Attributes.cy <| String.fromFloat centerY
            , Svg.Attributes.r <| String.fromInt radius
            , Svg.Attributes.fill "none"
            , Svg.Attributes.stroke "#000"
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        ]


currentTemperature : TemperatureGaugeSettings -> Temperature -> Html msg
currentTemperature (TemperatureGaugeSettings { centerX, centerY, radius }) temperature =
    temperatureValueText
        { value = temperature
        , xPosition = centerX + toFloat radius * cos (degrees 90)
        , yPosition = centerY + toFloat radius * sin (degrees 90) + 30
        }


minimumTemperature : TemperatureGaugeSettings -> Temperature -> Html msg
minimumTemperature (TemperatureGaugeSettings { centerX, centerY, radius }) temperature =
    let
        xPosition : Float
        xPosition =
            centerX + toFloat radius * cos (degrees 135)

        yPosition : Float
        yPosition =
            centerY + toFloat radius * sin (degrees 135)

        indicatorSettings : IndicatorPointerSettings
        indicatorSettings =
            { x1 = xPosition
            , y1 = yPosition
            , x2 = xPosition - 10
            , y2 = yPosition + 15
            }
    in
    Svg.g []
        [ indicatorPointer indicatorSettings
        , temperatureValueText
            { value = temperature
            , xPosition = xPosition - 10
            , yPosition = yPosition + 25
            }
        ]


maximumTemperature : TemperatureGaugeSettings -> Temperature -> Html msg
maximumTemperature (TemperatureGaugeSettings { centerX, centerY, radius }) temperature =
    let
        xPosition : Float
        xPosition =
            centerX + toFloat radius * cos (degrees 45)

        yPosition : Float
        yPosition =
            centerY + toFloat radius * sin (degrees 45)

        indicatorSettings : IndicatorPointerSettings
        indicatorSettings =
            { x1 = xPosition
            , y1 = yPosition
            , x2 = xPosition + 10
            , y2 = yPosition + 15
            }
    in
    Svg.g []
        [ indicatorPointer indicatorSettings
        , temperatureValueText
            { value = temperature
            , xPosition = xPosition + 10
            , yPosition = yPosition + 25
            }
        ]


temperatureValueText : { value : Temperature, xPosition : Float, yPosition : Float } -> Html msg
temperatureValueText { value, xPosition, yPosition } =
    Svg.text_
        [ Svg.Attributes.x <| String.fromFloat xPosition
        , Svg.Attributes.y <| String.fromFloat yPosition
        , Svg.Attributes.textAnchor "middle"
        , Svg.Attributes.dominantBaseline "middle"
        ]
        [ String.fromFloat value
            |> Aviary.Birds.cardinal (++) " °C"
            |> Svg.text
        ]


type alias IndicatorPointerSettings =
    { x1 : Float
    , y1 : Float
    , x2 : Float
    , y2 : Float
    }


indicatorPointer : IndicatorPointerSettings -> Html msg
indicatorPointer { x1, y1, x2, y2 } =
    Svg.line
        [ Svg.Attributes.x1 <| String.fromFloat x1
        , Svg.Attributes.y1 <| String.fromFloat y1
        , Svg.Attributes.x2 <| String.fromFloat x2
        , Svg.Attributes.y2 <| String.fromFloat y2
        , Svg.Attributes.stroke "black"
        , Svg.Attributes.strokeWidth "1"
        ]
        []
