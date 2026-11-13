#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {

class AnimeNexusQuestCore : public RefCounted {
    GDCLASS(AnimeNexusQuestCore, RefCounted)

protected:
    static void _bind_methods();

public:
    Dictionary start_quest(const Dictionary &quest_state, const Array &definitions, const String &quest_id) const;
    Dictionary apply_event(const Dictionary &quest_state, const Array &definitions, const String &event_type,
            const String &subject_id, int64_t amount = 1) const;
};

} // namespace godot
