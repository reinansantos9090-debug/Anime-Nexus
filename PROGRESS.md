# Progresso — Anime Nexus

Branch de desenvolvimento atual: `dev/anime-nexus-vertical-slice`.

## Fase atual

- Auditoria inicial do checkout concluída.
- Documentos de universo, campanha, kits, regiões, equipamento, arte, arquitetura, offline, testes, roteiro e estados reais adicionados em `docs/`.
- Godot escolhido como runtime de jogo para a vertical slice, sujeito a validação do APK; Kotlin/OpenGL preservado como protótipo existente durante a avaliação.
- Workflow revisado para validar a revisão exata e gerar artifacts sem alterar `main`.
- Primeiro elemento de controle da slice integrado ao runtime Godot: joystick touch analógico substituiu as setas fixas e preserva intensidade gradual de movimento.
- Próximo trabalho: adaptar o runtime Godot para Kaien/Nimbara e desenvolver a slice em landscape.

## Validação executada

- Godot 4.6.3: import headless completou; runner imprimiu `AETHERIA_TESTS: PASS`; houve warnings de recursos em uso no encerramento.
- Godot 4.6.3: teste de direção/limite do joystick e smoke run da cena principal passaram sem erro; interação touchscreen ainda precisa de aparelho.
- GitHub Actions: export Godot 4.7.2 **passou e publicou artifact APK**. Job Kotlin revelou conflito do plugin `org.jetbrains.kotlin.android` separado com suporte Kotlin embutido do AGP 9; migração para o suporte integrado começou nesta branch e precisa de nova execução.
- Gradle 9.3.1: `:app:testDebugUnitTest :app:assembleDebug` interrompeu na resolução de AGP 9.1.1. Não produziu APK.
- Último CI de `main` auditado: falhou no verificador de referências externas de fontes Kotlin. Logs listam tipos que têm usos no código, indicando falsos positivos no verificador atual; o Godot passou antes dessa etapa.
- Android SDK não está instalado no ambiente desta auditoria.

## Estado

Anime Nexus ainda não tem build, conteúdo de campanha nem arte final. Ver detalhes em `docs/IMPLEMENTATION_STATUS.md`.
