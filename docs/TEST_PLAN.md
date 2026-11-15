# Plano de testes

## Regras de jogabilidade

- Dano normal/crítico, estados elementais e combinações (em particular condução Trovão+Água e agrupamento por Gravidade).
- Núcleo C++/GDExtension: fórmula de dano e crítico em entradas determinísticas; reações independentes da ordem dos elementos; limiares, carry-over de XP, pontos de habilidade e aumento de atributos; contagem, conclusão e recompensas de missões sem duplicação; sem fallback GDScript silencioso se a biblioteca estiver ausente.
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
- O runner headless também valida recuperação do backup após corromper o JSON principal. Leitura do JSON inválido retorna estado vazio para acionar fallback sem erro ruidoso; alteração local passou em 4.6.3 e aguarda CI.
- Godot 4.6.3 headless: cena principal completou smoke run de 180 frames sem erro de script.
- Android local: build não conseguiu resolver AGP 9.1.1 neste ambiente. No GitHub Actions, a run `43409376899` passou `:app:testDebugUnitTest` e `:app:assembleDebug`.
- CI da revisão `c66eec5`: runner Godot 4.7.2, export Android Godot, testes unitários Kotlin, recuperação do save corrompido e APK do host Kotlin passaram; artifacts publicados na [run 43410319631](https://github.com/reinansantos9090-debug/Anime-Nexus/actions/runs/43410319631). Nenhum APK foi instalado ou testado em aparelho.
- Sem aparelho Android ligado a este ambiente, FPS, toque real, instalação APK e qualidade visual ainda não foram verificados.
- Godot 4.7.2 local carregou `AnimeNexusCombatCore`; GDExtension C++ Linux release compilou e o runner imprimiu `ANIME_NEXUS_TESTS: PASS`, incluindo dano, crítico, reações invertidas e XP acumulado. Restaram apenas avisos conhecidos de recursos em uso ao encerrar.
- O build Android arm64 do núcleo C++ e a exportação do APK com a extensão são pendentes no CI novo; a validação local do APK é bloqueada pela ausência do Android SDK/NDK.


## Validação manual curta da dificuldade

- Executar o runner Godot existente apenas quando for manualmente disparado.
- Conferir que os três perfis C++ retornam multiplicadores esperados e que um identificador desconhecido volta com segurança a Aventura.
- Conferir que a escolha salva sobrevive ao recarregamento e que saves antigos recebem Aventura por padrão.
- Entrar em expedição e observar vida/dano/XP de um inimigo e do chefe em cada perfil; conferir que trocar no meio da expedição é bloqueado.

A verificação Godot/C++/APK continua no workflow manual; nenhum teste de emulador ou job longo será iniciado automaticamente.


## Exploração dos ecos de memória

- Iniciar Ecos no Lago no Observatório e confirmar o diálogo de Liora.
- Percorrer Nimbara, interagir com cada um dos três cristais pálidos e observar 1/3, 2/3 e 3/3.
- Tentar interagir novamente com um cristal sincronizado; o progresso não pode duplicar.
- Sair e recarregar antes da conclusão; as flags locais precisam permanecer salvas.
- Confirmar a recompensa e que a ação de interação desaparece após completar.

Este fluxo requer teste manual no Godot; nenhum job longo/emulador automático será adicionado.


## Oficina de crafting

- Abrir a Oficina pelo terminal no Observatório e conferir nome, materiais exigidos, resultado e estado do botão em cada receita.
- Criar uma receita com materiais suficientes e confirmar que o saldo e o resultado atualizam sem fechar a oficina.
- Tentar criar sem saldo; o botão deve permanecer desabilitado e nenhum item pode ser debitado.
- Voltar a uma expedição; a oficina só pode abrir no Observatório.

- Oficina (runner manual curto): verificar projeto acessível, débito atômico, licença no inventário, desbloqueio no Arsenal e rejeição de duplicação. Na interface, fabricar cada um dos três projetos de instrumento; confirmar custo debitado uma única vez, licença persistida após recarregar o espaço e arma habilitada no Arsenal. Tentar fabricar projeto já concluído e conferir que inventário não muda.

- Suprema Tempestade de Safira (runner manual curto): carga parcial, limite em 100, bloqueio abaixo de 100 e consumo ao ativar. No jogo, ganhar carga com ataques/derrotas, tocar quando cheia, confirmar bônus por 10 s e expiração; confirmar também persistência do medidor no save local.

- HUD horizontal: tocar Arsenal e percorrer somente instrumentos desbloqueados; usar Gadget sem estoque sem alterar inventário; conferir Bolsa e Visuais. Confirmar separação entre os quatro botões e joystick/ataque em 1280×720 e em aparelho.

- Bolsa: abrir em exploração/hub, conferir nomes e quantidades com o inventário persistido, obter um item e confirmar atualização; fechar e voltar sem alteração de saldo.

- Câmera: usar botões de zoom para dentro/fora, conferir limites 14–32, trocar de mapa/reabrir save e verificar que a escala salva permanece; mover e combater nos extremos do zoom.


## Contrato de conteúdo de Vesper (runner manual curto)

- Conferir mapa Vesper, seis IDs de encontro, obstáculos e existência local de toda espécie/material de saque.
- Abrir a expedição Vesper no jogo, verificar a enseada/cais/corais em blockout, spawn e saque offline.
- Confirmar que o mapa continua sendo apenas uma expedição de combate: maré dinâmica, barco, subáreas, chefe e assets finais ainda não estão implementados.

O runner permanece manual e não é iniciado por este trabalho.


## Contrato de conteúdo de Aurélio (runner manual curto)

- Conferir a expedição, seis IDs de criatura, obstáculos, e que todos os itens de saque existem no catálogo offline.
- Abrir Aurélio e conferir marcos de arenito/ruínas e as silhuetas blockout durante encontros; conferir saque sem internet.
- Validar em aparelho quando disponível que os adornos permanecem leves e legíveis; não declarar puzzle temporal, plataforma móvel ou chefe concluído.

O runner Godot segue manual; nenhum teste longo ou emulador será disparado automaticamente.


## Contrato de conteúdo de Ferrúmia (runner manual curto)

- Conferir mapa, seis encontros, obstáculos e resolução local de todos os itens de saque.
- Abrir a expedição e confirmar os trilhos estáticos, torres, engrenagens e blockouts durante o combate offline.
- Não considerar elevadores, trilhos funcionais, máquinas interativas ou chefe implementados.

O runner segue manual; nenhum teste longo/emulador automático foi adicionado ou iniciado.


## Contrato de conteúdo de Ivern (runner manual curto)

- Conferir os seis encontros e toda referência de loot local no catálogo.
- Abrir a expedição Ivern offline, verificar a rota de blockout e distinguir os arcos fixos da aurora como decoração.
- Não considerar vento, pontes dinâmicas, salto entre picos ou chefe concluídos.

Runner Godot é manual; nenhum teste longo/emulador automático foi adicionado ou iniciado.


## Contrato de conteúdo de Umbral (runner manual curto)

- Conferir seis encontros, obstáculos e referências de saque no catálogo local.
- Abrir a expedição offline; painéis são blockout sem reflexos ou troca de geometria.
- Não considerar ilusões interativas, caminhos mutáveis ou chefe implementados.

Runner Godot permanece manual; nenhum teste longo/emulador automático foi adicionado ou iniciado.


## Contrato do Núcleo do Nexo e Arquivo Zero (runner manual curto)

- Conferir seis ecos com dados/saque locais, oito marcadores visuais e a entrada do Arquivo Zero no catálogo.
- Verificar ratios de fase e padrões na definição; testar combate RIFT offline e telegraphs no jogo quando o workflow manual for executado.
- O mapa de expedição não conclui a campanha: âncoras interativas, cenas, escolha narrativa, arena definitiva, áudio e arte final estão pendentes.

Runner e export Godot continuam manuais; nenhum teste longo/emulador foi iniciado.


## Cadeia principal de Nimbara (runner manual curto)

- Conferir a sequência `nimbara_01` a `nimbara_08: Musgos, Faíscas, saque de Flores da Memória, retorno ao mapa, Guardião de Raízes, três ecos, Cérvido e Âncora.
- No jogo, confirmar que o Portal direciona ao mapa exigido e que waves priorizam a criatura ligada ao objetivo kill/collect.
- Confirmar os três ecos individualmente, a entrada RIFT apenas na missão do Cérvido e o retorno ao Observatório após estabilizar a Âncora.
- Conferir o diálogo contextual de conclusão de cada etapa e persistência do progresso offline.

Runner Godot permanece manual; nenhum teste longo/emulador foi iniciado.


### Save local: migração de schema (runner manual)

- Carregar um payload de schema 4 com progresso parcial e campos aninhados com tipos inválidos; confirmar upgrade para schema 8, preservação do ouro e preenchimento dos defaults atuais.
- Confirmar que schema futuro é recusado sem substituir o save suportado nem permitir sobrescrita silenciosa.
- Este cenário é curto, headless e manual; não requer emulador nem workflow longo.


### Diálogos de campanha local (runner manual)

- Avançar as oito linhas do prólogo e confirmar que a cena termina sem repetir texto placeholder e que todas as falas ficam no diário local.
- Encadear conclusão e início de missão enquanto uma fala ainda está aberta; confirmar que os diálogos de Nimbara aparecem um de cada vez, sem substituir uns aos outros.
- Fluxo curto, manual, sem emulador e sem job longo.


### Formação offline ampliada (runner/manual)

- Confirmar no runner que os sete aliados têm dados locais e que o pulso de suporte de Yuna restaura vida e energia quando solicitado.
- No Android, abrir Formação, rolar a lista até Eiko, escolher dois aliados, fechar e reabrir; conferir seleção persistida e limite de dois.
- A validação de rolagem/touch é manual e curta; sem emulador ou job longo automático.
