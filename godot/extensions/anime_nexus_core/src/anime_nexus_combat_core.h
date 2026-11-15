#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>

#include <cstdint>

namespace godot {

class AnimeNexusCombatCore : public RefCounted {
    GDCLASS(AnimeNexusCombatCore, RefCounted)

protected:
    static void _bind_methods();

public:
    Dictionary calculate_damage(double weapon_damage, int character_level, double damage_bonus,
            double critical_chance, double critical_roll, double critical_multiplier = 1.75) const;
    Dictionary resolve_elemental_reaction(const String &element_a, const String &element_b) const;
    Dictionary advance_experience(const Dictionary &hunter, const Dictionary &progression, int64_t amount) const;
    Dictionary companion_decision(double owner_distance, double enemy_distance, double owner_hp_ratio,
            const String &command = String("auto")) const;
    double companion_damage(double base_damage, int player_level, double role_multiplier) const;
    double companion_avoidance_turn(bool forward_blocked, bool left_blocked, bool right_blocked,
            bool prefer_left) const;
    Dictionary difficulty_profile(const String &difficulty_id) const;
    Dictionary resolve_loot(const Array &loot_table, int monster_tier, const String &monster_id,
            const String &map_id, int character_level, double event_multiplier, double rarity_roll,
            double rare_bonus_roll, int item_index_a, int item_index_b) const;
    Dictionary apply_craft(const Dictionary &inventory, const Dictionary &cost,
            const Dictionary &results) const;
    Dictionary resolve_supreme_meter(double current_charge, double gain, bool activate) const;
};

} // namespace godot
