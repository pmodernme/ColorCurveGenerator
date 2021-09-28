package io.zvb.colorcurvegenerator

/**
 *
 * An HSBA value that can be converted into platform specific colors.
 * @param h hue in range `0..<360`
 * @param s saturation in range `0...1`
 * @param b brightness in range `0...1`
 * @param a alpha in range `0...1`
 */
data class ColorCurveNode(val h: Double, val s: Double, val b: Double, val a: Double) {
    companion object {
        val hueUpperBound = 360.0
    }
}