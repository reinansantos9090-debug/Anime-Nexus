# Inventário de produção de assets

**Estado de auditoria:** não há modelos/áudio finais. O primeiro slice agora usa blockouts procedurais originais para Kaien, Nimbara, algumas criaturas, Cérvido e Âncora. Esses meshes são provisórios e não satisfazem os requisitos de arte final. Demais recursos permanecem **Planejados**. Registrar autor, ferramenta, arquivo-fonte e licença antes de integrar; nenhum arquivo extraído de jogo comercial.

| ID | Finalidade e associação | Descrição visual / paleta | Especificação / materiais | Animações exigidas | Estado / origem |
|---|---|---|---|---|---|
| CH-KAIEN | Protagonista Kaien, slice e campanha | Jovem anime; azul-marinho/ciano/âmbar; casaco assimétrico e manoplas | glTF/GLB, rig humanoide, 12–20k tris LOD0 / 5–8k LOD1; 1K albedo/normal/ORM atlas | idle, run, combo 3, dodge, 3 skills, hit, victory, supreme | Blockout procedural integrado; arte final planejada; original |
| CH-AKARI | Akari, combate de chama | cobre/vermelho/ouro, lenço distintivo | mesmo pipeline humanoide modular; peças de lenço separadas | idle/run, combo, 3 skills, esquiva, hit, suprema | Planejado; original |
| CH-REN | Ren, vento | prata/turquesa/verde, ornamentos flutuantes | rig humanoide leve, acessórios com bones secundários | idle/run, combo, salto, vento, esquiva, suprema | Planejado; original |
| CH-MIRA | Mira, gelo | lilás/azul-pérola, prismas geométricos | rig humanoide; adornos transparentes separados | idle/run, combo, barreira, gelo, hit, suprema | Planejado; original |
| CH-YUNA | Yuna, lunar | violeta/branco/azul-noite, estrelas orbitais | rig humanoide; órbitas sem simulação física cara | idle/run, combo, cura, escudo, suprema, reação | Planejado; original |
| CH-SHIN | Shin, sombra | grafite/preto/violeta, tecido distorcido | rig humanoide; material dissolve controlável | idle/run, combo, duplicata, teleporte, hit, suprema | Planejado; original |
| CH-HARU | Haru, natureza | verde-musgo, folhas, bolsa botânica | rig humanoide; espíritos-companion como assets separados | idle/run, combo, raízes, cura, invocação, suprema | Planejado; original |
| CH-EIKO | Eiko, gravidade | índigo/rosa/azul, aros cósmicos | rig humanoide, rings separados e emissivo controlado | idle/run, combo, pull/push, campo, suprema | Planejado; original |
| BOSS-CERVO | Chefe de Nimbara | espírito cervídeo de cristal verde/violeta | criatura 25–40k tris LOD0; carapaça segmentada, cristal emissivo | idle, investida, stomp, cristal, stun, fase 2, derrota | Blockout procedural com IA/fases genéricas integrado; modelo/animações finais planejados; original |
| BOSS-ESFINGE | Chefe Aurélio | esfinge de vidro dourado/coral | 30–45k tris LOD0, material facetado não transparente caro | voo/andar, feixe refletido, miragem, fase 2, hit/death | Planejado; original |
| BOSS-MARES | Chefe Vesper | guardiã anfíbia azul/coral/perolada | 30–45k tris, nadadeiras e material de água estilizada | onda, mergulho, mudança de maré, fase 2 | Planejado; original |
| BOSS-COLOSSO | Chefe Ferrúmia | corpo mecânico cobre/coral/azul elétrico | 35–50k tris modular; placas e bobinas separadas | marcha, varredura, trilho, quebra de placa, fase 2 | Planejado; original |
| BOSS-MONARCA | Chefe Ivern | monarca de geada pérola/lilás/dourado | 30–45k tris, capa/ornamentos congelados | rajada, ring attack, cristal de calor, fase 2 | Planejado; original |
| BOSS-ARQUIVISTA | Chefe Umbral | entidade de espelho/prata/violeta | 30–45k tris, peças refletivas com material mobile | cópia de golpe, troca de alvo, fase 2, quebra do espelho | Planejado; original |
| BOSS-ZERO | Chefe final | arquivo geométrico abstrato e silhueta humanoide original | 40–60k tris LOD0, shaders simples e pequenos módulos intercambiáveis | 3 fases, estase, salas/memórias, transição, resolução | Planejado; original |
| BOSS-PRISMA | Chefe secreto | prisma primordial policromático | 40–60k tris, cores em emissive seletivo | ataques que combinam 8 tons, 2+ fases | Planejado; original |
| EN-NIMBARA | 6 inimigos da floresta | musgo, faísca foliar, mariposa, besouro, cipó e guardião | cada rig 4–18k tris, materiais por espécie | locomoção, ataque, reação, recuo, derrota | Quatro inimigos com meshes/IA blockout integrados; faltam dois e os assets finais; original |
| EN-AURELIO | 6 inimigos do deserto | cristal, escaravelho, miragem, vigia, ampulheta e guardião | mesma faixa modular, silhuetas distintas | movimento, ataque, telegraph, retorno | Planejado; original |
| EN-VESPER | 6 inimigos costeiros | bolha, coral, água-viva, caranguejo, onda e sentinela | rigs pequenos, água não exige transparência em toda peça | ricochete, onda, guarda, mergulho | Planejado; original |
| EN-FERRUMIA | 6 inimigos mecânicos | drone, engrenagem, sentinela, autômato, magnético e núcleo | peças reutilizáveis em atlas sem reutilizar silhueta completa | patrulha, tiro, montagem, stagger | Planejado; original |
| EN-IVERN | 6 inimigos de geada | floco, raposa, cristal, nevasca, guardião e sentinela | rig de criatura e partículas limitadas | pulo, névoa, ataque vertical, retorno | Planejado; original |
| EN-UMBRAL | 6 inimigos de reflexo | eco, borboleta, espelho, sombra, ilusão e vigia | mesh leve; dissolve/duplicata por shader | invisibilidade curta e leitura de pista | Planejado; original |
| EN-NEXO | ecos de cada região | variações narrativas locais dos inimigos aprovados | combinações de material e comportamento; não só troca de cor | ataques combinados e reações próprias | Planejado; original |
| ENV-OBSERVATORIO | hub principal | pedra suspensa, vidro astral, luz de portal azul | 1 cena modular, 3 setores visíveis, LOD/occlusion | bandeiras, portal, NPCs, luz narrativa | Blockout do hub reutilizado; arte final e áreas funcionais planejadas; original |
| ENV-NIMBARA | floresta e três subáreas | folhagem verde, bioluminescência turquesa/violeta | kits de árvore, raiz, ruína, lago e trilha; atlas 2K por região | vento/folha/água em ciclos baratos | Blockout da clareira com trilha, árvores, raízes, cristais e Âncora; subáreas e arte final planejadas; original |
| ENV-AURELIO | deserto/templo/oásis | duna dourada, pedra coral, céu violeta | módulos de ruína e plataforma; terreno com rota | poeira, mecanismo, faixa de calor | Planejado; original |
| ENV-VESPER | porto/ilhas/caverna | água cobalto, coral, pontes de luz | kit de costa, cavernas, skiff e farol | maré, água, barco e ponte | Planejado; original |
| ENV-FERRUMIA | cidade/trilhos/torre | cobre, magenta, azul elétrico | kit modular, plataformas, elevadores e cabos | trilhos/elevadores e máquinas | Planejado; original |
| ENV-IVERN | vale/templo/picos | neve pérola, aurora lilás/dourada | terreno, cristais e pontes; material neve mobile | neve leve, corrente de vento e aurora | Planejado; original |
| ENV-UMBRAL | jardim/galeria/palácio | violeta profundo, rosa, prata | módulos duplicáveis com variantes de rota | transição de geometria discreta | Planejado; original |
| ENV-NUCLEO | ponte/salão/coração | mistura de paletas sem perder legibilidade | kit modular com pontos de âncora e arenas boss | transições de fase e fragmentos | Planejado; original |
| UI-KIT | HUD/menu/inventário/oficina/mapa | ornamentos próprios de constelação, borda e ícones elementais | SVG/vector ou texturas 9-slice escaláveis; fonte legível licenciada | estados hover/touch/cooldown/quest | Planejado; original/licença documentada |
| VFX-KIT | habilidades e estados | trilhas distintas para 8 ressonâncias | partículas agrupadas, atlas e materiais mobile | hit, dash, campo, cura, escudo, reação, suprema, boss | Planejado; original |
| AUDIO-MUSIC-01…20 | 20 temas curtos adaptativos | orquestra leve + eletrônica, instrumentos regionais | OGG local, stem/loops sem corte audível; direitos documentados | menu, hub, 8 regiões, exploração, combate, bosses, transformação, final, epílogo | Planejado; composição original |
| AUDIO-SFX | UI, passos, portal, criaturas, armas, poderes e reações | identidade sonora por ressonância | WAV fonte + OGG/Opus importado, mono/stereo por uso | variações aleatórias sem repetir rápido | Planejado; gravação/síntese original |

## Subinventário de criaturas, mascotes e transporte

Cada linha corresponde a um modelo distinto. Especificação comum: GLB com LOD0 4–18k tris para criatura comum e 1K atlas; rig/esqueleto e materiais próprios da espécie; clips `idle`, `move`, `attack`, `telegraph`, `hit`, `recover` e `defeat` conforme papel; origin/licença original registrada. Bosses e personagens têm especificação superior na tabela principal.

| Asset | Papel / desenho / paleta | Região | Estado e origem |
|---|---|---|---|
| EN-NIM-MUSGO | Musgo Saltador; esfera foliar baixa, pernas elásticas, verde-lima e turquesa | Nimbara | Planejado; original |
| EN-NIM-FAISCA | Faísca Foliar; criatura semente com pétalas carregadas, verde/âmbar/ciano | Nimbara | Planejado; original |
| EN-NIM-MARIPOSA | Mariposa Prismal; asas grandes facetadas, violeta/rosa/azul | Nimbara | Planejado; original |
| EN-NIM-BESOURO | Besouro Safira; carapaça arredondada com placas, azul-cobalto/prata | Nimbara | Planejado; original |
| EN-NIM-CIPO | Cipó Ecoante; corpo de videira articulada com flores, verde-escuro/violeta | Nimbara | Planejado; original |
| EN-NIM-GUARDIAO | Guardião de Raízes; tronco móvel de raízes e cristais, madeira/verde/âmbar | Nimbara | Planejado; original |
| EN-AUR-CRISTAL | Cristal Errante; prisma flutuante com fendas luminosas, ouro/coral | Aurélio | Planejado; original |
| EN-AUR-ESCARAVELHO | Escaravelho Solar; casco em disco solar e pernas rápidas, âmbar/azul-noturno | Aurélio | Planejado; original |
| EN-AUR-MIRAGEM | Miragem Duplicadora; silhueta de vidro arenoso com núcleo duplo, coral/violeta | Aurélio | Planejado; original |
| EN-AUR-VIGIA | Vigia das Dunas; manto de areia e lança de cristal, dourado/índigo | Aurélio | Planejado; original |
| EN-AUR-AMPULHETA | Espírito da Ampulheta; corpo de areia em espiral, cobre/roxo | Aurélio | Planejado; original |
| EN-AUR-GUARDIAO | Guardião do Oásis; massa de pedra e raízes aquáticas, turquesa/dourado | Aurélio | Planejado; original |
| EN-VES-BOLHA | Bolha Saltitante; corpo translúcido estilizado e anéis de espuma, azul/coral | Vesper | Planejado; original |
| EN-VES-CORAL | Coral Errante; colônia que anda sobre ramificações, coral/creme | Vesper | Planejado; original |
| EN-VES-AGUAVIVA | Água-Viva Astral; sino flutuante com pontos luminosos, cobalto/rosa | Vesper | Planejado; original |
| EN-VES-CARANGUEJO | Caranguejo de Pérolas; pinças-prisma e casco perolado, marinho/prata | Vesper | Planejado; original |
| EN-VES-ESPIRITO | Espírito das Ondas; figura longa formada por fita de maré, verde-mar/ciano | Vesper | Planejado; original |
| EN-VES-SENTINELA | Sentinela Abissal; guardião de casco profundo, azul-escuro/coral | Vesper | Planejado; original |
| EN-FER-DRONE | Drone Prismático; corpo geométrico com lente frontal, cobre/magenta | Ferrúmia | Planejado; original |
| EN-FER-ENGRENAGEM | Engrenagem Viva; aro dentado com núcleo animado, aço/ciano | Ferrúmia | Planejado; original |
| EN-FER-SENTINELA | Sentinela de Cobre; autômato com escudo-placa, cobre/azul | Ferrúmia | Planejado; original |
| EN-FER-AUTOMATO | Autômato Instável; corpo modular com peça fora de eixo, violeta/âmbar | Ferrúmia | Planejado; original |
| EN-FER-MAGNETICO | Guardião Magnético; armadura suspensa por polos, azul-elétrico/ferro | Ferrúmia | Planejado; original |
| EN-FER-NUCLEO | Núcleo Mecânico; esfera cercada de braços articulados, magenta/cobre | Ferrúmia | Planejado; original |
| EN-IVE-FLOCO | Floco Vivente; criatura pequena cristalina com núcleo, pérola/lilás | Ivern | Planejado; original |
| EN-IVE-RAPOSA | Raposa Boreal; quadrúpede de cauda luminosa, branca/azul-gelo/ouro | Ivern | Planejado; original |
| EN-IVE-CRISTAL | Cristal Errático; prismas partidos em órbita, azul-gelo/violeta | Ivern | Planejado; original |
| EN-IVE-NEVASCA | Espírito da Nevasca; véu circular de neve e olhos luminosos, branco/azul | Ivern | Planejado; original |
| EN-IVE-GUARDIAO | Guardião de Geada; cavaleiro compacto de gelo lapidado, pérola/dourado | Ivern | Planejado; original |
| EN-IVE-SENTINELA | Sentinela da Aurora; forma alta com coroa luminosa, lilás/verde-aurora | Ivern | Planejado; original |
| EN-UMB-ECO | Eco Sem Forma; fita de sombra com rosto incompleto, violeta/prata | Umbral | Planejado; original |
| EN-UMB-BORBOLETA | Borboleta do Eclipse; asas assimétricas com disco escuro, rosa/índigo | Umbral | Planejado; original |
| EN-UMB-GUARDIAO | Guardião do Espelho; torso facetado e máscara lisa, prata/violeta | Umbral | Planejado; original |
| EN-UMB-SOMBRA | Sombra Fragmentada; corpo que se divide em placas, azul-noite/rosa | Umbral | Planejado; original |
| EN-UMB-ILUSAO | Ilusão Errante; contorno deslocado com rastros, lilás/azul | Umbral | Planejado; original |
| EN-UMB-VIGIA | Vigia do Silêncio; figura fina com halo fechado, grafite/prata | Umbral | Planejado; original |
| PET-MARIPOSA | Mascote que marca recurso próximo; pequena lanterna com asas prismáticas | Desbloqueio de quest | Planejado; original |
| PET-MUSGUINHO | Mascote que aponta recurso comum; broto redondo verde/ciano | Desbloqueio de quest | Planejado; original |
| PET-BOLHA | Mascote que absorve um empurrão; bolha coral com núcleo | Desbloqueio de quest | Planejado; original |
| PET-RAPOSA | Mascote que sinaliza rotas; filhote boreal azul e pérola | Desbloqueio de quest | Planejado; original |
| PET-ENGRENINHO | Mascote que busca mecanismo; esfera mecânica cobre/ciano | Desbloqueio de quest | Planejado; original |
| PET-ECO | Mascote de emotes; origami de memória rosa/violeta | Desbloqueio de quest | Planejado; original |
| RIDE-VENTO | Prancha levitante rápida em terreno aberto; lâminas ciano/azul | Rotas de vento | Planejado; original |
| RIDE-MARE | Skiff compacto para água; madeira azul/coral com vela | Vesper | Planejado; original |
| RIDE-CERVO | Cervo de cristal para trilhas; galhada verde/turquesa | Nimbara | Planejado; original |
| RIDE-TRILHO | Módulo orbital para ligação entre estações; cobre/índigo | Ferrúmia | Planejado; original |

## Faixas de música previstas

Cada faixa é original, em OGG local, com loop/stem quando indicado. Todas estão **Planejadas**; compositor e licença são registrados no momento da produção.

| ID | Nome provisório e uso |
|---|---|
| MUS-01 | Fragmentos do Infinito — abertura/menu |
| MUS-02 | Luzes de Íris — Observatório |
| MUS-03 | Rotas que Respiraram — exploração calma |
| MUS-04 | Passos no Verde — Nimbara |
| MUS-05 | Coração da Clareira — chefe Cérvido |
| MUS-06 | Relógio sob a Areia — Aurélio |
| MUS-07 | O Vidro Lembra — chefe Esfinge |
| MUS-08 | Arquipélago que Canta — Vesper |
| MUS-09 | Maré em Conflito — chefe Guardiã |
| MUS-10 | Cidade de Cobre Vivo — Ferrúmia |
| MUS-11 | Engrenagem sem Dono — chefe Colosso |
| MUS-12 | Aurora sobre a Neve — Ivern |
| MUS-13 | Guardião do Vento Branco — chefe Monarca |
| MUS-14 | Jardim do Outro Lado — Umbral |
| MUS-15 | Retrato em Prata — chefe Arquivista |
| MUS-16 | Ponte de Oito Tons — Núcleo do Nexo |
| MUS-17 | Memórias em Suspensão — Arquivo Zero |
| MUS-18 | Ressonância Suprema — camada de transformação |
| MUS-19 | Muitos Mundos, Um Futuro — final |
| MUS-20 | Além do Horizonte — epílogo/pós-jogo |

O manifest de produção deve validar todos os IDs, caminhos, licenças e arquivos de origem.

## Especificação comum de importação

GLB é formato de intercâmbio; preservar fonte editável em arquivo de criação fora do APK, aplicar escala/origem e nomear bones/animations de modo consistente. Texturas usam compressão mobile e perfis por aparelho; todo material declara custo e fallback. Modelo tem LOD e limites de textura/triângulos medidos. Áudio é local, loop testado e sem música de terceiros. Manifest deve falhar build quando asset marcado Integrado não existe ou licença está vazia.
