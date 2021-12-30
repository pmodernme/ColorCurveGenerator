package io.zvb.colorcurvegenerator

interface ColorCurve {
    var nodes: List<ColorCurveNode>

    fun nodeForHue(hue: Double): ColorCurveNode = when(nodes.count()) {
        0 -> ColorCurveNode(hue, 1.0, 1.0)
        1 -> nodes[0].copy(h = hue)
        else -> {
            val nodes: Pair<ColorCurveNode, ColorCurveNode> = nodes.indexOfLast {
                it.h < hue
            }.let {
                when {
                    it >= 0 && nodes.count() > it + 1 -> Pair(nodes[it], nodes[it + 1])
                    it >= 0 -> {
                        val first = nodes.last()
                        val last = nodes.first().run { copy(h = h + ColorCurveNode.hueUpperBound) }
                        Pair(first, last)
                    }
                    else -> {
                        val first = nodes.last().run { copy(h = h - ColorCurveNode.hueUpperBound) }
                        val last = nodes.first()
                        Pair(first, last)
                    }
                }
            }
            lerpNodes(hue, nodes.first, nodes.second)
        }
    }

    private fun lerpNodes(
        hue: Double,
        first: ColorCurveNode,
        second: ColorCurveNode,
    ): ColorCurveNode {
        val pH = hue.minus(first.h).div(second.h.minus(first.h))

        val rS = pH.times(second.s - first.s).plus(first.s)
        val rB = pH.times(second.b - first.b).plus(first.b)
        val rA = pH.times(second.a - first.a).plus(first.a)

        return ColorCurveNode(hue, rS, rB, rA)
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
