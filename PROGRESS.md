# Progresso — Anime Nexus

Branch de desenvolvimento atual: `dev/anime-nexus-vertical-slice`.

## Fase atual

- Auditoria inicial do checkout concluída.
- Documentos de universo, campanha, kits, regiões, equipamento, arte, arquitetura, offline, testes, roteiro e estados reais adicionados em `docs/`.
- Godot escolhido como runtime/renderizador da vertical slice e C++17 via GDExtension como linguagem principal da gameplay. Kotlin/OpenGL permanece separado como protótipo legado.
- Workflow revisado para validar a revisão exata e gerar artifacts sem alterar `main`.
- Fluxo inicial da slice conectado no Godot: avatar blockout de Kaien, Manoplas Fulgor, três habilidades, mapa blockout de Nimbara, missão, chefe Cérvido de Cristal e interação de proximidade com a Âncora.
- Câmera ortográfica diagonal e HUD simplificado para a campanha inicial; joystick analógico mantém intensidade gradual.
- Ataques em área do chefe agora exibem um círculo de aviso no chão antes do dano; a janela de aviso e a ausência de dano imediato estão cobertas por teste headless.
- Núcleo C++ `AnimeNexusCombatCore` integrado ao ataque básico e à evolução por XP; cálculo de dano/crítico, reações de elementos e subida de nível passaram no Godot 4.7.2 local.
- CI está sendo ampliado para compilar a extensão no Linux e no Android arm64 antes dos testes/exportação. APK com C++ não será considerado validado até essa CI passar.
- Próxima validação: instalar o APK exportado e conferir imagem/toque em aparelho; validar a leitura dos telegraphs em tela/dispositivo e trocar blockouts por arte final.

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
