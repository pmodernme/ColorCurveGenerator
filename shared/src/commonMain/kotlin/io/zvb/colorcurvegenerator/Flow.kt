package io.zvb.colorcurvegenerator

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

//fun <T> Flow<T>.collect(onEach: (T) -> Unit, onCompletion: (cause: Throwable?) -> Unit): Cancellable {
//    val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
//
//    scope.launch {
//        try {
//            collect {
//                onEach(it)
//            }
//
//            onCompletion(null)
//        } catch (e: Throwable) {
//            onCompletion(e)
//        }
//    }
//
//    return object : Cancellable {
//        override fun cancel() {
//            scope.cancel()
//        }
//    }
//}
//
//interface Cancellable {
//    fun cancel()
//}

class KotlinNativeFlowWrapper<T>(private val flow: Flow<T>) {
    fun subscribe(
        scope: CoroutineScope,
        onEach: (item: T) -> Unit,
        onComplete: () -> Unit,
        onThrow: (error: Throwable) -> Unit
    ) = flow
        .onEach { onEach(it) }
        .catch { onThrow(it) }
        .onCompletion { onComplete() }
        .launchIn(scope)
}