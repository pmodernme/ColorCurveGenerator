package io.zvb.colorcurvegenerator

interface ColorCurve {
    var nodes: List<ColorCurveNode>

    fun nodeForHue(hue: Double): ColorCurveNode {
        var result = ColorCurveNode(hue, 1.0, 1.0, 1.0)

        for (idx in nodes.indices) {
            var idx = idx
            var node = nodes[idx]
            if (idx == 0 && hue < node.h) {
                node = nodes.lastOrNull()?.let { it.copy(h = it.h - ColorCurveNode.hueUpperBound) }
                    ?: ColorCurveNode(hue, 1.0, 1.0, 1.0)
                idx -= 1
            }
            val nextPoint: ColorCurveNode = nodes.elementAtOrNull(idx + 1)
                ?: nodes.elementAtOrNull(0)?.let { it.copy(h = it.h + ColorCurveNode.hueUpperBound) }
                ?: ColorCurveNode(hue, 1.0, 1.0, 1.0)

            if (hue > nextPoint.h) {
                continue
            }

            // Find the proportion of the hue (where the hue is between points)
            val pH = hue.minus(node.h).div(nextPoint.h.minus(node.h))

            val rS = pH.times(nextPoint.s - node.s).plus(node.s)
            val rB = pH.times(nextPoint.b - node.b).plus(node.b)
            val rA = pH.times(nextPoint.a - node.a).plus(node.a)

            result = ColorCurveNode(hue, rS, rB, rA)
            break
        }

        return result
    }

    fun asSpectrum(): List<ColorCurveNode> =
        (0 until ColorCurveNode.spectrumSteps).map {
            val hue = ColorCurveNode.hueUpperBound.times(it.toDouble()/ColorCurveNode.spectrumSteps)
            nodeForHue(hue)
        }
}

class BasicColorCurve(override var nodes: List<ColorCurveNode>) : ColorCurve

data class NamedColorCurve(
    override var nodes: List<ColorCurveNode>,
    val name: String,
    val id: Long?,
    val isDark: Boolean
) : ColorCurve {
    constructor(
        name: String,
        isDark: Boolean,
        curve: ColorCurve,
        id: Long?
    ): this(nodes = curve.nodes, name = name, id = id, isDark = isDark)
}
