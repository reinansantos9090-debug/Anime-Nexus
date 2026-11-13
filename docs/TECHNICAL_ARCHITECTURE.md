# Arquitetura técnica e auditoria inicial

## Identidade e escopo encontrado

Checkout auditado: `reinansantos9090-debug/Anime-Nexus`, branch padrão `main`, commit `87e54dc4df72090b9b29ab40e4d7f82e1518d012` (13 nov. 2026 no checkout). A branch isolada de trabalho é `dev/anime-nexus-vertical-slice`. A árvore tinha 115 arquivos versionados e cerca de 3,8 MB. README, nomes de pacote, título do Godot, save e conteúdo descrevem **Teste-jue/Aetheria: Echoes**, não Anime Nexus. Nenhum arquivo foi encontrado no repositório original ReiAnix; este trabalho ocorre apenas no repositório Anime-Nexus.

## Estrutura verificada

| Área | Conteúdo presente | Estado observável |
|---|---|---|
| Android Kotlin | `MainActivity`, `game3d` (engine, sessão, combate, IA, OpenGL, renderer, HUD, perfil mobile, áudio/telemetria), `offline` (regras, catálogo, runtime de mapa, história e progressão) | Runtime Android nativo independente; OpenGL ES 2.0, cena própria. Há controles, combate, persistência e menus do protótipo, sem conteúdo Anime Nexus. |
| Godot | projeto 4.x em `godot/`, cenas, `game_root.gd`, serviços `core/gameplay/world/visuals/ui`, shader toon e runner | Runtime 3D separado, construído por Godot; há ligação do root aos serviços e cenas, não são apenas arquivos vazios. Muitos objetos são meshes procedurais simples. |
| Recursos artísticos | ícones Android e três materiais `.tres` | Nenhum modelo 3D, rig, clipe de animação, textura de cenário ou arquivo de áudio foi encontrado. |
| Dados/testes | um teste JUnit de regras Kotlin; `godot/tests/test_runner.gd` | Godot runner passa localmente e no CI; JUnit não inicia porque `:app:compileDebugKotlin` falha antes. |
| Gradle | app single-module, AGP 9.1.1, Kotlin 2.2.21, Java 21, `minSdk 26`, `targetSdk 36` | Declaração Android é portrait e pacote ainda legado. Build local falhou ao resolver AGP 9.1.1. |
| GitHub Actions | `android.yml` baixa JDK/Gradle/Godot, valida, testa e exporta APK Godot como artifact | Workflow desta branch usa permissão de leitura, testa a revisão do evento e não faz push para `main`. Godot exporta; host Kotlin segue bloqueado pelos erros no código legado. |

## Integração e funcionalidade real

**Kotlin:** `MainActivity` abre `Game3DRoot`, com lifecycle pause/resume e back. A lógica está dividida em engine/AI/combat/session e um HUD que implementa controles touch. `OfflineGameplayRulesTest` cobre dano/crit, XP, loot, round-trip do save e pré-condições de crafting; esses casos são unitários, não demonstram a experiência visual. O renderer desenha geometria por código. O app está em orientação portrait e usa OpenGL ES 2; não há sistema de animação esquelética ou import de modelos.

**Godot:** `Main.tscn` instancia `game_root.gd`; este cria/coordena serviços de estado, save, catálogo de conteúdo, mundo, câmera, HUD, quests, combate e inimigos. `world_service.gd` monta hub/mapas, e `map_service.gd` define cinco arenas e obstáculos. `enemy_agent.gd` implementa estados de inimigos; `boss_agent.gd` contém fases; `combat_service.gd`, `quest_service.gd`, inventário/progressão e `save_service.gd` têm lógica executável. `test_runner.gd` testa regras/salvamento (PASS nesta máquina). A câmera usa offset vertical-traseiro (não isométrico verdadeiro), cenário é uma arena plana de 58×58 com detalhes de primitivas. O joystick analógico acabou de ser integrado, mas o layout geral/HUD ainda não foi validado por toque em dispositivo. O menu de campanhas, eventos e desafios contém simulações offline herdadas de Aetheria.

**Primeiro incremento da slice:** `virtual_joystick.gd` está integrado ao HUD do protótipo, envia movimento analógico ao loop e tem teste determinístico de deadzone/normalização; a cena principal passou smoke run headless. Ainda não foi verificado com touchscreen físico e não transforma o jogo em slice Anime Nexus.

**Assets:** `asset_manifest.gd` enumera IDs de assets esperados, mas as pastas correspondentes não contêm os arquivos. O README chama assets originais de pipeline, sem inventário de arquivos/licenças. O jogo não pode ser apresentado como tendo arte anime final ou animações completas.

## Comparação de motores e decisão

| Critério | Kotlin/OpenGL ES próprio | Godot 4 |
|---|---|---|
| APK Android nativo | Já há Activity/render loop e workflow Gradle | Exporta APK Android com templates e preset; workflow atual já cobre o caminho, ainda precisa de build reproduzível validado |
| Reuso atual | Preserva app e sistemas Kotlin | Reusa o projeto/cenas/serviços já versionados em Godot, mas não compartilha runtime com Activity Kotlin |
| Modelos, rig e animação | Exigiria desenvolver/importar um pipeline próprio | Importação de assets 3D, AnimationTree/AnimationPlayer e skeletons são capacidades nativas |
| Iluminação, sombras, partículas, colisões, navegação | Renderer e sistemas físicos teriam que ser criados e mantidos | Nós/recursos de motor disponíveis; projeto já usa `Node3D`, câmera, luz, GPUParticles e cenas |
| Performance mobile | Controle direto, porém custo de manter engine inteiro no projeto | Perfil renderer mobile, redução de qualidade/LOD e ferramentas do engine; precisa de profiling em hardware antes de prometer FPS |
| Manutenção/risco | Dois engines de gameplay se forem adicionados os serviços de Godot | Evita construir mais engine custom; risco imediato é ter dois APKs/runtime no mesmo repo |

**Decisão para a vertical slice: Godot 4 como runtime/renderizador e C++ via GDExtension como linguagem principal da lógica de gameplay.** A vantagem concreta do Godot é importar personagens animados e oferecer cenas, materiais, partículas, colisão, navegação e exportação Android, enquanto GDExtension permite implementar domínio e sistemas centrais em C++ sem reescrever o renderer. O ataque básico, críticos e tabela de reações elementais começam a migrar para uma classe C++ registrada no motor e são chamados pelo fluxo real de combate. GDScript fica para orquestração de cenas/UI e integração de nós; não será a fonte de verdade das regras de combate, progressão, missões, IA ou salvamento. O trabalho de migração é incremental e só passa a Testado após build e testes do núcleo nativo no host e no APK Android.

Kotlin permanece somente no host/protótipo Android legado até existir decisão explícita de unificação. Para shaders, o alvo mobile usará o shader language do Godot (compilado pelo motor para o backend gráfico); GLSL/HLSL são considerados apenas para shaders ou compute específicos se o perfil de aparelho justificar. Java/Kotlin pode integrar APIs Android por plugin/ponte quando necessário, nunca substituir C++ na lógica do jogo. Metal, Objective-C e Swift não participam do APK Android; são alternativas para uma futura exportação Apple, caso ela seja aprovada. Isso mantém cada linguagem em um papel técnico real, sem adicionar tecnologias sem uso.

## Build, CI e AI Studio

- Teste local Android executado: Gradle não conseguiu resolver AGP 9.1.1 e o ambiente não tem Android SDK/build-tools. No GitHub Actions, a compilação alcança `:app:compileDebugKotlin`, mas falha com 155 erros em 10 arquivos legados; JUnit e APK Kotlin não são produzidos.
- Teste local Godot: versão disponível 4.6.3 (projeto/CI declara 4.7.2), import headless encerrou sem erro de script; runner `ANIME_NEXUS_TESTS: PASS` e smoke run de 180 frames encerraram sem erro de script. Permanecem avisos de instâncias/recursos no encerramento. A diferença de versões limita a equivalência com CI.
- A última run reportada em GitHub para `main` (run `37742261619`, commit de 8 out. 2026) terminou `failure`. Godot validou e test runner passou; o job falhou na regra de “referência externa” Kotlin, que marcou até símbolos com uso em outros arquivos. Isso sugere falsos positivos do verificador, não prova de código Kotlin órfão. A antiga etapa anterior também fazia checkout de `main` e tinha permissão de escrita/push no workflow. O workflow nesta branch agora valida a revisão do evento, roda os dois caminhos de build/test e só precisa de permissão de leitura.
- CI mais recente da branch: run `43406704240`, commit `036b9ad3e621a660c34d8230d680e6b8c1d20c79`, passou validação Godot 4.7.2 e exportou APK debug de 28,2 MB. O job Kotlin falhou em `:app:compileDebugKotlin`; JUnit e APK Kotlin não foram produzidos.
- AI Studio foi avaliado pela documentação oficial atual ([limitações Android](https://ai.google.dev/gemini-api/docs/aistudio-android) e [Build mode](https://ai.google.dev/gemini-api/docs/aistudio-build-mode)). O modo Android gera Kotlin/Compose em app de atividade única, sem NDK, e a página específica de Android diz que exportação GitHub ainda não está disponível. A página geral descreve import/sync GitHub, mas não confirma suporte ao runtime Godot/OpenGL; portanto não usei AI Studio para editar ou validar esta slice. O fluxo direto pelo checkout e GitHub Actions segue reproduzível e compatível com o motor escolhido.

## Arquitetura proposta

Godot Android offline, renderer Mobile, orientação landscape, C++17 via GDExtension como domínio do jogo. A biblioteca `godot-cpp` é fixada em `10.0.0-stable` (`507ed9d`) e API Godot `4.7`; builds separados geram host Linux para testes e Android arm64 para APK. `AnimeNexusCombatCore` calcula dano/crítico, reações elementais e XP/nível; `AnimeNexusQuestCore` calcula progresso, conclusão, desbloqueio seguinte e recompensas. O serviço GDScript encaminha eventos do jogo para o núcleo. A tabela de reações já existe e é testada, mas seus efeitos ainda não foram conectados às habilidades/estados de alvos na cena. Próximos domínios a mover são cooldown/energia, inventário/equipamento, máquinas de estado da IA e serialização/save. Cenas, UI e ligação de nós permanecem GDScript fino.

Dados de missão/personagem/equipamento serão Resources/JSON versionados com schema e IDs estáveis; o C++ passa a validar/transacionar essas regras antes da migração de cada subsistema. Cena de jogo separada da UI; `CharacterBody3D`/NavigationAgent para movimento/companheiros; renderer e física do Godot. Save versionado com três slots e backup atômico. Resources de arte vinculados por manifest que verifica caminho, origem/licença, dimensões e status. Perfis gráficos configuráveis e métricas coletadas em aparelho. Gradle/Kotlin apenas para componentes Android que exijam APIs do sistema.
