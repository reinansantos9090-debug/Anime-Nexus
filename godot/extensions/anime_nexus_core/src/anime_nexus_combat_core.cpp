#include "anime_nexus_combat_core.h"

#include <godot_cpp/core/class_db.hpp>
#include <algorithm>
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

    if (a == "thunder" && b == "water") {
        reaction["id"] = "conductive_chain";
        reaction["damage_multiplier"] = 1.15;
        reaction["radius"] = 4.0;
        reaction["status"] = "chain_to_nearby_targets";
    } else if (a == "fire" && b == "wind") {
        reaction["id"] = "ember_storm";
        reaction["damage_multiplier"] = 1.1;
        reaction["radius"] = 1.4;
        reaction["status"] = "expanded_burning_area";
    } else if (a == "ice" && b == "wind") {
        reaction["id"] = "frost_mist";
        reaction["damage_multiplier"] = 1.0;
        reaction["radius"] = 3.0;
        reaction["status"] = "slow_and_obscure";
    } else if (a == "moon" && b == "nature") {
        reaction["id"] = "lunar_bloom";
        reaction["damage_multiplier"] = 1.0;
        reaction["radius"] = 3.5;
        reaction["status"] = "boost_allied_healing";
    } else if (a == "light" && b == "shadow") {
        reaction["id"] = "prism_echo";
        reaction["damage_multiplier"] = 1.2;
        reaction["radius"] = 2.5;
        reaction["status"] = "create_magic_reflections";
    } else if (a == "gravity" || b == "gravity") {
        reaction["id"] = "resonance_singularity";
        reaction["damage_multiplier"] = 1.0;
        reaction["radius"] = 2.0;
        reaction["status"] = "concentrate_effects";
    }

    return reaction;
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
