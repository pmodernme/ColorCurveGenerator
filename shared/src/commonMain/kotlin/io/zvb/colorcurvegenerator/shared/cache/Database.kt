package io.zvb.colorcurvegenerator.shared.cache

import com.squareup.sqldelight.ColumnAdapter
import io.zvb.colorcurvegenerator.ColorCurve
import io.zvb.colorcurvegenerator.ColorCurveNode
import io.zvb.colorcurvegenerator.NamedColorCurve

internal class Database(databaseDriverFactory: DatabaseDriverFactory) {
    private val database = CurveDatabase(
        databaseDriverFactory.createDriver(),
        curveAdapter = Curve.Adapter(
            nodesAdapter = listOfNodesAdapter
        )
    )
    private val dbQuery = database.curveDatabaseQueries

    internal fun clearDatabase() {
        dbQuery.removeAllCurves()
    }

    internal fun getAllCurves(): List<ColorCurve> {
        return  dbQuery.selectAllCurves(::mapCurve).executeAsList()
    }

    private fun mapCurve(
        id: Long,
        name: String,
        isDark: Boolean,
        nodes: List<ColorCurveNode>
    ): ColorCurve = NamedColorCurve(
        nodes = nodes,
        name = name,
        id = id,
        isDark = isDark
    )

    private val listOfNodesAdapter
        get() = object : ColumnAdapter<List<ColorCurveNode>, String> {
            override fun decode(databaseValue: String): List<ColorCurveNode> {
                if (databaseValue.isEmpty()) {
                    return emptyList()
                } else {
                    return databaseValue.split(",").map { nodeText ->
                        nodeText.split(":").map { it.toDoubleOrNull() ?: return emptyList() }
                    }.map { ColorCurveNode(it[0], it[1], it[2], it[3]) }
                }
            }

            override fun encode(value: List<ColorCurveNode>): String {
                return value.joinToString(",") { "${it.h}:${it.s}:${it.b}:${it.a}" }
            }
        }
}