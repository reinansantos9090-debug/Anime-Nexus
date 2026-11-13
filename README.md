# Anime Nexus: Fragmentos do Infinito

RPG de ação 3D original para Android, planejado como experiência single-player inteiramente offline. Este repositório está no começo da transição: a base ainda contém o protótipo jogável Aetheria: Echoes em Kotlin/OpenGL e Godot. Esse conteúdo não deve ser confundido com campanha/personagens finais de Anime Nexus.

## Estado real

- Build e jogo final: **não concluídos**.
- Protótipo Android Kotlin/OpenGL: presente; conteúdo e identidade antigos.
- Protótipo Godot: mundo/combate/progressão offline, testes headless passam no Godot 4.6.3 local; conteúdo e visual antigos.
- Arte final de personagem/cenário/áudio: ainda não presente.
- A vertical slice começa pelo fluxo Kaien + Nimbara, depois da escolha do runtime documentada.

## Documentação de projeto

- [Game Design Document](docs/GAME_DESIGN_DOCUMENT.md)
- [Lore e história](docs/LORE_AND_STORY.md)
- [Personagens e habilidades](docs/CHARACTERS_AND_ABILITIES.md)
- [Mundos e criaturas](docs/WORLDS_AND_CREATURES.md)
- [Missões e diálogos](docs/MISSIONS_AND_DIALOGUES.md)
- [Equipamentos e progressão](docs/EQUIPMENT_AND_PROGRESSION.md)
- [Direção visual](docs/VISUAL_ART_DIRECTION.md)
- [Inventário de assets](docs/ASSET_PRODUCTION.md)
- [Arquitetura e auditoria](docs/TECHNICAL_ARCHITECTURE.md)
- [Requisitos offline](docs/OFFLINE_REQUIREMENTS.md)
- [Plano de testes](docs/TEST_PLAN.md)
- [Roadmap](docs/DEVELOPMENT_ROADMAP.md)
- [Estado de implementação](docs/IMPLEMENTATION_STATUS.md)

## Build atual

O workflow Android valida testes e publica artifacts de APK por commit/PR. Ele não faz push nem limpeza automática em `main`. Os APKs do host Kotlin e do projeto Godot ainda são protótipos e não representam versão final.
