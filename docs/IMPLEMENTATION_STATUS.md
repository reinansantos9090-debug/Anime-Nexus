# Estado de implementação auditado

Data da auditoria: 13 nov. 2026, branch `dev/anime-nexus-vertical-slice`, base `87e54dc`.

| Sistema alvo | Categoria | Evidência / pendência |
|---|---|---|
| App Android nativo | Implementado (host do protótipo) | Activity Kotlin e manifest; nome/pacote/orientação atuais não são finais |
| OpenGL ES e loop de combate Kotlin | Implementado (protótipo Aetheria) | engine/render/AI/combat/session/HUD em `app/src/main/java/.../game3d`; geometria procedural |
| Godot Android export | Testado | workflow Godot 4.7.2 validou runner e exportou APK debug da slice (run `43409376899`); instalação/touch em aparelho pendentes |
| Escolha de Godot para slice | Implementado (decisão documental) | comparar em `TECHNICAL_ARCHITECTURE.md`; reavaliável após APK |
| Câmera isométrica | Implementado (protótipo) | câmera ortográfica diagonal com acompanhamento suave; zoom, ocultação de obstáculos e teste visual em aparelho pendentes |
| Kaien | Em desenvolvimento | avatar procedural blockout com cores, cabelo e manoplas distintivos; sem modelo anime final, rig/skinning ou animações de produção |
| Sete aliados | Planejado | nenhum personagem Anime Nexus produzido no runtime |
| Nimbara | Em desenvolvimento | mapa 3D blockout com trilha, árvores, raízes, cristais e âncora; sem subáreas e arte final |
| Habilidades, inimigos e chefe Anime Nexus | Em desenvolvimento | três efeitos de Kaien, inimigos de Nimbara e Cérvido de Cristal integrados ao protótipo; telegraph circular para ataques em área com resolução atrasada testado, mas legibilidade em aparelho, outros padrões, arena e animações finais pendentes |
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
| Kotlin Android build | Testado (host legado) | run `43409376899` passou `:app:assembleDebug` e anexou o APK Kotlin; ele ainda abre o protótipo Aetheria, não o jogo final Anime Nexus |
| Kotlin JUnit | Testado (CI) | `:app:testDebugUnitTest` passou no run `43409376899` |
| Godot test runner | Testado | `ANIME_NEXUS_TESTS: PASS` local em Godot 4.6.3; warnings de recursos em uso ao sair |
| GitHub Actions Godot APK | Testado | APK debug da slice atual exportado e anexado à run `43409376899` |
| GitHub Actions Kotlin APK | Testado (host legado) | APK debug anexado à run `43409376899`; não confundir com uma build jogável de Anime Nexus |

## Barra de aceitação

Só mover uma linha para **Testado** depois de evidência de build correspondente, caminho de UI, comportamento funcional, save e execução sem internet quando aplicável. Capturas/vídeos precisam vir da build instalada; render de editor/conceito não basta.

## Execução de CI mais recente

Run `43409376899`, commit `065f1fdea09ef12c1dc2235e9b750b23809b524c`: `android-host` passou unit tests e `assembleDebug`, e `godot-android` passou validação e export Android; artifacts dos dois APKs estão na [execução 43409376899](https://github.com/reinansantos9090-debug/Anime-Nexus/actions/runs/43409376899). APKs não foram instalados em aparelho. O APK Godot é a slice Anime Nexus em blockout; o APK Kotlin é o protótipo Aetheria legado.

## Slice em construção (13 nov. 2026)

Em Godot 4.6.3 local e 4.7.2 no CI: projeto/app identificados como Anime Nexus, orientação landscape, package ID próprio, save local separado, câmera ortográfica diagonal, avatar blockout de Kaien, Nimbara blockout, kit elétrico, quatro criaturas e chefe Cérvido de Cristal. A cadeia testada em regras é: derrotar quatro Musgos Saltadores → derrotar o Cérvido → aproximar-se e interagir com a Âncora. Ataques em área do chefe anunciam a região antes de aplicar dano. `ANIME_NEXUS_TESTS: PASS`, smoke run local sem erros de script, export Godot, testes Kotlin e APK do host passaram na run `43409376899`. Instalação, imagem e touchscreen em aparelho seguem pendentes.
