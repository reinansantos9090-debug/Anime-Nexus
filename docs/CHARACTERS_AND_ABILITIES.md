# Personagens e habilidades

Os oito kits a seguir são a especificação de jogo. Todos estão **Planejados**; o protótipo atual possui um avatar genérico e não cumpre a lista. Habilidades devem ter custo, cooldown, alcance, hitbox, reação, animação, VFX legível, feedback de toque e comportamento IA testável.

| Personagem / ressonância | Silhueta e personalidade | Básico e três habilidades | Suprema e papel IA | Arco |
|---|---|---|---|---|
| **Kaien Arashi — Trovão** | Cabelo azul-escuro/ciano, olhos âmbar, casaco assimétrico e manoplas; protetor, impulsivo | **Pulso Voltaico** combo; **Passo Relâmpago** dash ofensivo; **Corrente Celeste** cadeia em alvos próximos; **Campo Estático** zona lenta | **Tempestade de Safira** carrega forma elétrica e altera alcance de combos; IA busca encadear grupos e evita ficar no campo inimigo | Aprende a liderar confiando nos outros |
| **Akari Solen — Chamas** | Cobre/vermelho, olhos ouro, preto/vermelho, lenço animado; competitiva e leal | **Centelha Rubra**; **Orbe Fênix** projétil; **Asas de Brasa** cone; **Círculo Solar** zona persistente | **Aurora Rubra** amplia propagação elemental; IA prioriza grupos e combina com vento | Aceita ajuda sem sentir que perdeu força |
| **Ren Aozora — Vento** | Prata/turquesa, roupa leve e adornos flutuantes; espirituoso e independente | **Rajada Livre**; **Vórtice Ascendente** agrupa/ergue; **Dança dos Ventos** deslocamento ofensivo; **Salto das Nuvens** salto/escape | **Horizonte Infinito** cria corredor de vento; IA remove pressão dos aliados e reposiciona | Escolhe permanecer com o grupo |
| **Mira Yukari — Gelo** | Lilás, azul-pérola e prismas geométricos; estratégica e reservada | **Fragmento Glacial**; **Lótus de Neve** área lenta; **Prisma Refletor** barreira/retorno; **Caminho Congelante** cria faixa controlável | **Jardim do Inverno Eterno** delimita arena e congela por janela curta; IA defende retaguarda | Permite-se sentir sem “resolver” tudo |
| **Yuna Tsukari — Lua** | Violeta, branco/azul-noite e estrelas orbitais; gentil e firme | **Raio Lunar**; **Selo da Harmonia** marca/buff; **Véu Protetor** escudo; **Luz Restauradora** cura em área | **Promessa Astral** cura, remove um estado negativo e fortalece combo; IA protege aliado em risco | Recupera a história da família guardiã |
| **Shin Kuroki — Sombras** | Preto/violeta, grafite e tecido distorcido; perspicaz e desconfiado | **Eco Crepuscular**; **Véu de Sombra** camufla/desvia; **Reflexo Duplo** duplicata temporária; **Passagem Breve** teleporte curto | **Noite Sem Eco** cria zona de ecos para ataques coordenados; IA flanqueia sem afastar-se do grupo | Reaprende a confiar, com ligação a Seraphine |
| **Haru Midori — Natureza** | Verde-musgo, equipamento botânico e espíritos-planta; paciente | **Semente Luminosa**; **Raízes Guardiãs** prende/protege; **Jardim Vital** cura gradual; **Espírito da Floresta** invoca aliado | **Coração de Nimbara** amplia recuperação e invocações; IA cura e interrompe inimigos perto de aliado | Entende mudança como parte da vida |
| **Eiko Aster — Gravidade** | Rosa-azul, índigo futurista e anéis flutuantes; inventiva | **Pulso Orbital**; **Nó Gravitacional** puxa; **Órbita Reversa** repele ou redireciona; **Campo de Leveza** reduz pressão e permite salto | **Supernova Interior** concentra reações em uma janela; IA agrupa inimigos para combos do trio | Aprende que mistério não é objeto de controle |

## Regras de design dos kits

- Básico tem cadeia curta (3–5 entradas) que aceita toque repetido e cancela em esquiva após janela clara.
- Três especiais têm funções distintas: movimento/interrupção, dano/elemento e controle/suporte; duplicata de habilidade só pode existir em variante desbloqueada.
- Suprema carrega por dano, combinação e objetivos; não depende de tempo de servidor. Cut-in pode ser reduzido/desligado.
- Cada personagem tem idle, caminhada/corrida, ataque básico, 3 especiais, esquiva, dano, vitória, interação e suprema; facial entra na etapa de produção de rig/expressão.
- Companion usa mesmas regras/custos sob IA; não cria dano grátis e nunca gasta consumíveis raros.

## Curvas de personagem

Desbloqueio por capítulo, níveis individuais e árvore de aperfeiçoamento com três ramos: identidade elemental, utilidade de grupo e defesa/mobilidade. Pontos respeitam limites e podem ser redistribuídos por custo baixo antes de chefe. Visuais não alteram atributo; cada silhueta mantém legibilidade de cima.
