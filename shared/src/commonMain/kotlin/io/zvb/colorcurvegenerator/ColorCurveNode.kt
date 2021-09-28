package io.zvb.colorcurvegenerator

/**
 *
 * An HSBA value that can be converted into platform specific colors.
 * Each parameter is a `Double` between 0.0 and 1.0.
 *
 */
data class ColorCurveNode(val hue: Double, val saturation: Double, val brightness: Double, val alpha: Double)