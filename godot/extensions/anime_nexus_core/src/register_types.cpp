#include "register_types.h"

#include "anime_nexus_combat_core.h"
#include "anime_nexus_quest_core.h"

void initialize_anime_nexus_module(ModuleInitializationLevel level) {
    if (level == MODULE_INITIALIZATION_LEVEL_SCENE) {
        ClassDB::register_class<AnimeNexusCombatCore>();
        ClassDB::register_class<AnimeNexusQuestCore>();
    }
}

void uninitialize_anime_nexus_module(ModuleInitializationLevel level) {
    (void) level;
}
