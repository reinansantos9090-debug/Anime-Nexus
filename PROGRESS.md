# Progresso — Anime Nexus

Branch de desenvolvimento atual: `dev/anime-nexus-vertical-slice`.

## Fase atual

- Auditoria inicial do checkout concluída.
- Documentos de universo, campanha, kits, regiões, equipamento, arte, arquitetura, offline, testes, roteiro e estados reais adicionados em `docs/`.
- Godot escolhido como runtime de jogo para a vertical slice, sujeito a validação do APK; Kotlin/OpenGL preservado como protótipo existente durante a avaliação.
- Workflow revisado para validar a revisão exata e gerar artifacts sem alterar `main`.
- Fluxo inicial da slice conectado no Godot: avatar blockout de Kaien, Manoplas Fulgor, três habilidades, mapa blockout de Nimbara, missão, chefe Cérvido de Cristal e interação de proximidade com a Âncora.
- Câmera ortográfica diagonal e HUD simplificado para a campanha inicial; joystick analógico mantém intensidade gradual.
- Ataques em área do chefe agora exibem um círculo de aviso no chão antes do dano; a janela de aviso e a ausência de dano imediato estão cobertas por teste headless.
- Próxima validação: instalar o APK exportado e conferir imagem/toque em aparelho; validar a leitura dos telegraphs em tela/dispositivo e trocar blockouts por arte final.

## Validação executada

- Godot 4.6.3: import headless e runner `ANIME_NEXUS_TESTS: PASS`; testes cobrem joystick, loadout, dados Nimbara, cadeia da missão/boss/Âncora e lentidão do Campo Estático. Ainda há warnings de recursos em uso ao encerrar o runner.
- Godot 4.6.3: smoke run headless por 180 frames encerrou sem erros de script. Render visual, toque real, APK atual e instalação ainda não foram verificados.
- GitHub Actions run `43406082827`, commit `28fe837`: testes headless Godot 4.7.2 e export Android debug **passaram**; artifact Godot anexado à [execução 43406082827](https://github.com/reinansantos9090-debug/Anime-Nexus/actions/runs/43406082827) (28,2 MB).
- O job Android Kotlin chegou à compilação, mas falhou em `:app:compileDebugKotlin` com os mesmos 155 erros em 10 arquivos do protótipo; `:app:testDebugUnitTest` não pôde rodar e não foi produzido APK Kotlin.
- O conflito inicial de plugin Kotlin/AGP 9 foi corrigido nesta branch; a barreira atual são erros de compilação do código-fonte já existente.
- Gradle local não conseguiu resolver AGP 9.1.1 nesta máquina, então a compilação foi observada no runner GitHub.
- Último CI de `main` auditado: falhou no verificador de referências externas de fontes Kotlin. Logs listam tipos que têm usos no código, indicando falsos positivos no verificador atual; o Godot passou antes dessa etapa.
- Android SDK não está instalado no ambiente local desta auditoria.

## Estado

Anime Nexus ainda não tem build instalada/testada em aparelho, campanha completa nem arte final. O CI já exporta um APK debug da slice em blockout. Ver detalhes em `docs/IMPLEMENTATION_STATUS.md`.
