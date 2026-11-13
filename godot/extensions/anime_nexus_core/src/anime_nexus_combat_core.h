#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
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
};

} // namespace godot
