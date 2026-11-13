package com.example.testejuerpg.offline

/** Small typed records used by the existing offline Aetheria prototype. */
data class OfflineDailyGoal(
    val id: String,
    val title: String,
    val description: String,
    val required: Int,
    val rewardEnergy: Int
)

data class OfflineEventDefinition(
    val id: String,
    val name: String,
    val durationSeconds: Int,
    val modifier: String,
    val rewardMultiplier: Float
)

data class OfflineQuest(
    val id: String,
    val title: String,
    val description: String,
    val type: String,
    val target: String,
    val required: Int,
    val rewardEnergy: Int,
    val rewardGold: Int
)

object OfflineGameConstants {
    const val MAX_STYLES = 12
    const val EXPEDITION_TIME_SECONDS = 900
    const val RIFT_TIME_SECONDS = 420
}
