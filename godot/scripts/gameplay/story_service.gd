extends Node
signal line_started(character: String, text: String)
signal chapter_changed(chapter: int)
signal journal_added(text: String)

var game_state: Node

const CHAPTERS := [
    {"title":"Prólogo • O Primeiro Fragmento","lines":[
        ["Kaien Arashi","A ruína ficou em silêncio por séculos. Por que este fragmento reage ao meu pulso?"],
        ["Kaien Arashi","Essa descarga... eu já senti algo parecido nas histórias que minha família nunca terminava."],
        ["Akari Solen","A fenda está se fechando! Se você consegue ouvir o fragmento, venha comigo antes que ele desperte outra coisa."],
        ["Ren Aozora","O caminho não termina no portal. A ressonância está levando direto ao Observatório de Íris."],
        ["Iori","Há muitas gerações, a Noite das Oito Fendas espalhou o Coração do Nexo. Nunca vimos um fragmento responder a alguém dessa forma."],
        ["Meka","As manoplas vão canalizar a descarga sem romper seus braços. São provisórias, mas já servem para a primeira expedição."],
        ["Pia","Registrei a rota até Nimbara. Liora pediu ajuda: as criaturas da clareira estão reagindo a uma energia que não pertence à floresta."],
        ["Kaien Arashi","Então vamos descobrir por que o fragmento conhece minha família. Akari, Ren: vamos juntos."]
    ]}
]

func setup(state: Node) -> void:
    game_state = state

func current_chapter() -> Dictionary:
    return CHAPTERS[0]

func next_line() -> Dictionary:
    var story: Dictionary = game_state.data["story"]
    var chapter: Dictionary = current_chapter()
    var lines: Array = chapter["lines"]
    var index := int(story.get("scene",0))
    if index >= lines.size():
        return {"character":"Iori","text":"A próxima etapa exige novas missões e cenas. O conteúdo jogável desta slice termina na primeira Âncora de Nimbara."}
    var pair: Array = lines[index]
    story["scene"] = index + 1
    var character := str(pair[0])
    var text := str(pair[1])
    story["journal"].append("%s: %s" % [character, text])
    game_state.story_changed.emit()
    game_state.state_changed.emit()
    line_started.emit(character, text)
    journal_added.emit(text)
    return {"character":character,"text":text}

func chapter_title() -> String:
    return str(current_chapter()["title"])
