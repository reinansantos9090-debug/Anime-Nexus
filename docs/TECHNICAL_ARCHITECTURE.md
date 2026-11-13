# Arquitetura técnica e auditoria inicial

## Identidade e escopo encontrado

Checkout auditado: `reinansantos9090-debug/Anime-Nexus`, branch padrão `main`, commit `87e54dc4df72090b9b29ab40e4d7f82e1518d012` (13 nov. 2026 no checkout). A branch isolada de trabalho é `dev/anime-nexus-vertical-slice`. A árvore tinha 115 arquivos versionados e cerca de 3,8 MB. README, nomes de pacote, título do Godot, save e conteúdo descrevem **Teste-jue/Aetheria: Echoes**, não Anime Nexus. Nenhum arquivo foi encontrado no repositório original ReiAnix; este trabalho ocorre apenas no repositório Anime-Nexus.

## Estrutura verificada

| Área | Conteúdo presente | Estado observável |
|---|---|---|
| Android Kotlin | `MainActivity`, `game3d` (engine, sessão, combate, IA, OpenGL, renderer, HUD, perfil mobile, áudio/telemetria), `offline` (regras, catálogo, runtime de mapa, história e progressão) | Runtime Android nativo independente; OpenGL ES 2.0, cena própria. Há controles, combate, persistência e menus do protótipo, sem conteúdo Anime Nexus. |
| Godot | projeto 4.x em `godot/`, cenas, `game_root.gd`, serviços `core/gameplay/world/visuals/ui`, shader toon e runner | Runtime 3D separado, construído por Godot; há ligação do root aos serviços e cenas, não são apenas arquivos vazios. Muitos objetos são meshes procedurais simples. |
| Recursos artísticos | ícones Android e três materiais `.tres` | Nenhum modelo 3D, rig, clipe de animação, textura de cenário ou arquivo de áudio foi encontrado. |
| Dados/testes | um teste JUnit de regras Kotlin; `godot/tests/test_runner.gd` | Godot runner passou localmente; JUnit não pôde iniciar devido à resolução do plugin Android Gradle. |
| Gradle | app single-module, AGP 9.1.1, Kotlin 2.2.21, Java 21, `minSdk 26`, `targetSdk 36` | Declaração Android é portrait e pacote ainda legado. Build local falhou ao resolver AGP 9.1.1. |
| GitHub Actions | `android.yml` baixa JDK/Gradle/Godot, valida, roda testes e exporta APK Godot como artifact | Workflow antigo tem etapa `cleanup-retired-sources` que faz `git push origin HEAD:main`. É um efeito colateral destrutivo e incompatível com a regra desta iniciativa de não escrever na main; deve ser removido antes de habilitar esta branch em CI. |

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

**Decisão para a vertical slice: Godot como runtime de jogo canônico; Kotlin permanece apenas como host/protótipo isolado enquanto se comprova o APK Godot.** A vantagem concreta é que o escopo exige import de personagens animados, iluminação, partículas, colisão e navegação; o runtime OpenGL existente implementa representação procedural, não esse pipeline. O repositório já tem um projeto Godot ligado a combate, mundo, conteúdo e save e workflow de exportação. Não se deve apagar o caminho Kotlin nem considerar a migração concluída: a decisão será reavaliada se o APK Godot não puder ser instalado/validado ou se uma ponte nativa se mostrar necessária. A publicação final deverá oferecer um único app identificado como Anime Nexus.

## Build, CI e AI Studio

- Teste local Android executado: `./gradlew testDebugUnitTest assembleDebug` → falhou antes de compilar o app, porque o plugin `com.android.application:9.1.1` não foi encontrado pelos repositórios. Sem Android SDK/build-tools, não houve APK local.
- Teste local Godot: versão disponível 4.6.3 (projeto/CI declara 4.7.2), import headless encerrou sem erro de script; `godot --headless --path godot --script tests/test_runner.gd` → `AETHERIA_TESTS: PASS`, com avisos de resources/instâncias ainda em uso no encerramento. A diferença 4.6.3/4.7.2 limita a equivalência com CI.
- A última run reportada em GitHub para `main` (run `37742261619`, commit de 8 out. 2026) terminou `failure`. Godot validou e test runner passou; o job falhou na regra de “referência externa” Kotlin, que marcou até símbolos com uso em outros arquivos. Isso sugere falsos positivos do verificador, não prova de código Kotlin órfão. A antiga etapa anterior também fazia checkout de `main` e tinha permissão de escrita/push no workflow. O workflow nesta branch agora valida a revisão do evento, roda os dois caminhos de build/test e só precisa de permissão de leitura.
- AI Studio foi avaliado pela documentação oficial atual ([Build Android apps](https://ai.google.dev/gemini-api/docs/aistudio-android) e [Build mode](https://ai.google.dev/gemini-api/docs/aistudio-build-mode)). O modo Android gera Kotlin/Compose em projeto de atividade única e sua documentação específica diz que o projeto Android exporta como ZIP e que exportação GitHub ainda não está disponível. A orientação geral de import/sync GitHub não prova compatibilidade do runtime Godot/OpenGL existente. Como a vertical slice exige runtime Godot, AI Studio não é ferramenta adequada para editar/testar este projeto. Trabalho direto no checkout e no GitHub é a alternativa reproduzível.

## Arquitetura proposta

Godot Android offline, renderer Mobile, orientação landscape. Dados de missão/personagem/equipamento em Resources ou JSON versionado com schema e IDs estáveis. Cena de jogo separada da UI; `CharacterBody3D`/NavigationAgent para movimento/companheiros; máquina de estados determinística para inimigos; combate e efeitos resolvidos por serviços sem rede. Save versionado com três slots e backup atômico. Resources de arte vinculados por manifest que verifica caminho, origem/licença, dimensões e status. Perfis gráficos configuráveis e métricas coletadas em aparelho. Gradle/Kotlin só para componentes Android que exijam APIs do sistema, nunca para duplicar a lógica de jogo.
