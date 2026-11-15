#include "anime_nexus_combat_core.h"

#include <godot_cpp/core/class_db.hpp>
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <limits>

using namespace godot;

void AnimeNexusCombatCore::_bind_methods() {
    ClassDB::bind_method(D_METHOD("calculate_damage", "weapon_damage", "character_level", "damage_bonus",
            "critical_chance", "critical_roll", "critical_multiplier"),
            &AnimeNexusCombatCore::calculate_damage, DEFVAL(1.75));
    ClassDB::bind_method(D_METHOD("resolve_elemental_reaction", "element_a", "element_b"),
            &AnimeNexusCombatCore::resolve_elemental_reaction);
    ClassDB::bind_method(D_METHOD("advance_experience", "hunter", "progression", "amount"),
            &AnimeNexusCombatCore::advance_experience);
    ClassDB::bind_method(D_METHOD("companion_decision", "owner_distance", "enemy_distance", "owner_hp_ratio", "command"),
            &AnimeNexusCombatCore::companion_decision, DEFVAL("auto"));
    ClassDB::bind_method(D_METHOD("companion_damage", "base_damage", "player_level", "role_multiplier"),
            &AnimeNexusCombatCore::companion_damage);
    ClassDB::bind_method(D_METHOD("companion_avoidance_turn", "forward_blocked", "left_blocked",
            "right_blocked", "prefer_left"), &AnimeNexusCombatCore::companion_avoidance_turn);
    ClassDB::bind_method(D_METHOD("difficulty_profile", "difficulty_id"),
            &AnimeNexusCombatCore::difficulty_profile);
    ClassDB::bind_method(D_METHOD("resolve_loot", "loot_table", "monster_tier", "monster_id", "map_id",
            "character_level", "event_multiplier", "rarity_roll", "rare_bonus_roll", "item_index_a", "item_index_b"),
            &AnimeNexusCombatCore::resolve_loot);
    ClassDB::bind_method(D_METHOD("apply_craft", "inventory", "cost", "results"),
            &AnimeNexusCombatCore::apply_craft);
}

Dictionary AnimeNexusCombatCore::calculate_damage(double weapon_damage, int character_level,
        double damage_bonus, double critical_chance, double critical_roll, double critical_multiplier) const {
    const double safe_weapon_damage = std::max(0.0, weapon_damage);
    const int safe_level = std::max(1, character_level);
    const double safe_bonus = std::max(-1.0, damage_bonus);
    const double chance = std::clamp(critical_chance, 0.0, 0.65);
    const double roll = std::clamp(critical_roll, 0.0, 1.0);
    const double multiplier = std::max(1.0, critical_multiplier);
    const bool critical = roll < chance;
    const double base = safe_weapon_damage + static_cast<double>(safe_level - 1) * 2.5;
    const double amount = base * (1.0 + safe_bonus) * (critical ? multiplier : 1.0);

    Dictionary result;
    result["amount"] = amount;
    result["critical"] = critical;
    return result;
}

Dictionary AnimeNexusCombatCore::resolve_elemental_reaction(const String &element_a,
        const String &element_b) const {
    String a = element_a.to_lower();
    String b = element_b.to_lower();
    if (a > b) {
        std::swap(a, b);
    }

    Dictionary reaction;
    reaction["id"] = "none";
    reaction["damage_multiplier"] = 1.0;
    reaction["radius"] = 0.0;
    reaction["status"] = "none";
    reaction["splash_multiplier"] = 0.0;
    reaction["max_targets"] = 0;
    reaction["slow_duration"] = 0.0;
    reaction["slow_factor"] = 1.0;
    reaction["heal_ratio"] = 0.0;
    reaction["pull_strength"] = 0.0;

    if (a == "thunder" && b == "water") {
        reaction["id"] = "conductive_chain";
        reaction["damage_multiplier"] = 1.15;
        reaction["radius"] = 4.0;
        reaction["status"] = "chain_to_nearby_targets";
        reaction["splash_multiplier"] = 0.35;
        reaction["max_targets"] = 3;
    } else if (a == "fire" && b == "wind") {
        reaction["id"] = "ember_storm";
        reaction["damage_multiplier"] = 1.1;
        reaction["radius"] = 1.4;
        reaction["status"] = "expanded_burning_area";
        reaction["splash_multiplier"] = 0.30;
        reaction["max_targets"] = 4;
    } else if (a == "ice" && b == "wind") {
        reaction["id"] = "frost_mist";
        reaction["damage_multiplier"] = 1.0;
        reaction["radius"] = 3.0;
        reaction["status"] = "slow_and_obscure";
        reaction["slow_duration"] = 2.4;
        reaction["slow_factor"] = 0.48;
    } else if (a == "moon" && b == "nature") {
        reaction["id"] = "lunar_bloom";
        reaction["damage_multiplier"] = 1.0;
        reaction["radius"] = 3.5;
        reaction["status"] = "boost_allied_healing";
        reaction["heal_ratio"] = 0.06;
    } else if (a == "light" && b == "shadow") {
        reaction["id"] = "prism_echo";
        reaction["damage_multiplier"] = 1.2;
        reaction["radius"] = 2.5;
        reaction["status"] = "create_magic_reflections";
        reaction["splash_multiplier"] = 0.25;
        reaction["max_targets"] = 2;
    } else if (a == "gravity" || b == "gravity") {
        reaction["id"] = "resonance_singularity";
        reaction["damage_multiplier"] = 1.0;
        reaction["radius"] = 2.0;
        reaction["status"] = "concentrate_effects";
        reaction["pull_strength"] = 0.28;
    }

    return reaction;
}

Dictionary AnimeNexusCombatCore::companion_decision(double owner_distance, double enemy_distance,
        double owner_hp_ratio, const String &command) const {
    const double safe_owner_distance = std::max(0.0, owner_distance);
    const double safe_enemy_distance = enemy_distance;
    const double safe_owner_hp_ratio = std::clamp(owner_hp_ratio, 0.0, 1.0);
    Dictionary result;
    result["state"] = "follow";
    result["speed_multiplier"] = 1.0;
    if (command.to_lower() == "retreat") {
        result["state"] = "retreat";
        result["speed_multiplier"] = 1.55;
    } else if (safe_owner_distance > 16.0) {
        result["state"] = "regroup";
        result["speed_multiplier"] = 1.8;
    } else if (command.to_lower() == "follow") {
        result["state"] = "follow";
    } else if (safe_owner_hp_ratio <= 0.20) {
        result["state"] = "guard";
        result["speed_multiplier"] = 1.2;
    } else if (safe_enemy_distance >= 0.0 && safe_enemy_distance <= 5.2) {
        result["state"] = "attack";
    }
    return result;
}

double AnimeNexusCombatCore::companion_damage(double base_damage, int player_level,
        double role_multiplier) const {
    const double safe_base_damage = std::max(0.0, base_damage);
    const int safe_level = std::max(1, player_level);
    const double safe_role_multiplier = std::clamp(role_multiplier, 0.5, 2.0);
    return safe_base_damage * (1.0 + static_cast<double>(safe_level - 1) * 0.045)
            * safe_role_multiplier;
}

Dictionary AnimeNexusCombatCore::difficulty_profile(const String &difficulty_id) const {
    const String id = difficulty_id.to_lower();
    Dictionary result;
    if (id == "casual") {
        result["id"] = "casual";
        result["label"] = "Casual";
        result["enemy_health_multiplier"] = 0.78;
        result["enemy_damage_multiplier"] = 0.72;
        result["reward_multiplier"] = 0.90;
    } else if (id == "challenge") {
        result["id"] = "challenge";
        result["label"] = "Desafio";
        result["enemy_health_multiplier"] = 1.42;
        result["enemy_damage_multiplier"] = 1.32;
        result["reward_multiplier"] = 1.35;
    } else {
        result["id"] = "adventure";
        result["label"] = "Aventura";
        result["enemy_health_multiplier"] = 1.0;
        result["enemy_damage_multiplier"] = 1.0;
        result["reward_multiplier"] = 1.0;
    }
    return result;
}

Dictionary AnimeNexusCombatCore::resolve_loot(const Array &loot_table, int monster_tier,
        const String &monster_id, const String &map_id, int character_level, double event_multiplier,
        double rarity_roll, double rare_bonus_roll, int item_index_a, int item_index_b) const {
    const double roll = std::clamp(rarity_roll, 0.0, 0.999999);
    String rarity_id = "common";
    String rarity_name = "Comum";
    double rarity_multiplier = 1.0;
    if (roll > 0.995) {
        rarity_id = "legendary";
        rarity_name = "Lendário";
        rarity_multiplier = 3.20;
    } else if (roll > 0.96) {
        rarity_id = "epic";
        rarity_name = "Épico";
        rarity_multiplier = 2.20;
    } else if (roll > 0.85) {
        rarity_id = "rare";
        rarity_name = "Raro";
        rarity_multiplier = 1.60;
    } else if (roll > 0.58) {
        rarity_id = "uncommon";
        rarity_name = "Incomum";
        rarity_multiplier = 1.25;
    }

    const int safe_level = std::max(1, character_level);
    const int safe_tier = std::max(1, monster_tier);
    const double safe_event_multiplier = std::max(0.0, event_multiplier);
    const double level_multiplier = 1.0 + static_cast<double>(safe_level - 1) * 0.015;
    const double total_multiplier = rarity_multiplier * safe_event_multiplier * level_multiplier;
    const int64_t gold = std::max<int64_t>(1, static_cast<int64_t>(
            std::llround((8.0 + static_cast<double>(safe_tier) * 6.0) * total_multiplier)));

    Array safe_table = loot_table;
    if (safe_table.is_empty()) {
        safe_table.append("aether_core");
    }
    const int64_t table_size = safe_table.size();
    auto safe_index = [table_size](int value) -> int64_t {
        const int64_t index = static_cast<int64_t>(value) % table_size;
        return (index + table_size) % table_size;
    };
    const int drop_count = (rarity_id == "epic" || rarity_id == "legendary") ? 2 : 1;
    Dictionary items;
    for (int i = 0; i < drop_count; ++i) {
        const int64_t item_index = safe_index(i == 0 ? item_index_a : item_index_b);
        const String item_id = String(safe_table[item_index]);
        int amount = 1;
        if (rarity_id == "rare" && rare_bonus_roll < 0.35) {
            amount = 2;
        } else if (rarity_id == "epic") {
            amount = 2;
        } else if (rarity_id == "legendary") {
            amount = 3;
        }
        items[item_id] = static_cast<int64_t>(items.get(item_id, 0)) + amount;
    }

    Dictionary result;
    result["rarity"] = rarity_id;
    result["rarity_name"] = rarity_name;
    result["gold"] = gold;
    result["items"] = items;
    result["monster"] = monster_id;
    result["map"] = map_id;
    return result;
}

Dictionary AnimeNexusCombatCore::apply_craft(const Dictionary &inventory, const Dictionary &cost,
        const Dictionary &results) const {
    Dictionary unchanged = inventory.duplicate(true);
    Dictionary outcome;
    outcome["success"] = false;
    outcome["inventory"] = unchanged;
    outcome["reason"] = "invalid";
    const Array cost_keys = cost.keys();
    const Array result_keys = results.keys();

    for (int64_t i = 0; i < cost_keys.size(); ++i) {
        const String item_id = String(cost_keys[i]);
        const Variant amount_value = cost.get(item_id, 0);
        if (amount_value.get_type() != Variant::INT) {
            outcome["reason"] = "invalid_cost";
            return outcome;
        }
        const int64_t amount = static_cast<int64_t>(amount_value);
        if (amount < 0) {
            outcome["reason"] = "invalid_cost";
            return outcome;
        }
        const Variant current_value = inventory.get(item_id, 0);
        if (current_value.get_type() != Variant::INT
                || static_cast<int64_t>(current_value) < amount) {
            outcome["reason"] = "insufficient_materials";
            return outcome;
        }
    }
    for (int64_t i = 0; i < result_keys.size(); ++i) {
        const String item_id = String(result_keys[i]);
        const Variant amount_value = results.get(item_id, 0);
        if (amount_value.get_type() != Variant::INT || static_cast<int64_t>(amount_value) < 0) {
            outcome["reason"] = "invalid_result";
            return outcome;
        }
        const Variant current_value = inventory.get(item_id, 0);
        if (current_value.get_type() != Variant::INT) {
            outcome["reason"] = "invalid_inventory";
            return outcome;
        }
        int64_t current = static_cast<int64_t>(current_value);
        for (int64_t j = 0; j < cost_keys.size(); ++j) {
            if (String(cost_keys[j]) == item_id) {
                current -= static_cast<int64_t>(cost.get(item_id, 0));
                break;
            }
        }
        const int64_t amount = static_cast<int64_t>(amount_value);
        if (current > std::numeric_limits<int64_t>::max() - amount) {
            outcome["reason"] = "inventory_overflow";
            return outcome;
        }
    }

    Dictionary updated = inventory.duplicate(true);
    for (int64_t i = 0; i < cost_keys.size(); ++i) {
        const String item_id = String(cost_keys[i]);
        const int64_t amount = static_cast<int64_t>(cost.get(item_id, 0));
        updated[item_id] = static_cast<int64_t>(updated.get(item_id, 0)) - amount;
    }
    for (int64_t i = 0; i < result_keys.size(); ++i) {
        const String item_id = String(result_keys[i]);
        const int64_t amount = static_cast<int64_t>(results.get(item_id, 0));
        updated[item_id] = static_cast<int64_t>(updated.get(item_id, 0)) + amount;
    }

    outcome["success"] = true;
    outcome["inventory"] = updated;
    outcome["reason"] = "ok";
    return outcome;
}

Dictionary AnimeNexusCombatCore::advance_experience(const Dictionary &hunter,
        const Dictionary &progression, int64_t amount) const {
    int64_t level = std::max<int64_t>(1, static_cast<int64_t>(hunter.get("level", 1)));
    int64_t xp = std::max<int64_t>(0, static_cast<int64_t>(hunter.get("xp", 0)));
    int64_t xp_to_next = std::max<int64_t>(1, static_cast<int64_t>(hunter.get("xp_to_next", 120)));
    int64_t max_hp = std::max<int64_t>(1, static_cast<int64_t>(hunter.get("max_hp", 140)));
    int64_t skill_points = std::max<int64_t>(0, static_cast<int64_t>(progression.get("skill_points", 0)));
    double max_energy = std::max(1.0, static_cast<double>(hunter.get("max_energy", 100.0)));
    const int64_t xp_gained = std::max<int64_t>(0, amount);
    xp = xp > std::numeric_limits<int64_t>::max() - xp_gained
            ? std::numeric_limits<int64_t>::max()
            : xp + xp_gained;

    int64_t levels_gained = 0;
    while (xp >= xp_to_next && level < std::numeric_limits<int32_t>::max()) {
        xp -= xp_to_next;
        ++level;
        xp_to_next = 120 + (level - 1) * 35;
        max_hp += 12;
        max_energy += 4.0;
        ++skill_points;
        ++levels_gained;
    }

    Dictionary result;
    result["level"] = level;
    result["xp"] = xp;
    result["xp_to_next"] = xp_to_next;
    result["max_hp"] = max_hp;
    result["hp"] = max_hp;
    result["max_energy"] = max_energy;
    result["skill_points"] = skill_points;
    result["levels_gained"] = levels_gained;
    return result;
}
