# Plano de testes

## Regras de jogabilidade

- Dano normal/crítico, estados elementais e combinações (em particular condução Trovão+Água e agrupamento por Gravidade).
- Cooldowns, energia, esquiva invulnerável e telegraph/recuperação dos chefes.
- IA: todos estados permitidos, retorno à região inicial, companion que recupera caminho e nunca causa dano a aliado.
- Objetivos de missão: contagem, conclusão única, pré-requisitos, recompensa e save sem duplicação.
- Crafting: verificar todos os materiais antes de debitar, débito único e rollback se criação falhar.
- Progressão: XP em limiar exato/múltiplo, limites, migração e desbloqueios.

## Conteúdo

- Validar unicidade de IDs, links de missão, desbloqueio dos oito mundos, boss/map/region e integridade de falas, materiais e recompensas.
- Cobrir missão iniciada, interrompida, retomada e concluída; textos e legendas em `pt-BR`.
- Assert de todos os assets listados no manifest com origem/licença e caminho existente.

## Plataforma e experiência

- `godot --headless --editor --quit --path godot`, runner headless, export debug Android e teste de instalação.
- Gradle unit tests e assemble do host Android enquanto existir.
- Testar landscape, diferentes proporções, safe areas, toque simultâneo, pause/resume, teclado e back.
- Aparelhos baixo/médio/alto: frame time p50/p95, memória GPU/CPU, temperatura, carregamento, draw calls, quedas ao abrir menus e ao lutar.
- Modo avião: início, jogo, saves, reabertura, áudio e conclusão.
- Capturas/vídeos de cena real para avaliação de arte, leitura dos telegraphs e HUD; mockups não contam.

## Evidência inicial

- Godot 4.6.3 headless: import passou; runner atual imprimiu `ANIME_NEXUS_TESTS: PASS`, incluindo dados/avanço da missão Nimbara, chefe, interação da Âncora e aviso do telegraph antes do dano; restam avisos de recursos em uso ao encerrar.
- Godot 4.6.3 headless: cena principal completou smoke run de 180 frames sem erro de script.
- Android local: build não conseguiu resolver AGP 9.1.1 neste ambiente. No GitHub Actions, a run `43409376899` passou `:app:testDebugUnitTest` e `:app:assembleDebug`.
- CI da revisão `065f1fd`: runner Godot 4.7.2, export Android Godot, testes unitários Kotlin e APK do host Kotlin passaram; artifacts publicados na [run 43409376899](https://github.com/reinansantos9090-debug/Anime-Nexus/actions/runs/43409376899). Nenhum APK foi instalado ou testado em aparelho.
- Sem aparelho Android ligado a este ambiente, FPS, toque real, instalação APK e qualidade visual ainda não foram verificados.
