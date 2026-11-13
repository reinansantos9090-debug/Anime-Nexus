# Progresso — Anime Nexus

Branch de desenvolvimento atual: `dev/anime-nexus-vertical-slice`.

## Fase atual

- Auditoria inicial do checkout concluída.
- Documentos de universo, campanha, kits, regiões, equipamento, arte, arquitetura, offline, testes, roteiro e estados reais adicionados em `docs/`.
- Godot escolhido como runtime de jogo para a vertical slice, sujeito a validação do APK; Kotlin/OpenGL preservado como protótipo existente durante a avaliação.
- Workflow revisado para validar a revisão exata e gerar artifacts sem alterar `main`.
- Fluxo inicial da slice conectado no Godot: avatar blockout de Kaien, Manoplas Fulgor, três habilidades, mapa blockout de Nimbara, missão, chefe Cérvido de Cristal e interação de proximidade com a Âncora.
- Câmera ortográfica diagonal e HUD simplificado para a campanha inicial; joystick analógico mantém intensidade gradual.
- Próxima validação: CI Godot 4.7.2, export do APK desta revisão e verificação visual/touch em aparelho.

## Validação executada

- Godot 4.6.3: import headless e runner `ANIME_NEXUS_TESTS: PASS`; testes cobrem joystick, loadout, dados Nimbara, cadeia da missão/boss/Âncora e lentidão do Campo Estático. Ainda há warnings de recursos em uso ao encerrar o runner.
- Godot 4.6.3: smoke run headless por 180 frames encerrou sem erros de script. Render visual, toque real, APK atual e instalação ainda não foram verificados.
- GitHub Actions run `43399588726`: export Godot 4.7.2 **passou e publicou artifact APK** (`anime-nexus-godot-debug-e6fc413457aec00a8d3540077b0173a3e379c92c`).
- O CI anterior executou o build Android Kotlin e chegou à compilação, mas falhou em `:app:compileDebugKotlin` com 155 erros em 10 arquivos Kotlin do protótipo. `:app:testDebugUnitTest` não pôde rodar e não foi produzido APK Android pelo Gradle.
- O conflito inicial de plugin Kotlin/AGP 9 foi corrigido nesta branch; a barreira atual são erros de compilação do código-fonte já existente.
- Gradle local não conseguiu resolver AGP 9.1.1 nesta máquina, então a compilação foi observada no runner GitHub.
- Último CI de `main` auditado: falhou no verificador de referências externas de fontes Kotlin. Logs listam tipos que têm usos no código, indicando falsos positivos no verificador atual; o Godot passou antes dessa etapa.
- Android SDK não está instalado no ambiente local desta auditoria.

## Estado

Anime Nexus ainda não tem build, conteúdo de campanha nem arte final. Ver detalhes em `docs/IMPLEMENTATION_STATUS.md`.
