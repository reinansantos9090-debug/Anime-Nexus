# Requisitos de operação offline

## Invariantes de produto

O primeiro lançamento e todos os ciclos de jogo devem funcionar sem conta, serviço remoto, anúncio, analytics online, verificação remota ou download de conteúdo. Builds podem buscar dependências/artifacts durante CI, mas APK de distribuição deve carregar todo recurso necessário. Multiplayer não existe; companheiros são IA local. “Diárias” não usam relógio de servidor: atividades são rotativas por sessão ou calendário local, sem perder recompensas por ausência.

## Dados e saves

- Três slots locais, schema versionado e um backup anterior por slot; checksum ainda não foi implementado.
- A gravação escreve um .tmp, faz flush, confere se o JSON pode ser lido, copia o save anterior para .bak e renomeia o temporário. O save ativo é removido antes do rename; se houver interrupção nessa janela, a recuperação depende do backup/temporário e ainda não é atômica em todas as plataformas.
- Migração de schema aplica defaults sem sobrescrever dados conhecidos; saves de schema futuro são protegidos contra sobrescrita. JSON inválido tenta recuperação por backup e temporário.
- Progresso persiste: campanha/flags, missões e objetivos, inventário, recursos, equipamento/sets, XP/maestria, desbloqueios, colecionáveis, mapas e configurações.
- Save não depende de timestamp de rede; relógio do dispositivo não entrega moeda paga nem conteúdo.

## Testes de aceitação

1. Instalar APK novo em modo avião, abrir e começar campanha.
2. Completar objetivo, obter recurso, equipar melhoria e salvar; encerrar à força, reiniciar e conferir estado.
3. Repetir em cada slot; confirmar isolamento de slots.
4. Simular arquivo parcial/corrompido e confirmar restauração de backup ou recuperação segura sem apagar original.
5. Atualizar build sobre save anterior e validar migração.
6. Remover rede durante todas as telas/expedição; confirmar zero chamadas obrigatórias.
7. Verificar que o APK Godot exportado não contém a permissão Android `INTERNET`; o preset agora a desativa explicitamente, mas o manifesto final ainda aguarda inspeção manual.

## Auditoria atual

Godot `save_service.gd` implementa três slots, backup por slot, arquivo temporário, flush, validação JSON, recuperação de backup/temporário e migração de schema; checksum e substituição atômica garantida ainda faltam. O Android host legado não declara permissão INTERNET, e o preset Godot agora define `permissions/internet=false`; o manifesto do APK Godot não foi inspecionado. Nenhuma dependência Firebase/HTTP obrigatória foi observada nos scripts/runtime atuais. Estado: **Em desenvolvimento**; modo avião e persistência ainda precisam ser validados no APK Godot final.
