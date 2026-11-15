# Estado de implementação auditado

Data da auditoria: 15 nov. 2026, branch `dev/anime-nexus-vertical-slice`.

| Sistema alvo | Categoria | Evidência / pendência |
|---|---|---|
| C++ como linguagem principal do jogo | Em desenvolvimento | GDExtensions `AnimeNexusCombatCore` e `AnimeNexusQuestCore` já são chamadas pelo ataque básico, progressão de XP/nível e ciclo de progresso/conclusão/recompensa de missões. A tabela C++ já é consultada nos ataques e habilidades do jogador e fornece multiplicadores e parâmetros numéricos para condução, expansão de área, lentidão, cura, eco e atração; GDScript só os aplica aos nós e efeitos locais. Uma regressão curta foi adicionada ao runner Godot; ela ainda aguarda execução manual e não é validada pelo job Android Kotlin. Linux release compilado localmente; Godot 4.7.2 headless passou testes. Android arm64 ainda aguarda CI, e IA, economia, equipamentos e save continuam em GDScript. |
| GDScript | Implementado (camada de integração) | Atualmente conecta cenas, UI, nós, sinais e chamadas do núcleo nativo. Parte da lógica de jogo ainda reside nos serviços GDScript e deve migrar antes de declarar C++ como fonte autoritativa de todos os subsistemas. |
| App Android nativo | Implementado (host do protótipo) | Activity Kotlin e manifest; nome/pacote/orientação atuais não são finais |
| OpenGL ES e loop de combate Kotlin | Implementado (protótipo Aetheria) | engine/render/AI/combat/session/HUD em `app/src/main/java/.../game3d`; geometria procedural |
| Godot Android export | Testado em revisão anterior | workflow Godot 4.7.2 exportou APK da slice em run `43409376899`; o workflow longo atual é manual e ainda não foi executado para esta integração |
| Godot + GDExtension C++ | Em desenvolvimento | Godot mantém renderer/cenas/física; C++17 é o domínio autoritativo em migração. A arquitetura e funções iniciais estão em `CPP_GAMEPLAY_ARCHITECTURE.md`; falta CI Android/arm64 e migração dos demais domínios. |
| Câmera isométrica | Implementado (protótipo) | câmera ortográfica diagonal com acompanhamento suave; zoom, ocultação de obstáculos e teste visual em aparelho pendentes |
| Kaien | Em desenvolvimento | avatar procedural blockout com cores, cabelo e manoplas distintivos; sem modelo anime final, rig/skinning ou animações de produção |
| Sete aliados | Planejado | nenhum personagem Anime Nexus produzido no runtime |
| Nimbara | Em desenvolvimento | mapa 3D blockout com trilha, árvores, raízes, cristais e âncora; sem subáreas e arte final |
| Habilidades, inimigos e chefe Anime Nexus | Em desenvolvimento | três efeitos de Kaien, inimigos de Nimbara e Cérvido de Cristal integrados ao protótipo; telegraph circular para ataques em área com resolução atrasada testado, mas legibilidade em aparelho, outros padrões, arena e animações finais pendentes |
| Combate e inimigos locais offline | Em desenvolvimento | combate da slice Godot tem ataques, habilidades, afinidades e reações locais; integração C++/Godot aguarda validação manual e APK Godot atual |
| Joystick virtual analógico | Implementado (protótipo) | Godot HUD recebe toque/arraste, produz direção com deadzone e intensidade gradual; regra testada headless, toque em celular pendente |
| Missão da slice | Em desenvolvimento | cadeia de missão, chefe e interação por proximidade da Âncora; regras de avanço testadas, fluxo de toque em aparelho pendente |
| Companions com máquina de estados | Planejado | nenhum squad follow/combat completo observado no runtime Godot |
| Campanha principal e secundárias | Planejado | story/quest catalogs Aetheria menores; não há 60+45 Anime Nexus |
| Inventário/equipamentos | Implementado (protótipo) | inventário/wardrobe/crafting Aetheria; slots e catálogo alvo não integram |
| Save offline | Testado (protótipo) | save Godot single JSON + backup; fallback após JSON principal corrompido passou teste headless local e CI; Kotlin codec; faltam 3 slots, integridade e migração |
| Arte original final | Planejado | só ícones, materiais simples e meshes procedurais; inventário em `ASSET_PRODUCTION.md` |
| Áudio local final | Planejado | bus gera/aciona sons, mas nenhum recurso de música ou SFX existe |
| Perfiles de qualidade/perf | Implementado (protótipo) | existe perfil/telemetria Kotlin e serviço Godot; sem medições reais de FPS |
| AI Studio como ferramenta principal | Bloqueado/inadequado | limitações atuais e incompatibilidade detalhadas na arquitetura; repo direto é fonte de verdade |
| Kotlin Android build | Testado (host legado) | run `43409376899` passou `:app:assembleDebug` e anexou o APK Kotlin; ele ainda abre o protótipo Aetheria, não o jogo final Anime Nexus |
| Kotlin JUnit | Testado (CI) | `:app:testDebugUnitTest` passou no run `43409376899` |
| Godot test runner | Testado | `ANIME_NEXUS_TESTS: PASS` local em Godot 4.6.3; warnings de recursos em uso ao sair |
| GitHub Actions Godot APK | Testado | APK debug da slice atual exportado e anexado à run `43409376899` |
| GitHub Actions Kotlin APK | Testado (host legado) | APK debug anexado à run `43409376899`; não confundir com uma build jogável de Anime Nexus |

## Barra de aceitação

Só mover uma linha para **Testado** depois de evidência de build correspondente, caminho de UI, comportamento funcional, save e execução sem internet quando aplicável. Capturas/vídeos precisam vir da build instalada; render de editor/conceito não basta.

## Evidência histórica e validação desta revisão

A run `43410319631` é evidência histórica: passou o host Kotlin e o export Godot, sem instalação em aparelho. Na revisão atual, a regra automática executa apenas `android-host`; `godot-android` é manual por causa da compilação nativa longa. O job automático Kotlin não valida scripts Godot, GDExtension ou a integração das reações. Nenhuma execução manual foi disparada nesta revisão.

## Núcleo C++ em andamento

`AnimeNexusCombatCore` e `AnimeNexusQuestCore` foram compilados localmente como biblioteca Linux com Godot C++ bindings `10.0.0-stable` e API 4.7. Ataque básico, ganho de XP, progresso/condições de missões, conclusão, desbloqueio seguinte e cálculo de recompensas usam o núcleo. Testes Godot 4.7.2 locais passaram para dano normal/crítico, pares elementais, XP com carry-over, contagem da missão, não duplicação e recompensas. Ainda não é possível classificar a mudança como APK C++ testado: o workflow com NDK está em preparação e precisa executar a compilação Android arm64 e exportar um APK que carregue a extensão.

## Slice em construção (13 nov. 2026)

Em Godot 4.6.3 local e 4.7.2 no CI: projeto/app identificados como Anime Nexus, orientação landscape, package ID próprio, save local separado, câmera ortográfica diagonal, avatar blockout de Kaien, Nimbara blockout, kit elétrico, quatro criaturas e chefe Cérvido de Cristal. A cadeia testada em regras é: derrotar quatro Musgos Saltadores → derrotar o Cérvido → aproximar-se e interagir com a Âncora. Ataques em área do chefe anunciam a região antes de aplicar dano. `ANIME_NEXUS_TESTS: PASS`, smoke run local sem erros de script, export Godot, testes Kotlin e APK do host passaram na run `43409376899`. Instalação, imagem e touchscreen em aparelho seguem pendentes.
