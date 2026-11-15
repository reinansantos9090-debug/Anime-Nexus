# Estado de implementação auditado

Data da auditoria: 15 nov. 2026, branch `dev/anime-nexus-vertical-slice`.

| Sistema alvo | Categoria | Evidência / pendência |
|---|---|---|
| C++ como linguagem principal do jogo | Em desenvolvimento | GDExtensions `AnimeNexusCombatCore` e `AnimeNexusQuestCore` já são chamadas pelo ataque básico, progressão de XP/nível e ciclo de progresso/conclusão/recompensa de missões. A tabela C++ já é consultada nos ataques e habilidades do jogador e fornece multiplicadores e parâmetros numéricos para condução, expansão de área, lentidão, cura, eco e atração; GDScript só os aplica aos nós e efeitos locais. Uma regressão curta foi adicionada ao runner Godot; ela ainda aguarda execução manual e não é validada pelo job Android Kotlin. Linux release compilado localmente; Godot 4.7.2 headless passou testes. Android arm64 ainda aguarda CI; IA, economia, equipamentos e save estão parcialmente migrados: loot, crafting atômico e regra da primeira suprema usam C++, enquanto a orquestração do runtime ainda passa por GDScript. |
| GDScript | Implementado (camada de integração) | Atualmente conecta cenas, UI, nós, sinais e chamadas do núcleo nativo. Parte da lógica de jogo ainda reside nos serviços GDScript e deve migrar antes de declarar C++ como fonte autoritativa de todos os subsistemas. |
| App Android nativo | Implementado (host do protótipo) | Activity Kotlin e manifest; nome/pacote/orientação atuais não são finais |
| OpenGL ES e loop de combate Kotlin | Implementado (protótipo Aetheria) | engine/render/AI/combat/session/HUD em `app/src/main/java/.../game3d`; geometria procedural |
| Godot Android export | Testado em revisão anterior | workflow Godot 4.7.2 exportou APK da slice em run `43409376899`; o workflow longo atual é manual e ainda não foi executado para esta integração |
| Godot + GDExtension C++ | Em desenvolvimento | Godot mantém renderer/cenas/física; C++17 é o domínio autoritativo em migração. A arquitetura e funções iniciais estão em `CPP_GAMEPLAY_ARCHITECTURE.md`; falta CI Android/arm64 e migração dos demais domínios. |
| Shader de terreno por bioma | Em desenvolvimento | Shader spatial local com ruído de duas escalas e diffuse toon aplicado ao piso dos biomas, com paleta derivada dos dados locais; performance e leitura visual ainda aguardam exportação/teste manual em Android. |
| Câmera isométrica | Em desenvolvimento | câmera ortográfica diagonal com acompanhamento suave; HUD ganha botões de zoom local, escala limitada de 14–32 e valor salvo no espaço ativo; ocultação de obstáculos e teste visual/touch em aparelho pendentes |
| Kaien | Em desenvolvimento | avatar procedural blockout com cores, cabelo e manoplas distintivos; sem modelo anime final, rig/skinning ou animações de produção |
| Sete aliados | Planejado | nenhum personagem Anime Nexus produzido no runtime |
| Nimbara | Em desenvolvimento | mapa 3D blockout com trilha, árvores, raízes, cristais e âncora; sem subáreas e arte final |
| Suprema Tempestade de Safira (Kaien) | Em desenvolvimento | Medidor C++ carrega com dano e derrotas; botão HUD ativa por 10 s, +35% de dano e cooldown de especiais ×0,68; runner curto cobre clamp/consumo/negação. Integração no jogo, anéis de aura locais e VFX reutilizados; validação Godot manual e forma/modelo/animação/áudio próprios pendentes. |
| Habilidades, inimigos e chefe Anime Nexus | Em desenvolvimento | três efeitos de Kaien, inimigos de Nimbara e Cérvido de Cristal integrados ao protótipo; telegraph circular para ataques em área com resolução atrasada testado, mas legibilidade em aparelho, outros padrões, arena e animações finais pendentes |
| Combate e inimigos locais offline | Em desenvolvimento | combate da slice Godot tem ataques, habilidades, afinidades e reações locais; integração C++/Godot aguarda validação manual e APK Godot atual |
| Joystick virtual analógico | Implementado (protótipo) | Godot HUD recebe toque/arraste, produz direção com deadzone e intensidade gradual; regra testada headless, toque em celular pendente |
| Missão da slice | Em desenvolvimento | cadeia de missão, chefe e interação por proximidade da Âncora; regras de avanço testadas, fluxo de toque em aparelho pendente |
| Prólogo narrativo original de Anime Nexus | Em desenvolvimento | Cena de abertura em português com Kaien, Akari, Ren, Iori, Meka e Pia; linhas registradas no diário local; runner curto cobre elenco, persistência e ausência da lore antiga; aguarda execução Godot manual. |
| Missão secundária Ecos no Lago | Em desenvolvimento | Três cristais de memória posicionados pelos dados de Nimbara; interação próxima, flags locais contra duplicação, progresso C++ da missão e recompensa offline; regressão curta cobre catálogo e objetivo, interação visual aguarda execução Godot manual. |
| Missão secundária Sementes para Liora | Em desenvolvimento | Disponível no terminal do Observatório; progresso collect acompanha o pólen real recebido no saque; conversa inicial/final e recompensa local integradas; regressão curta adicionada ao runner, aguarda execução Godot manual. |
| Oficina acessível no Observatório | Em desenvolvimento | Tela local lista receitas, custos, resultados e habilita criar apenas com materiais suficientes; usa crafting atômico C++ e atualiza inventário; validação visual/manual pendente. |
| Instrumentos criáveis da Oficina | Em desenvolvimento | Projetos de Lâminas Voltaicas, Arco Tóxico e Canhão Pulsar criam licenças locais únicas; licença persistida no inventário desbloqueia a arma no ciclo do Arsenal. Regressão curta de custo, licença, desbloqueio e duplicação adicionada ao runner manual; validação de fluxo Godot pendente. |
| Criação atômica de itens | Em desenvolvimento | `apply_craft` no C++ valida todos os custos e resultados antes de retornar um inventário novo; `InventoryService` aplica o resultado numa única substituição e emite sinais uma vez; regressão de falha sem perda e sucesso adicionada ao runner manual. |
| Saque e economia básica | Em desenvolvimento | C++ resolve raridade, item, quantidade, ouro e bônus de nível/evento; GDScript alimenta RNG local e integra ao inventário; regressão determinística curta adicionada, ainda aguarda runner Godot manual. |
| Dificuldade offline | Em desenvolvimento | Perfis Casual/Aventura/Desafio são calculados no C++ e persistidos no save; aplicados a vida, dano recebido e XP de inimigos/chefes; seletor no Observatório; regressão determinística curta adicionada ao runner, aguarda execução Godot manual. |
| Companions com máquina de estados | Em desenvolvimento | Akari e Ren, blockouts procedurais, seguem Kaien, usam decisões C++ para follow/regroup/guard/attack e aplicam dano/controle offline; seleção offline e ordens auto/seguir/recuar integradas ao menu; desvio local por raycast e política de direção em C++ agora implementados; navegação global por navmesh, comportamento específico de chefe e modelos/animações finais pendentes; regressões curtas de decisão, desvio e configuração adicionadas ao runner, aguardam execução Godot manual |
| Campanha principal e secundárias | Planejado | story/quest catalogs Aetheria menores; não há 60+45 Anime Nexus |
| Inventário/equipamentos | Em desenvolvimento | Tela Bolsa lista itens e ouro do save; HUD expõe Arsenal, gadget e visuais. Oficina/crafting atômico e três licenças únicas destravam instrumentos, com regressão curta no runner manual. Comparação detalhada de atributos, slots, 24 instrumentos, mecanismos, runas, relíquias, árvore e atributos finais ainda não integram; toque aguarda validação Godot manual. |
| Save offline | Em desenvolvimento | progresso local com backup e recuperação já existe; três espaços com carregar/salvar e confirmação de sobrescrita integrados ao menu; teste curto de isolamento entre slots e gravação temporária validada adicionado, aguarda execução Godot manual; migração entre versões permanece pendente |
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

