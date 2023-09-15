module Utilities.Range exposing (Range, mapFloatRange)


type alias Range =
    ( Float, Float )


mapFloatRange : Range -> Range -> Float -> Float
mapFloatRange ( in_min, in_max ) ( out_min, out_max ) value =
    out_min + ((value - in_min) / (in_max - in_min) * (out_max - out_min))
