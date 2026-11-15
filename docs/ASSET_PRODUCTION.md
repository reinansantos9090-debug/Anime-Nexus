# Inventário de produção de assets

**Estado de auditoria:** não há modelos/áudio finais. O primeiro slice agora usa blockouts procedurais originais para Kaien, Nimbara, algumas criaturas, Cérvido e Âncora. Esses meshes são provisórios e não satisfazem os requisitos de arte final. Demais recursos permanecem **Planejados**. Registrar autor, ferramenta, arquivo-fonte e licença antes de integrar; nenhum arquivo extraído de jogo comercial.

| ID | Finalidade e associação | Descrição visual / paleta | Especificação / materiais | Animações exigidas | Estado / origem |
|---|---|---|---|---|---|
| CH-KAIEN | Protagonista Kaien, slice e campanha | Jovem anime; azul-marinho/ciano/âmbar; casaco assimétrico e manoplas | glTF/GLB, rig humanoide, 12–20k tris LOD0 / 5–8k LOD1; 1K albedo/normal/ORM atlas | idle, run, combo 3, dodge, 3 skills, hit, victory, supreme | Blockout procedural integrado; arte final planejada; original |
| CH-AKARI | Akari, companheira de combate e protagonista | cobre/vermelho/ouro, lenço distintivo | runtime atual usa blockout humanoide procedural colorido; pipeline final humanoide modular e lenço separado | idle/run, combo, 3 skills, esquiva, hit, suprema | Silhueta blockout ganha lenço e cauda de brasa procedurais com balanço leve; modelo anime, tecido e animação final continuam pendentes; acessórios procedurais originais, sem asset externo |
| CH-REN | Ren, companheiro de controle do vento e protagonista | prata/turquesa/verde, ornamentos flutuantes | runtime atual usa blockout humanoide procedural colorido; rig final leve e acessórios com bones secundários | idle/run, combo, salto, vento, esquiva, suprema | Silhueta blockout ganha aro giratório e vane de vento com oscilação; rig e ornamentos animados finais continuam pendentes; acessórios procedurais originais, sem asset externo |
| CH-MIRA | Mira, gelo | lilás/azul-pérola, prismas geométricos | rig humanoide; adornos transparentes separados | idle/run, combo, barreira, gelo, hit, suprema | Silhueta blockout ganha prismas de ombro oscilantes; cristais translúcidos e rig final continuam pendentes; acessórios procedurais originais, sem asset externo |
| CH-YUNA | Yuna, lunar | violeta/branco/azul-noite, estrelas orbitais | rig humanoide; órbitas sem simulação física cara | idle/run, combo, cura, escudo, suprema, reação | Silhueta blockout ganha aro lunar e duas esferas de acento que orbitam; traje/estrelas orbitais finais pendentes; acessórios procedurais originais, sem asset externo |
| CH-SHIN | Shin, sombra | grafite/preto/violeta, tecido distorcido | rig humanoide; material dissolve controlável | idle/run, combo, duplicata, teleporte, hit, suprema | Silhueta blockout ganha painéis de manto com balanço leve; dissolve, tecido e duplicatas seguem pendentes; acessórios procedurais originais, sem asset externo |
| CH-HARU | Haru, natureza | verde-musgo, folhas, bolsa botânica | rig humanoide; espíritos-companion como assets separados | idle/run, combo, raízes, cura, invocação, suprema | Silhueta blockout ganha folhas de cabeça oscilantes; acessórios botânicos e espíritos finais pendentes; acessórios procedurais originais, sem asset externo |
| CH-EIKO | Eiko, gravidade | índigo/rosa/azul, aros cósmicos | rig humanoide, rings separados e emissivo controlado | idle/run, combo, pull/push, campo, suprema | Silhueta blockout ganha dois aros gravitacionais giratórios; movimento orbital completo e modelo futurista final pendentes; acessórios procedurais originais, sem asset externo |
| VFX-KAIEN-SUPREME | Aura da Tempestade de Safira | Dois anéis de ressonância ciano em torno de Kaien, brilho sem flash estroboscópico | Malha toroidal low-poly, 2 materiais emissivos, animação local por rotação/escala; custo limitado a 2 draw calls enquanto ativa | ativação, órbita durante 10 s e dissipação | Protótipo original com meshes e VFX reutilizados integrado; cut-in, forma anime, partículas próprias e áudio final pendentes |
| WPN-FULGOR | Instrumento inicial de Kaien | Manoplas curtas azul-marinho, anéis ciano e arcos de faísca âmbar | GLB preso ao socket das duas mãos, até 4k tris total, textura 512² e emissivo simples | idle, combo 3, esquiva, brilho durante Pulso Voltaico e Tempestade | Catálogo/kit de combate integrados; modelo equipado, ícone e animações de arma finais não produzidos; original |
| WPN-VOLT | Instrumento desbloqueável Lâminas Voltaicas | Par de lâminas curtas azul-cobalto/ciano, trilhas elétricas legíveis | GLB par com pivôs individuais, até 6k tris, atlas 512² | idle, combo, dash, trilha de skill e suprema | Licença craftável e kit de combate integrados; modelo, ícone e animações de arma pendentes; original |
| WPN-TOXIC | Instrumento desbloqueável Arco Tóxico | Arco compacto verde-musgo com fibra turquesa e projétil luminoso | GLB com corda simples sem simulação, até 5k tris, atlas 512² | puxada, disparo, recarga curta, habilidade e suprema | Licença craftável e kit de combate integrados; modelo, ícone e animações de arma pendentes; original |
| WPN-PULSE | Instrumento desbloqueável Canhão Pulsar | Canhão leve grafite com núcleo dourado e pulsos magenta/azuis | GLB modular, até 7k tris, atlas 512² | mira, disparo, recuo curto, sobrecarga e suprema | Licença craftável e kit de combate integrados; modelo, ícone e animações de arma pendentes; original |
| BOSS-CERVO | Chefe de Nimbara | espírito cervídeo de cristal verde/violeta | criatura 25–40k tris LOD0; carapaça segmentada, cristal emissivo | idle, investida, stomp, cristal, stun, fase 2, derrota | Blockout procedural com IA/fases genéricas integrado; modelo/animações finais planejados; original |
| BOSS-ESFINGE | Chefe Aurélio | esfinge de vidro dourado/coral | 30–45k tris LOD0, material facetado não transparente caro | voo/andar, feixe refletido, miragem, fase 2, hit/death | Dados e padrões de chefe integrados como Esfinge de Vidro; a malha atual é um blockout genérico tingido; modelo/arena/animações finais pendentes; original |
| BOSS-MARES | Chefe Vesper | guardiã anfíbia azul/coral/perolada | 30–45k tris, nadadeiras e material de água estilizada | onda, mergulho, mudança de maré, fase 2 | Guardiã das Marés catalogada e conectada à campanha; mesh de colosso tingida como blockout; forma anfíbia, arena e animações finais pendentes; original |
| BOSS-COLOSSO | Chefe Ferrúmia | corpo mecânico cobre/coral/azul elétrico | 35–50k tris modular; placas e bobinas separadas | marcha, varredura, trilho, quebra de placa, fase 2 | Colosso de Aço-Coral catalogado e conectado; usa malha genérica tingida como blockout; partes mecânicas, arena e animações finais pendentes; original |
| BOSS-MONARCA | Chefe Ivern | monarca de geada pérola/lilás/dourado | 30–45k tris, capa/ornamentos congelados | rajada, ring attack, cristal de calor, fase 2 | Monarca catalogado e conectado; blockout genérico com paleta de gelo; capa, modelo e animações finais pendentes; original |
| BOSS-ARQUIVISTA | Chefe Umbral | entidade de espelho/prata/violeta | 30–45k tris, peças refletivas com material mobile | cópia de golpe, troca de alvo, fase 2, quebra do espelho | Arquivista do Espelho catalogado e conectado; blockout genérico tingido; reflexos, modelo e animações finais pendentes; original |
| BOSS-ZERO | Chefe final | entidade geométrica escura com núcleo ciano-lilás e oito placas orbitais | Atualmente oito painéis simples, núcleo cristalino e dois anéis; futuro modelo final 40–60k tris LOD0 com módulos leves | Catálogo de chefe 3 fases e padrões RIFT integrados; transições de memória, telegraphs exclusivos, animações, som e narrativa final pendentes | Blockout procedural; modelo final pendente | Código e meshes originais do projeto |
| HQ-OBSERVATORIO | Cidade-base | marcos blockout originais para praça, oficina, mercado, biblioteca e treino; volumes compactos, paleta ciano/violeta/cobre; geometria estática, sem NPCs, animações ou detalhes finais |
| BOSS-PRISMA | Desafio secreto pós-campanha | prisma primordial policromático com núcleo claro e oito facetas orbitais | Atual: blockout procedural com núcleo, duas órbitas e oito cristais facetados; alvo final 40–60k tris, emissivo seletivo | padrões de feixe, chuva prismática, invocações, nova, fases e telegraphs exclusivos; animações de produção pendentes | Blockout procedural original integrado; modelo, VFX, arena, animações e áudio finais planejados |
| EN-NIMBARA | 6 inimigos da floresta | musgo, faísca foliar, mariposa, besouro, cipó e guardião | cada rig 4–18k tris, materiais por espécie | locomoção, ataque, reação, recuo, derrota | Quatro inimigos com meshes/IA blockout integrados; faltam dois e os assets finais; original |
| EN-AURELIO | 6 inimigos do deserto | cristal, escaravelho, miragem, vigia, ampulheta e guardião | mesma faixa modular, silhuetas distintas | movimento, ataque, telegraph, retorno | Dados/saques offline e seis silhuetas procedurais de blockout integrados; rigs, animações e modelos finais pendentes; original |
| EN-VESPER | 6 inimigos costeiros | bolha, coral, água-viva, caranguejo, onda e sentinela | rigs pequenos, água não exige transparência em toda peça | ricochete, onda, guarda, mergulho | Planejado; original |
| EN-FERRUMIA | 6 inimigos mecânicos | drone, engrenagem, sentinela, autômato, magnético e núcleo | peças reutilizáveis em atlas sem reutilizar silhueta completa | patrulha, tiro, montagem, stagger | Dados/saques offline e seis silhuetas procedurais blockout integrados; IA/rigs/animações finais pendentes; original |
| EN-IVERN | 6 inimigos de geada | floco, raposa, cristal, nevasca, guardião e sentinela | rig de criatura e partículas limitadas | pulo, névoa, ataque vertical, retorno | Dados/saques offline e seis silhuetas procedurais de blockout integrados; rigs, animações e modelos finais pendentes; original |
| EN-UMBRAL | 6 inimigos de reflexo | eco, borboleta, espelho, sombra, ilusão e vigia | mesh leve; dissolve/duplicata por shader | invisibilidade curta e leitura de pista | Dados/saques offline e seis silhuetas procedurais de blockout integrados; dissolve, espelhos reais, rigs e animações finais pendentes; original |
| EN-NEXO | ecos de cada região | variações narrativas locais dos inimigos aprovados | combinações de material e comportamento; não só troca de cor | ataques combinados e reações próprias | Planejado; original |
| ENV-OBSERVATORIO | hub principal | pedra suspensa, vidro astral, luz de portal azul | 1 cena modular, 3 setores visíveis, LOD/occlusion | bandeiras, portal, NPCs, luz narrativa | Blockout do hub reutilizado; arte final e áreas funcionais planejadas; original |
| ENV-NIMBARA | floresta e três subáreas | folhagem verde, bioluminescência turquesa/violeta | kits de árvore, raiz, ruína, lago e trilha; atlas 2K por região | vento/folha/água em ciclos baratos | Blockout da clareira com trilha, árvores, raízes, cristais e Âncora; subáreas e arte final planejadas; original |
| ENV-AURELIO | deserto/templo/oásis | duna dourada, pedra coral, céu violeta | módulos de ruína e plataforma; terreno com rota | poeira, mecanismo, faixa de calor | Expedição blockout selecionável com marcos de arenito, cristas decorativas e fragmentos do templo; puzzles temporais, plataformas e arte final pendentes; original |
| ENV-VESPER | porto/ilhas/caverna | água cobalto, coral, pontes de luz | kit de costa, cavernas, skiff e farol | maré, água, barco e ponte | Blockout costeiro procedural com enseadas, cais e corais acessível como expedição; maré interativa, subáreas e arte final pendentes; original |
| ENV-FERRUMIA | cidade/trilhos/torre | cobre, magenta, azul elétrico | kit modular, plataformas, elevadores e cabos | trilhos/elevadores e máquinas | Expedição blockout com trilhos estáticos, quatro torres e engrenagens decorativas; elevadores, máquinas interativas, subáreas e arte final pendentes; original |
| ENV-IVERN | vale/templo/picos | neve pérola, aurora lilás/dourada | terreno, cristais e pontes; material neve mobile | neve leve, corrente de vento e aurora | Expedição blockout selecionável com bancos de neve, cristais e arcos fixos de aurora; vento, pontes dinâmicas, templo, subáreas e arte final pendentes; original |
| ENV-UMBRAL | jardim/galeria/palácio | violeta profundo, rosa, prata | módulos duplicáveis com variantes de rota | transição de geometria discreta | Expedição blockout com painéis e colunas estáticos; reflexos, geometria mutável, subáreas e arte final pendentes; original |
| ENV-NUCLEO | ponte/salão/coração | mistura de paletas sem perder legibilidade | kit modular com pontos de âncora e arenas boss | transições de fase e fragmentos | Expedição blockout com oito cristais de paleta, marcadores de âncora e aro central; salão/coração, transições e arte final pendentes; original |
| UI-KIT | HUD/menu/inventário/oficina/mapa | ornamentos próprios de constelação, borda e ícones elementais | SVG/vector ou texturas 9-slice escaláveis; fonte legível licenciada | estados hover/touch/cooldown/quest | Planejado; original/licença documentada |
| VFX-KIT | habilidades e estados | trilhas distintas para 8 ressonâncias | partículas agrupadas, atlas e materiais mobile | hit, dash, campo, cura, escudo, reação, suprema, boss | Em desenvolvimento: impacto, anel e névoa procedurais para reações da slice; efeitos finais das oito ressonâncias planejados; original |
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
| EN-AUR-CRISTAL | Cristal Errante; prisma flutuante com fendas luminosas, ouro/coral | Aurélio | Silhueta procedural de blockout no runtime; rig/animações/modelo final pendentes; original |
| EN-AUR-ESCARAVELHO | Escaravelho Solar; casco em disco solar e pernas rápidas, âmbar/azul-noturno | Aurélio | Silhueta procedural de blockout no runtime; rig/animações/modelo final pendentes; original |
| EN-AUR-MIRAGEM | Miragem Duplicadora; silhueta de vidro arenoso com núcleo duplo, coral/violeta | Aurélio | Silhueta procedural de blockout no runtime; rig/animações/modelo final pendentes; original |
| EN-AUR-VIGIA | Vigia das Dunas; manto de areia e lança de cristal, dourado/índigo | Aurélio | Silhueta procedural de blockout no runtime; rig/animações/modelo final pendentes; original |
| EN-AUR-AMPULHETA | Espírito da Ampulheta; corpo de areia em espiral, cobre/roxo | Aurélio | Silhueta procedural de blockout no runtime; rig/animações/modelo final pendentes; original |
| EN-AUR-GUARDIAO | Guardião do Oásis; massa de pedra e raízes aquáticas, turquesa/dourado | Aurélio | Silhueta procedural de blockout no runtime; rig/animações/modelo final pendentes; original |
| EN-VES-BOLHA | Bolha Saltitante; corpo translúcido estilizado e anéis de espuma, azul/coral | Vesper | Blockout procedural próprio integrado no encontro; modelo rigado, animações e VFX finais pendentes; original |
| EN-VES-CORAL | Coral Errante; colônia que anda sobre ramificações, coral/creme | Vesper | Blockout procedural próprio integrado no encontro; modelo rigado, animações e VFX finais pendentes; original |
| EN-VES-AGUAVIVA | Água-Viva Astral; sino flutuante com pontos luminosos, cobalto/rosa | Vesper | Blockout procedural próprio integrado no encontro; modelo rigado, animações e VFX finais pendentes; original |
| EN-VES-CARANGUEJO | Caranguejo de Pérolas; pinças-prisma e casco perolado, marinho/prata | Vesper | Blockout procedural próprio integrado no encontro; modelo rigado, animações e VFX finais pendentes; original |
| EN-VES-ESPIRITO | Espírito das Ondas; figura longa formada por fita de maré, verde-mar/ciano | Vesper | Blockout procedural próprio integrado no encontro; modelo rigado, animações e VFX finais pendentes; original |
| EN-VES-SENTINELA | Sentinela Abissal; guardião de casco profundo, azul-escuro/coral | Vesper | Blockout procedural próprio integrado no encontro; modelo rigado, animações e VFX finais pendentes; original |
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


## Recurso visual integrado nesta etapa

| Nome | Finalidade | Região | Descrição / paleta | Especificação | Materiais e animações | Estado | Origem / licença |
|---|---|---|---|---|---|---|---|
| `godot/shaders/biome_ground.gdshader` | Variação estilizada do solo sem textura externa | Biomas atuais; cores recebidas do catálogo de mapa | Ruído orgânico em duas escalas, bandas diffuse toon suaves; combina a cor de solo local com 28% da cor de acento | Shader spatial de baixo custo por material de piso; coordenadas em mundo evitam repetição visível entre blocos | Material rough, sem textura e sem animação; luz principal do ambiente | Em desenvolvimento; revisão visual e perfil mobile pendentes | Código original do projeto, sem dependências de arte proprietária |


| `Memory Echo Marker` | Ponto interativo de exploração | Clareira de Nimbara | Cristal pálido ciano com halo turquesa e brilho orbital discreto | Nó leve com cristal, torus e esfera de acento; uma instância em cada uma das três posições do mapa | Materiais estilizados do projeto; sem animação até validação de custo | Blockout visual integrado | Geometria procedural original, criada no projeto |

| `Nimbara Memory Lake` | Ponto de interesse e referência para a missão Ecos no Lago | Nimbara | Poça oval azul-petróleo com anéis de margem turquesa, escala pequena para mobile | Esfera achatada e dois torus com poucos vértices | Material toon procedural; sem transparência nem animação | Blockout visual integrado | Geometria procedural original, criada no projeto |

## Blockouts procedurais de Vesper

| Nome | Finalidade | Região/personagem | Descrição visual / paleta | Especificações | Materiais | Animações | Estado | Origem/licença |
|---|---|---|---|---|---|---|---|---|
| Enseadas de Vesper | Dar identidade visual à expedição compacta | Vesper | Três poças costeiras azul-cobalto com borda ciano | Malhas esféricas achatadas e torus de baixo polígono; sem colisão navegável | Material fosco simplificado; água decorativa, sem transparência | Sem animação; sem maré dinâmica | Blockout integrado; água interativa e arte final pendentes | Geometria procedural original do projeto |
| Cais do Porto da Lua | Marcos visuais e obstáculos da rota | Vesper | Tábuas de madeira azul-marinho/coral e postes | 2 cais modulares, meshes simples; sem veículo ou travessia aquática | Materiais foscos mobile | Sem animação | Blockout integrado; barco, interação e arte final pendentes | Geometria procedural original do projeto |
| Corais da Enseada | Silhuetas de navegação e cobertura visual | Vesper | Núcleo coral com galhos em coral e turquesa | Grupos pequenos de cilindros/esferas low-poly | Materiais opacos estilizados | Sem animação | Blockout integrado; assets finais pendentes | Geometria procedural original do projeto |
| Seis criaturas de Vesper | Identificar encontros distintos à distância | Vesper | Bolha ciano, coral ramificado, água-viva azul/lilás, caranguejo perolado, espírito turquesa e sentinela marinho | Malhas procedurais leves; sem rig ou esqueleto no blockout | Materiais opacos estilizados; pontos de cor por espécie | IA usa comportamentos existentes; clips de animação ainda ausentes | Seis silhuetas de blockout integradas; modelos rigados, telegraphs e animações finais pendentes | Código e geometria originais do projeto; sem recursos comerciais |


## Criaturas blockout de Ferrúmia

| Asset | Papel / desenho / paleta | Região | Estado e origem |
|---|---|---|---|
| EN-FER-DRONE | Drone Prismático; corpo compacto grafite com núcleo prismático ciano e aros magenta | Ferrúmia | Dados e silhueta de blockout integrados; rig, ataque telegráfico e arte final pendentes; original |
| EN-FER-ENGRENAGEM | Engrenagem Viva; aro de cobre com dentes dourados e núcleo rosado | Ferrúmia | Dados e silhueta de blockout integrados; movimento animado, rig e arte final pendentes; original |
| EN-FER-SENTINELA | Sentinela de Cobre; guardião robusto com placa frontal e olhos ciano | Ferrúmia | Dados e silhueta de blockout integrados; rig, quebra de defesa e arte final pendentes; original |
| EN-FER-AUTOMATO | Autômato Instável; torso geométrico violeta com núcleo suspenso | Ferrúmia | Dados e silhueta de blockout integrados; estados alternados, rig e arte final pendentes; original |
| EN-FER-MAGNETICO | Guardião Magnético; silhueta grande com anel orbital ciano | Ferrúmia | Dados e silhueta de blockout integrados; puxão, rig e arte final pendentes; original |
| EN-FER-NUCLEO | Núcleo Mecânico; esfera rosa envolvida por lâminas de metal | Ferrúmia | Dados e silhueta de blockout integrados; invocação, rig e arte final pendentes; original |


## Criaturas blockout de Ivern

| Asset | Papel / desenho / paleta | Região | Estado e origem |
|---|---|---|---|
| EN-IVE-FLOCO | Floco Vivente; cristal flutuante ciano com três braços radiais | Ivern | Silhueta procedural no runtime; rig/animações de flutuação e modelo final pendentes; original |
| EN-IVE-RAPOSA | Raposa Boreal; corpo branco-pérola, orelhas lilás e cauda longa | Ivern | Silhueta procedural no runtime; rig e animações de salto/isca pendentes; original |
| EN-IVE-CRISTAL | Cristal Errático; guardião geométrico azul com cristal lateral | Ivern | Silhueta procedural no runtime; teleporte visual, rig e modelo final pendentes; original |
| EN-IVE-NEVASCA | Espírito da Nevasca; núcleo vertical azul cercado por três aros | Ivern | Silhueta procedural no runtime; VFX de neblina, animação e modelo final pendentes; original |
| EN-IVE-GUARDIAO | Guardião de Geada; golem azul com cristal dorsal | Ivern | Silhueta procedural no runtime; rig e animações de defesa pendentes; original |
| EN-IVE-SENTINELA | Sentinela da Aurora; prisma azul com nadadeiras lilás e aro dourado | Ivern | Silhueta procedural no runtime; telegraph vertical, rig e modelo final pendentes; original |


## Criaturas blockout de Umbral

| Asset | Papel / desenho / paleta | Região | Estado e origem |
|---|---|---|---|
| EN-UMB-1 | Eco Sem Forma; silhueta vertical violeta com halo magenta | Umbral | Silhueta procedural blockout no runtime; rig/animações de produção pendentes; original |
| EN-UMB-2 | Borboleta do Eclipse; asas violetas e núcleo rosa | Umbral | Silhueta procedural blockout no runtime; rig/animações de produção pendentes; original |
| EN-UMB-3 | Guardião do Espelho; golem com placas laterais prateadas | Umbral | Silhueta procedural blockout no runtime; rig/animações de produção pendentes; original |
| EN-UMB-4 | Sombra Fragmentada; corpo lupino escuro com prisma violeta | Umbral | Silhueta procedural blockout no runtime; rig/animações de produção pendentes; original |
| EN-UMB-5 | Ilusão Errante; forma alongada acompanhada por eco menor | Umbral | Silhueta procedural blockout no runtime; rig/animações de produção pendentes; original |
| EN-UMB-6 | Vigia do Silêncio; figura prismática com aro rosa-prata | Umbral | Silhueta procedural blockout no runtime; rig/animações de produção pendentes; original |


## Marcos reativos do Observatório

| Asset | Finalidade | Região/personagem | Descrição visual / paleta | Especificações | Materiais | Animações | Estado | Origem/licença |
|---|---|---|---|---|---|---|---|---|
| Seis cristais das Âncoras | Tornar visível no hub o progresso persistido da campanha | Praça das Constelações; Nimbara, Aurélio, Vesper, Ferrúmia, Ivern e Umbral | Seis prismas ao redor do portal, com cores de cada mundo; ficam menores e escurecidos até a respectiva Âncora ser restaurada | Instâncias leves de cristal procedural e halo; estado reconstruído das flags locais `<região>_slice_complete` ao montar o Observatório | Materiais estilizados já usados pelo projeto; nenhum arquivo externo | Sem animação contínua; brilho e escala refletem estado salvo | Blockout funcional integrado; materiais e animação finais pendentes | Geometria procedural original do projeto |



## Selo Lunar de Yuna

| Asset | Finalidade | Região/personagem | Descrição visual / paleta | Especificações | Materiais | Animações | Estado | Origem/licença |
|---|---|---|---|---|---|---|---|---|
| Selo Lunar | Marco explorável da introdução pessoal adicional de Yuna | Clareira de Nimbara | Registro pequeno de cristal violeta e branco-pérola dentro de um aro lunar; após a lembrança, recebe luz dourada suave | Geometria procedural leve no ponto `yuna_lunar_seal`, visível em câmera isométrica | Materiais sólidos locais, sem textura externa | Sem animação até o polish | Blockout integrado; modelo, reflexão, símbolo familiar e animação final pendentes | Geometria procedural original do projeto |

## Prisma de Memória de Mira

| Asset | Finalidade | Região/personagem | Descrição visual / paleta | Especificações | Materiais | Animações | Estado | Origem/licença |
|---|---|---|---|---|---|---|---|---|
| Prisma de Memória | Marco explorável da introdução pessoal adicional de Mira | Clareira de Nimbara | Prisma alto azul-pérola dentro de dois anéis finos; fica dourado após Mira aceitar a lembrança sem resolvê-la | Malha procedural leve no ponto `mira_memory_prism`, legível na câmera isométrica | Materiais sólidos originais, sem textura externa | Sem animação até o polish | Blockout integrado; reflexão, animação, material e modelo final pendentes | Geometria procedural original do projeto |

## Sino do Vento de Ren

| Asset | Finalidade | Região/personagem | Descrição visual / paleta | Especificações | Materiais | Animações | Estado | Origem/licença |
|---|---|---|---|---|---|---|---|---|
| Sino do Vento | Marco explorável da introdução pessoal adicional de Ren | Rota antiga de Nimbara | Haste simples com cristal suspenso e dois anéis turquesa; dourado após Ren escolher permanecer com o grupo | Elementos procedurais leves em torno de `ren_wind_chime`, visíveis na perspectiva isométrica | Sem textura externa; cores em material procedural | Sem animação até o polish | Blockout integrado; silhueta, oscilação do sino, som e modelo final pendentes | Geometria procedural original do projeto |

## Flor de Brasa

| Asset | Finalidade | Região/personagem | Descrição visual / paleta | Especificações | Materiais | Animações | Estado | Origem/licença |
|---|---|---|---|---|---|---|---|---|
| Flor de Brasa | Marco de missão interativo para a história pessoal de Akari | Clareira de Nimbara | Flor procedural pequena, cinco pétalas cor de brasa e núcleo dourado, com prisma e anel luminosos que a destacam na câmera isométrica | Usa a malha leve de flor procedural, cristal reduzido e torus de leitura no ponto interativo `akari_flame_bloom` | Material opaco de acento coral, sem textura externa | Coral antes da missão e dourado após a flag persistida; sem animação até o polish | Blockout visual integrado; modelo e efeito finais pendentes | Geometria procedural original do projeto |
