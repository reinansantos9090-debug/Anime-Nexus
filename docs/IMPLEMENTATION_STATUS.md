# Estado de implementação auditado

Data da auditoria: 13 nov. 2026, branch `dev/anime-nexus-vertical-slice`, base `87e54dc`.

| Sistema alvo | Categoria | Evidência / pendência |
|---|---|---|
| App Android nativo | Implementado (host do protótipo) | Activity Kotlin e manifest; nome/pacote/orientação atuais não são finais |
| OpenGL ES e loop de combate Kotlin | Implementado (protótipo Aetheria) | engine/render/AI/combat/session/HUD em `app/src/main/java/.../game3d`; geometria procedural |
| Godot Android export | Em desenvolvimento | projeto e preset/workflow existem; APK não validado localmente |
| Escolha de Godot para slice | Implementado (decisão documental) | comparar em `TECHNICAL_ARCHITECTURE.md`; reavaliável após APK |
| Câmera isométrica | Planejado | offset atual alto em terceira pessoa; falta ajuste ortográfico/isométrico, zoom e occluder |
| Kaien e sete aliados com modelo anime | Planejado | nenhum mesh/rig final encontrado; avatar atual genérico/procedural |
| Nimbara | Planejado | existe mapa antigo `verdant_frontier`, não a região/missão Anime Nexus |
| Habilidades, inimigos e chefe Anime Nexus | Planejado | existem habilidades/bosses Aetheria; nomes/kit/fases não correspondem |
| Combate e inimigos locais offline | Implementado (protótipo) | serviços Godot/Kotlin integrados no runtime Aetheria; necessita validação de equilíbrio e APK |
| Joystick virtual analógico | Implementado (protótipo) | Godot HUD recebe toque/arraste, produz direção com deadzone e intensidade gradual; regra testada headless, toque em celular pendente |
| Companions com máquina de estados | Planejado | nenhum squad follow/combat completo observado no runtime Godot |
| Campanha principal e secundárias | Planejado | story/quest catalogs Aetheria menores; não há 60+45 Anime Nexus |
| Inventário/equipamentos | Implementado (protótipo) | inventário/wardrobe/crafting Aetheria; slots e catálogo alvo não integram |
| Save offline | Implementado (protótipo) | save Godot single JSON + backup, Kotlin codec; faltam 3 slots, integridade e migração |
| Arte original final | Planejado | só ícones, materiais simples e meshes procedurais; inventário em `ASSET_PRODUCTION.md` |
| Áudio local final | Planejado | bus gera/aciona sons, mas nenhum recurso de música ou SFX existe |
| Perfiles de qualidade/perf | Implementado (protótipo) | existe perfil/telemetria Kotlin e serviço Godot; sem medições reais de FPS |
| AI Studio como ferramenta principal | Bloqueado/inadequado | limitações atuais e incompatibilidade detalhadas na arquitetura; repo direto é fonte de verdade |
| Kotlin JUnit | Bloqueado neste ambiente | dependência AGP 9.1.1 não foi resolvida |
| Godot test runner | Testado | `AETHERIA_TESTS: PASS` local em Godot 4.6.3; warnings ao sair |
| GitHub Actions Android APK | Em desenvolvimento | workflow atual exporta APK Godot, mas CI última run falhou e contém push para `main` em limpeza |

## Barra de aceitação

Só mover uma linha para **Testado** depois de evidência de build correspondente, caminho de UI, comportamento funcional, save e execução sem internet quando aplicável. Capturas/vídeos precisam vir da build instalada; render de editor/conceito não basta.
