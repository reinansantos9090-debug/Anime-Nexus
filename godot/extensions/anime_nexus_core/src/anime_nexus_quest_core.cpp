#include "anime_nexus_quest_core.h"

#include <godot_cpp/core/class_db.hpp>

#include <algorithm>
#include <cstdint>

using namespace godot;

namespace {

Dictionary find_quest(const Array &definitions, const String &quest_id) {
    for (int64_t i = 0; i < definitions.size(); ++i) {
        const Variant value = definitions[i];
        if (value.get_type() != Variant::DICTIONARY) {
            continue;
        }
        const Dictionary definition = value;
        if (String(definition.get("id", "")) == quest_id) {
            return definition;
        }
    }
    return Dictionary();
}

bool contains_id(const Array &ids, const String &quest_id) {
    for (int64_t i = 0; i < ids.size(); ++i) {
        if (String(ids[i]) == quest_id) {
            return true;
        }
    }
    return false;
}

Dictionary normalized_state(const Dictionary &source) {
    Dictionary state = source.duplicate(true);
    if (!state.has("active") || state["active"].get_type() != Variant::ARRAY) {
        state["active"] = Array();
    }
    if (!state.has("completed") || state["completed"].get_type() != Variant::ARRAY) {
        state["completed"] = Array();
    }
    if (!state.has("progress") || state["progress"].get_type() != Variant::DICTIONARY) {
        state["progress"] = Dictionary();
    }
    return state;
}

} // namespace

void AnimeNexusQuestCore::_bind_methods() {
    ClassDB::bind_method(D_METHOD("start_quest", "quest_state", "definitions", "quest_id"),
            &AnimeNexusQuestCore::start_quest);
    ClassDB::bind_method(D_METHOD("apply_event", "quest_state", "definitions", "event_type", "subject_id", "amount"),
            &AnimeNexusQuestCore::apply_event, DEFVAL(1));
}

Dictionary AnimeNexusQuestCore::start_quest(const Dictionary &quest_state, const Array &definitions,
        const String &quest_id) const {
    Dictionary state = normalized_state(quest_state);
    const bool known = !find_quest(definitions, quest_id).is_empty();
    Array active = state["active"];
    const Array completed = state["completed"];
    bool started = false;
    if (known && !contains_id(active, quest_id) && !contains_id(completed, quest_id)) {
        active.append(quest_id);
        state["active"] = active;
        Dictionary progress = state["progress"];
        progress[quest_id] = 0;
        state["progress"] = progress;
        started = true;
    }

    Dictionary result;
    result["quests"] = state;
    result["started"] = started;
    return result;
}

Dictionary AnimeNexusQuestCore::apply_event(const Dictionary &quest_state, const Array &definitions,
        const String &event_type, const String &subject_id, int64_t amount) const {
    Dictionary state = normalized_state(quest_state);
    Array active = state["active"];
    const Array active_at_event_start = active.duplicate();
    Array completed = state["completed"];
    Dictionary progress = state["progress"];
    Dictionary item_rewards;
    Array completed_now;
    int64_t xp_reward = 0;
    const int64_t progress_amount = std::max<int64_t>(0, amount);
    bool changed = false;

    for (int64_t i = 0; i < active_at_event_start.size(); ++i) {
        const String quest_id = active_at_event_start[i];
        Dictionary quest = find_quest(definitions, quest_id);
        if (quest.is_empty()) {
            continue;
        }

        const String type = quest.get("type", "");
        bool matches = false;
        if (event_type == "direct") {
            matches = quest_id == subject_id;
        } else if (event_type == "complete") {
            matches = quest_id == subject_id;
        } else if (event_type == "kill") {
            matches = (type == "kill" && String(quest.get("monster", "")) == subject_id)
                    || (type == "map_kill")
                    || ((type == "boss" || type == "boss_any") && subject_id.begins_with("boss_"));
        } else if (event_type == "collect") {
            matches = type == "collect" && String(quest.get("item", "")) == subject_id;
        } else if (event_type == "map") {
            matches = type == "map" && String(quest.get("map", "")) == subject_id;
        } else if (event_type == "interact") {
            matches = type == "interact" && String(quest.get("object", "")) == subject_id;
        } else if (event_type == "boss") {
            matches = type == "boss_any" || (type == "boss" && String(quest.get("boss", "")) == subject_id);
        } else if (event_type == "rift") {
            matches = type == "rift";
        }

        if (!matches || (event_type != "complete" && progress_amount <= 0)) {
            continue;
        }

        const int64_t current = std::max<int64_t>(0, static_cast<int64_t>(progress.get(quest_id, 0)));
        const int64_t target = std::max<int64_t>(1, static_cast<int64_t>(quest.get("target", 1)));
        const int64_t next_progress = event_type == "complete" || current > target - progress_amount
                ? target
                : current + progress_amount;
        if (next_progress == current && next_progress < target) {
            continue;
        }
        progress[quest_id] = next_progress;
        changed = true;

        if (next_progress < target) {
            continue;
        }

        active.erase(quest_id);
        if (contains_id(completed, quest_id)) {
            continue;
        }
        completed.append(quest_id);
        completed_now.append(quest_id);
        xp_reward += std::max<int64_t>(0, static_cast<int64_t>(quest.get("xp", 0)));

        const Variant rewards_value = quest.get("rewards", Dictionary());
        if (rewards_value.get_type() == Variant::DICTIONARY) {
            const Dictionary rewards = rewards_value;
            const Array reward_ids = rewards.keys();
            for (int64_t reward_index = 0; reward_index < reward_ids.size(); ++reward_index) {
                const Variant key = reward_ids[reward_index];
                const String item_id = key;
                const int64_t item_count = std::max<int64_t>(0, static_cast<int64_t>(rewards[key]));
                item_rewards[item_id] = static_cast<int64_t>(item_rewards.get(item_id, 0)) + item_count;
            }
        }

        const String next_id = quest.get("next", "");
        if (!next_id.is_empty() && !contains_id(active, next_id) && !contains_id(completed, next_id)
                && !find_quest(definitions, next_id).is_empty()) {
            active.append(next_id);
            progress[next_id] = 0;
        }
    }

    state["active"] = active;
    state["completed"] = completed;
    state["progress"] = progress;

    Dictionary result;
    result["quests"] = state;
    result["changed"] = changed;
    result["completed_now"] = completed_now;
    result["xp_reward"] = xp_reward;
    result["items_reward"] = item_rewards;
    return result;
}
