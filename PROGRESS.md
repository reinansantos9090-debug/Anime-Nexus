# Progresso — Anime Nexus

Branch de desenvolvimento atual: `dev/anime-nexus-vertical-slice`.

## Fase atual

- Auditoria inicial do checkout concluída.
- Documentos de universo, campanha, kits, regiões, equipamento, arte, arquitetura, offline, testes, roteiro e estados reais adicionados em `docs/`.
- Godot escolhido como runtime/renderizador da vertical slice e C++17 via GDExtension como linguagem principal da gameplay. Kotlin/OpenGL permanece separado como protótipo legado.
- Workflow revisado para validar a revisão exata e gerar artifacts sem alterar `main`.
- Fluxo inicial da slice conectado no Godot: avatar blockout de Kaien, Manoplas Fulgor, três habilidades, mapa blockout de Nimbara, missão, chefe Cérvido de Cristal e interação de proximidade com a Âncora. A central de operações também inicia a missão pessoal de Kaien em Nimbara: derrotar três Musgos Saltadores para investigar o brasão Arashi; entradas, diálogos, rota, progresso C++ e recompensa têm uma regressão curta no runner manual.
- Câmera ortográfica diagonal e HUD simplificado para a campanha inicial; joystick analógico mantém intensidade gradual.
- Portal de desafio roteia ao chefe catalogado da região persistida e retorna ao Observatório ou à Âncora conforme a missão. Modelos reutilizados continuam blockout.
- As seis cadeias regionais, as quatro missões jogáveis do prólogo e as duas do epílogo estão ligadas à campanha local (60 missões); depois do retorno ao Observatório, o RIFT do Prisma Primordial fica disponível sem bloquear a exploração livre. A base recebeu marcos blockout para praça, oficina, mercado, biblioteca e treino. Seis cristais da Praça das Constelações agora acendem e crescem conforme as seis flags locais de Âncora são salvas; reconstruir o Observatório reflete o progresso persistido. Mapas, chefes e interações usam blockouts; cinemáticas, puzzles, arte final, áudio e validação manual continuam pendentes.
- Ataques em área do chefe agora exibem um círculo de aviso no chão antes do dano; a janela de aviso e a ausência de dano imediato estão cobertas por teste headless.
- Núcleo C++ `AnimeNexusCombatCore` integrado ao ataque básico e à evolução por XP; cálculo de dano/crítico, reações de elementos e subida de nível passaram no Godot 4.7.2 local.
- A CI automática curta valida o host Android Kotlin. O workflow Godot/GDExtension C++ Android e a exportação APK continuam manuais, conforme a regra do repositório, e não foram acionados.
- Próximas etapas: validar manualmente o fluxo de prólogo/epílogo no runner Godot e em aparelho quando o usuário disparar o workflow; produzir assets finais de personagens, chefes e mapas e substituir blockouts sem rotular protótipos como arte final.

## Validação executada

- Godot 4.7.2: extensão C++ Linux carregada e runner `ANIME_NEXUS_TESTS: PASS`; testes incluem joystick, loadout, dados Nimbara, missão/boss/Âncora, Campo Estático, dano/crítico, reações elementais e XP/nível. Ainda há warnings de recursos em uso ao encerrar o runner.
- Godot 4.6.3: smoke run headless por 180 frames encerrou sem erros de script. Render visual, toque real, APK atual e instalação ainda não foram verificados.
- GitHub Actions run `43410319631`, commit `c66eec5d78ce2c89d6b589c7b224587093081748`: testes unitários Kotlin, build APK do host, testes Godot 4.7.2 e export Android **passaram**. Foram anexados artifacts Kotlin e Godot; a [execução 43410319631](https://github.com/reinansantos9090-debug/Anime-Nexus/actions/runs/43410319631) tem os dois.
- A restauração do backup quando o save principal está malformado passou no runner local e no CI.
- As falhas de compilação Kotlin da revisão anterior foram corrigidas no host legado. O APK Kotlin ainda representa o protótipo Aetheria, não a versão final Anime Nexus; o APK Godot representa a slice Anime Nexus em blockout.
- Gradle local não conseguiu resolver AGP 9.1.1 nesta máquina, então a compilação foi observada no runner GitHub.
- Último CI de `main` auditado: falhou no verificador de referências externas de fontes Kotlin. Logs listam tipos que têm usos no código, indicando falsos positivos no verificador atual; o Godot passou antes dessa etapa.
- Android SDK não está instalado no ambiente local desta auditoria.

## Estado

Anime Nexus ainda não foi instalado/testado em aparelho e não tem campanha completa nem arte final. O CI produz os APKs de protótipo (host Aetheria e slice Godot em blockout). Ver detalhes em `docs/IMPLEMENTATION_STATUS.md`.
