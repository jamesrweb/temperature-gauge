module Models.TemperatureSettings exposing (Temperature, TemperatureConfig, TemperatureSettings, fromValues, toValues)


type alias Temperature =
    Float


type alias TemperatureConfig =
    { min : Temperature, current : Temperature, max : Temperature }


type TemperatureSettings
    = TemperatureSettings
        { min : Temperature
        , current : Temperature
        , max : Temperature
        }


fromValues : TemperatureConfig -> TemperatureSettings
fromValues =
    TemperatureSettings


toValues : TemperatureSettings -> TemperatureConfig
toValues (TemperatureSettings config) =
    config
