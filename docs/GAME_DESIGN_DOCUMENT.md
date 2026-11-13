# Anime Nexus: Fragmentos do Infinito — Game Design Document

## Visão

RPG de ação 3D para Android, single-player e offline, com exploração isométrica, combate de esquadrão e fantasia anime. A referência de experiência é a estrutura ágil de caça e progressão de RPG mobile; identidade, roteiro, mundos, personagens, ícones, áudio e modelos serão originais. A aventura completa é terminável sozinho.

## Pilares

1. **Explorar com propósito:** cada trilha contém atalhos, recursos, pequenos eventos e informação do mundo.
2. **Combate legível e combinado:** posição, esquiva, telegraphs, energia e sinergia entre ressonâncias dão escolhas rápidas ao toque.
3. **Personagens com voz:** protagonistas têm habilidades, arcos, banter contextual e papel distinto mesmo sob IA.
4. **Progredir jogando:** equipamento, craft, cosméticos e história vêm do jogo local; sem compras, login ou tarefas de servidor.
5. **Arte original e honesta:** protótipo tem rótulo de provisório; produção final é medida por recursos presentes e capturas do app.

## Loop de jogo

Observatório → preparar trio/equipamento → ler missão e região → explorar/combater/resolver obstáculo → chefe ou objetivo narrativo → receber materiais/registro → evoluir/build/save → retornar a rotas alteradas.

## Missões e sessões

Campanha planejada: prólogo (4), seis mundos de capítulo (8 cada), desfecho (6) e epílogo (2), total de 60. Side quests ≥45, com histórias individuais, resgates, ruínas, investigação, restauração e expedições. A estrutura narrativa e seus dados são detalhados em `MISSIONS_AND_DIALOGUES.md`; título em catálogo sozinho não conta como missão implementada.

## Grupo e dificuldade

Controle direto de um protagonista e escolha de até dois companions. Troca/comando radial contextual quando a slice suportar. Dificuldades: Casual (janelas maiores, dano recebido menor), Aventura (padrão) e Desafio (telegraphs curtos, padrões adicionais e recursos mais escassos, sem bloquear história). O trio deve vencer todos os chefes sem coop online.

## Combate

Ataque básico + três habilidades + esquiva + suprema. Recursos: HP, energia de habilidades e medidor de transformação. O alvo pode ser assistido; jogador mantém escolha manual. Fogo propaga com vento; água conduz trovão; gelo+vento cria névoa e obstrui mira; natureza+lunar amplia cura; sombra+luz produz eco/duplicata; gravidade concentra área. Reações têm duração/limites explícitos e efeito VFX local, com testes de regra.

## Regiões e conteúdo

O Observatório de Íris é hub evolutivo; Nimbara, Aurélio, Vesper, Ferrúmia, Ivern, Umbral e Núcleo do Nexo são sete zonas de campanha. Cada expedição tem rotas e objetivos próprios; variação de paleta não substitui layout e encontros diferentes.

## Controles e interface

Landscape, câmera isométrica estável com zoom limitado e bloqueio de obstáculos; joystick analógico à esquerda, ataque/esquiva/habilidades/suprema à direita, companheiros e utilidade no topo. Botões reposicionáveis/redimensionáveis, assistência de mira, sensibilidade, contraste, reduzir flash, legendas `pt-BR`, música/SFX separados e perfis gráficos.

## Salvamento e conteúdo offline

Três saves locais, backup e migração. Nenhuma conta/rede/serviço externo em runtime; recursos pré-empacotados. Eventos determinísticos ou por sessão, sem obrigação de acesso diário. Detalhes em `OFFLINE_REQUIREMENTS.md`.

## Critérios de entrega

Uma feature precisa estar ligada a cena/fluxo, aceitar entrada, executar efeito real, emitir resultado observável, salvar quando aplicável e passar teste. Ícones, strings, arquivos de asset manifest e classes não provam que a experiência está implementada. O ponto atual da base ainda é Aetheria: Echoes; consulte `IMPLEMENTATION_STATUS.md`.
