package io.zvb.colorcurvegenerator

interface ColorCurve {
    val nodes: List<ColorCurveNode>

    fun nodeForHue(hue: Double): ColorCurveNode {
        var result = ColorCurveNode(0.0, 1.0, 1.0, 1.0)

        for (idx in nodes.indices) {
            val node = nodes[idx]
            val nextPoint: ColorCurveNode = nodes.elementAtOrNull(idx + 1)
                ?: if (nodes.count() > 0) {
                    val n = nodes[0]
                    n.copy(hue = 1.0 + n.hue)
                } else {
                    ColorCurveNode(0.0, 1.0, 1.0, 1.0)
                }

            if (hue > nextPoint.hue) {
                continue
            }

            // Find the proportion of the hue (where the hue is between points)
            val pH = hue.minus(node.hue).div(nextPoint.hue.minus(node.hue))

            //
            val rS = pH.times(nextPoint.saturation - node.saturation).plus(node.saturation)
            val rB = pH.times(nextPoint.brightness - node.brightness).plus(node.brightness)
            val rA = pH.times(nextPoint.alpha - node.alpha).plus(node.alpha)

            result = ColorCurveNode(hue, rS, rB, rA)
            break
        }

        return result
    }
}