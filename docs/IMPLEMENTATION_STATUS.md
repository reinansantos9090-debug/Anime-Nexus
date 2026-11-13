# Estado de implementação auditado

Data da auditoria: 13 nov. 2026, branch `dev/anime-nexus-vertical-slice`, base `87e54dc`.

| Sistema alvo | Categoria | Evidência / pendência |
|---|---|---|
| App Android nativo | Implementado (host do protótipo) | Activity Kotlin e manifest; nome/pacote/orientação atuais não são finais |
| OpenGL ES e loop de combate Kotlin | Implementado (protótipo Aetheria) | engine/render/AI/combat/session/HUD em `app/src/main/java/.../game3d`; geometria procedural |
| Godot Android export | Testado | workflow Godot 4.7.2 validou runner e exportou APK debug atual (run `43405149123`, artifact de 28,2 MB); instalação/touch em aparelho pendentes |
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
| GitHub Actions Godot APK | Testado | APK debug da slice atual exportado e anexado à run `43405149123` |
| GitHub Actions Kotlin APK | Bloqueado | nenhum APK Kotlin publicado enquanto os erros de compilação preexistentes não forem corrigidos |

## Barra de aceitação

Só mover uma linha para **Testado** depois de evidência de build correspondente, caminho de UI, comportamento funcional, save e execução sem internet quando aplicável. Capturas/vídeos precisam vir da build instalada; render de editor/conceito não basta.

## Execução de CI mais recente

Run `43405149123`, commit `28fe83772f958604b3f9e86ff4960cd0e332206c`: job `godot-android` validou os scripts/testes com Godot 4.7.2 e publicou o APK debug anexado à [run 43405149123](https://github.com/reinansantos9090-debug/Anime-Nexus/actions/runs/43405149123) (28,2 MB). Não foi instalado em aparelho. Job `android-host` falhou em `:app:compileDebugKotlin` com os mesmos 155 erros em 10 arquivos Kotlin preexistentes; não gerou APK Kotlin.

## Slice em construção (13 nov. 2026)

Em Godot 4.6.3 local e 4.7.2 no CI: projeto/app identificados como Anime Nexus, orientação landscape, package ID próprio, save local separado, câmera ortográfica diagonal, avatar blockout de Kaien, Nimbara blockout, kit elétrico, quatro criaturas e chefe Cérvido de Cristal. A cadeia testada em regras é: derrotar quatro Musgos Saltadores → derrotar o Cérvido → aproximar-se e interagir com a Âncora. `ANIME_NEXUS_TESTS: PASS`, smoke run local sem erros de script e export CI atual passaram. Instalação, imagem e touchscreen em aparelho seguem pendentes.
