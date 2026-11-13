# Estado de implementação auditado

Data da auditoria: 13 nov. 2026, branch `dev/anime-nexus-vertical-slice`, base `87e54dc`.

| Sistema alvo | Categoria | Evidência / pendência |
|---|---|---|
| App Android nativo | Implementado (host do protótipo) | Activity Kotlin e manifest; nome/pacote/orientação atuais não são finais |
| OpenGL ES e loop de combate Kotlin | Implementado (protótipo Aetheria) | engine/render/AI/combat/session/HUD em `app/src/main/java/.../game3d`; geometria procedural |
| Godot Android export | Testado | workflow Godot 4.7.2 exportou APK debug no CI (run `43399588726`); o código de runtime mudou desde essa execução, então aguarda nova exportação/instalação |
| Escolha de Godot para slice | Implementado (decisão documental) | comparar em `TECHNICAL_ARCHITECTURE.md`; reavaliável após APK |
| Câmera isométrica | Implementado (protótipo) | câmera ortográfica diagonal com acompanhamento suave; zoom, ocultação de obstáculos e teste visual em aparelho pendentes |
| Kaien | Em desenvolvimento | avatar procedural blockout com cores, cabelo e manoplas distintivos; sem modelo anime final, rig/skinning ou animações de produção |
| Sete aliados | Planejado | nenhum personagem Anime Nexus produzido no runtime |
| Nimbara | Em desenvolvimento | mapa 3D blockout com trilha, árvores, raízes, cristais e âncora; sem subáreas e arte final |
| Habilidades, inimigos e chefe Anime Nexus | Em desenvolvimento | três efeitos de Kaien, inimigos de Nimbara e Cérvido de Cristal integrados ao protótipo; telegraphs visuais/arena e animações finais pendentes |
| Combate e inimigos locais offline | Implementado (protótipo) | serviços Godot/Kotlin integrados no runtime Aetheria; necessita validação de equilíbrio e APK |
| Joystick virtual analógico | Implementado (protótipo) | Godot HUD recebe toque/arraste, produz direção com deadzone e intensidade gradual; regra testada headless, toque em celular pendente |
| Missão da slice | Em desenvolvimento | cadeia de missão, chefe e interação por proximidade da Âncora; regras de avanço testadas, fluxo de toque em aparelho pendente |
| Companions com máquina de estados | Planejado | nenhum squad follow/combat completo observado no runtime Godot |
| Campanha principal e secundárias | Planejado | story/quest catalogs Aetheria menores; não há 60+45 Anime Nexus |
| Inventário/equipamentos | Implementado (protótipo) | inventário/wardrobe/crafting Aetheria; slots e catálogo alvo não integram |
| Save offline | Implementado (protótipo) | save Godot single JSON + backup, Kotlin codec; faltam 3 slots, integridade e migração |
| Arte original final | Planejado | só ícones, materiais simples e meshes procedurais; inventário em `ASSET_PRODUCTION.md` |
| Áudio local final | Planejado | bus gera/aciona sons, mas nenhum recurso de música ou SFX existe |
| Perfiles de qualidade/perf | Implementado (protótipo) | existe perfil/telemetria Kotlin e serviço Godot; sem medições reais de FPS |
| AI Studio como ferramenta principal | Bloqueado/inadequado | limitações atuais e incompatibilidade detalhadas na arquitetura; repo direto é fonte de verdade |
| Kotlin Android build | Bloqueado | CI com AGP 9.1.1 chegou à compilação Kotlin e encontrou 155 erros em 10 arquivos preexistentes do protótipo (`Game3DEngine*`, `Game3DModels`, `GameHUDView`, `GameRenderer`, `OfflineHistoryArchive`, `OfflineHunterDirector`, `OfflineMapRuntime`, `OfflineRooftopController`); inclui sintaxe inválida e tipos/referências ausentes |
| Kotlin JUnit | Bloqueado | testes não iniciam porque `:app:compileDebugKotlin` falha antes |
| Godot test runner | Testado | `ANIME_NEXUS_TESTS: PASS` local em Godot 4.6.3; warnings de recursos em uso ao sair |
| GitHub Actions Godot APK | Testado | APK debug exportado e artifact anexado à run `43399588726` |
| GitHub Actions Kotlin APK | Bloqueado | nenhum APK Kotlin publicado enquanto os erros de compilação preexistentes não forem corrigidos |

## Barra de aceitação

Só mover uma linha para **Testado** depois de evidência de build correspondente, caminho de UI, comportamento funcional, save e execução sem internet quando aplicável. Capturas/vídeos precisam vir da build instalada; render de editor/conceito não basta.

## Execução de CI mais recente

Run `43399588726`, commit `e6fc413457aec00a8d3540077b0173a3e379c92c`: Godot 4.7.2 exportou um APK do protótipo anterior ao fluxo Anime Nexus em desenvolvimento; não validar esse APK como a slice atual. `android-host` falhou em `:app:compileDebugKotlin`; o job reportou 155 erros em 10 arquivos Kotlin, incluindo falhas sintáticas em `OfflineHistoryArchive.kt` e `OfflineMapRuntime.kt`, além de referências ausentes. A nova alteração do slice ainda precisa passar na CI 4.7.2 e não comprova instalação nem execução em aparelho.

## Slice em construção (13 nov. 2026)

Em Godot 4.6.3 local: projeto/app identificados como Anime Nexus, orientação landscape, package ID próprio, save local separado, câmera ortográfica diagonal, avatar blockout de Kaien, Nimbara blockout, kit elétrico, quatro criaturas e chefe Cérvido de Cristal. A cadeia testável é: derrotar quatro Musgos Saltadores → derrotar o Cérvido → aproximar-se e interagir com a Âncora. `ANIME_NEXUS_TESTS: PASS` e smoke run headless sem erros de script. O export APK da versão atual e a validação visual/touchscreen em dispositivo aguardam CI e aparelho.
