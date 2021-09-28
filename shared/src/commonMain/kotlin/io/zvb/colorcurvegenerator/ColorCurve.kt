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
                    n.copy(h = ColorCurveNode.hueUpperBound + n.h)
                } else {
                    ColorCurveNode(0.0, 1.0, 1.0, 1.0)
                }

            if (hue > nextPoint.h) {
                continue
            }

            // Find the proportion of the hue (where the hue is between points)
            val pH = hue.minus(node.h).div(nextPoint.h.minus(node.h))

            //
            val rS = pH.times(nextPoint.s - node.s).plus(node.s)
            val rB = pH.times(nextPoint.b - node.b).plus(node.b)
            val rA = pH.times(nextPoint.a - node.a).plus(node.a)

            result = ColorCurveNode(hue, rS, rB, rA)
            break
        }

        return result
    }
}