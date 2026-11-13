# Núcleo C++ de Anime Nexus

## Decisão

O jogo usa Godot 4 para cenas, renderização, importação de arte, input, física e exportação Android. C++17 via GDExtension é a linguagem principal da lógica autoritativa de gameplay. A biblioteca `godot-cpp` é dependência de build, não precisa ser baixada durante a execução.

GDScript faz a composição de cenas e conecta eventos/controles com os serviços C++. Um subsistema só deixa de ser fonte de verdade em GDScript quando a regra já está implementada e testada no C++; manter duas fórmulas paralelas é proibido.

## Linguagens e papéis

| Linguagem | Uso no projeto |
|---|---|
| C++17 | Regras de combate, reações elementais e futura lógica de progressão, missões, IA e persistência. |
| GDScript | Montagem de cenas, sinais, UI e ponte curta para os nós do motor; sem regras duplicadas. |
| Godot Shader Language | Materiais/shaders estilizados no renderer Mobile. |
| Java/Kotlin | Plugin Android apenas quando uma API nativa do sistema exigir uma ponte. O app Kotlin legado continua isolado. |
| GLSL/HLSL | Opcional, só para shader/compute específico após teste de compatibilidade e perfil. Não é a linguagem base dos materiais Godot. |
| Metal/Objective-C/Swift | Fora do APK Android; reservado a eventual port Apple. |

## Primeiro núcleo integrado

`AnimeNexusCombatCore` é registrado pelo módulo GDExtension e expõe:

- `calculate_damage`: aplica nível, bônus, chance de crítico e multiplicador com limites seguros; devolve dano e indicador de crítico.
- `resolve_elemental_reaction`: tabela determinística e sem dependência de ordem entre pares, com ID, multiplicador, raio e estado resultante.
- `advance_experience`: aplica carry-over, curva de requisitos, ponto de habilidade e crescimento de atributos ao subir de nível.

`AnimeNexusQuestCore` é registrado na mesma biblioteca e expõe `start_quest` e `apply_event`: confere os tipos de objetivos, incrementa progresso, impede reabertura/conclusão duplicada, desbloqueia a próxima missão e calcula XP/materiais. `quest_service.gd` traduz interações do mundo em eventos e atualiza sinais/recompensas.

`combat_service.gd` chama o núcleo para o ataque básico que o jogador usa. O resultado crítico chega ao inimigo e à exibição de dano; `game_state.add_xp` encaminha XP para o cálculo nativo. O wrapper mantém `player_damage()` para compatibilidade temporária. A tabela de combinações elementais está testada em C++, mas ainda não aplica os efeitos às habilidades/inimigos durante a luta.

## Build e distribuição

- `godot/extensions/anime_nexus_core/SConstruct` usa SCons e Godot C++ bindings `10.0.0-stable`, SHA `507ed9d840c01a3c5b2a39af8bb4000bfac30bf5`.
- API da extensão fixada em Godot `4.7`; não atualizar versão sem validar CI.
- CI compila uma biblioteca Linux release para carregar o núcleo nos testes headless e bibliotecas Android arm64 debug/release para empacotar no APK.
- Os binários são artefatos de build e não são versionados. O app instalado tem a extensão embutida e todo o gameplay permanece local/offline.
- Para compilar manualmente, instale Python 3.12, SCons 4.9.1, toolchain C++ e Android NDK r28b (`28.1.13356709`); clone `godotengine/godot-cpp`, faça checkout no SHA acima e coloque o checkout em `godot/extensions/anime_nexus_core/godot-cpp`. Execute `scons platform=linux target=template_release arch=x86_64` ou `scons platform=android target=template_debug arch=arm64` e repita com `target=template_release` para release.

## Status honesto

- **Implementado no núcleo / Testado no host:** damage/crítico, XP/nível e transições de missão; C++ Linux carregado no Godot 4.7.2 e regras cobertas pelo runner.
- **Em desenvolvimento:** build arm64 no CI e execução das reações elementais nas habilidades.
- **Planejado:** migração das regras de combate restantes, IA, equipamentos e serialização.
- **Não declarado como testado:** build Android e testes nativos precisam passar no CI; o teste local não tem Android NDK instalado.
- Renderização, personagens anime finais, recursos artísticos de produção e a campanha completa continuam pendentes conforme `IMPLEMENTATION_STATUS.md`.
