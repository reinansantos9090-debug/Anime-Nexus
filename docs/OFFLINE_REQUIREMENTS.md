# Requisitos de operação offline

## Invariantes de produto

O primeiro lançamento e todos os ciclos de jogo devem funcionar sem conta, serviço remoto, anúncio, analytics online, verificação remota ou download de conteúdo. Builds podem buscar dependências/artifacts durante CI, mas APK de distribuição deve carregar todo recurso necessário. Multiplayer não existe; companheiros são IA local. “Diárias” não usam relógio de servidor: atividades são rotativas por sessão ou calendário local, sem perder recompensas por ausência.

## Dados e saves

- Três slots nomeados, versão de schema e checksum; autosave em checkpoints e pausa/fechamento.
- Escrita em arquivo temporário, flush, validação e rename atômico; manter um backup anterior por slot.
- Migração idempotente com valor padrão; nunca apagar save ao encontrar versão desconhecida ou JSON incompleto.
- Progresso persiste: campanha/flags, missões e objetivos, inventário, recursos, equipamento/sets, XP/maestria, desbloqueios, colecionáveis, mapas e configurações.
- Save não depende de timestamp de rede; relógio do dispositivo não entrega moeda paga nem conteúdo.

## Testes de aceitação

1. Instalar APK novo em modo avião, abrir e começar campanha.
2. Completar objetivo, obter recurso, equipar melhoria e salvar; encerrar à força, reiniciar e conferir estado.
3. Repetir em cada slot; confirmar isolamento de slots.
4. Simular arquivo parcial/corrompido e confirmar restauração de backup ou recuperação segura sem apagar original.
5. Atualizar build sobre save anterior e validar migração.
6. Remover rede durante todas as telas/expedição; confirmar zero chamadas obrigatórias.
7. Verificar manifesto Android sem permission `INTERNET` no app final, salvo necessidade explícita documentada que não seja requisito de jogo.

## Auditoria atual

Godot `save_service.gd` grava um JSON e backup de forma direta, autosave em intervalo e ao fechar; não oferece três slots, checksum, migração de schema nem transação/rename atômico. Kotlin usa `OfflineSaveCodec` local, mas só existe um fluxo demonstrado pelo teste de round-trip. Nenhuma dependência Firebase/HTTP foi observada nos arquivos de runtime atuais; isso deve ser reavaliado em toda dependência nova. Estado: **Em desenvolvimento**, não certificável como offline absoluto até testes no APK final.
