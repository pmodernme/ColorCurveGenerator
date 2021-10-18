package io.zvb.colorcurvegenerator.shared.cache

import com.squareup.sqldelight.ColumnAdapter
import com.squareup.sqldelight.runtime.coroutines.asFlow
import com.squareup.sqldelight.runtime.coroutines.mapToList
import io.zvb.colorcurvegenerator.ColorCurveNode
import io.zvb.colorcurvegenerator.KotlinNativeFlowWrapper
import io.zvb.colorcurvegenerator.NamedColorCurve
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.map
import kotlin.coroutines.CoroutineContext

class Database(databaseDriverFactory: DatabaseDriverFactory) {
    private val database = CurveDatabase(
        databaseDriverFactory.createDriver(),
        curveAdapter = Curve.Adapter(
            nodesAdapter = listOfNodesAdapter
        )
    )
    private val dbQuery = database.curveDatabaseQueries

    fun curves() = dbQuery.selectAllCurves().asFlow().mapToList().map { curves ->
        curves.map { mapCurve(it.id, it.name, it.isDark, it.nodes) }
    }

    val iosScope: CoroutineScope = object  : CoroutineScope {
        override val coroutineContext: CoroutineContext
            get() = SupervisorJob() + Dispatchers.Main
    }

    val iosPollCurves get() = KotlinNativeFlowWrapper(curves())

    fun getCurve(id: Long) = dbQuery.selectById(id, ::mapCurve).executeAsOne()

    private fun mapCurve(
        id: Long,
        name: String,
        isDark: Boolean,
        nodes: List<ColorCurveNode>
    ): NamedColorCurve = NamedColorCurve(
        id = id,
        name = name,
        isDark = isDark,
        nodes = nodes,
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