# Roteiro de desenvolvimento

## Marco 0 — Auditoria e preparação (atual)

- [x] Confirmar repositório, branch padrão e checkout separado.
- [x] Inventariar Kotlin/OpenGL, Godot, dependências, assets, testes e workflow.
- [x] Comparar motores e registrar decisão provisória para slice.
- [x] Avaliar AI Studio e registrar limites relevantes.
- [x] Publicar branch e abrir PR sem escrita em `main`; o CI mostrou bloqueio de compilação Kotlin.
- [x] Fechar o conjunto de documentos concretos desta fase.

## Marco 1 — Vertical slice de Kaien/Nimbara

Critério: APK Android Godot instalável em landscape; salvar/reabrir offline; controlar Kaien por joystick; três ações de combate; arena Nimbara curta com rota e obstáculo; um inimigo comum, uma criatura especial e chefe com duas fases/ataques telegráficos; missão narrativa com diálogos; capturas reais do jogo; sem placeholders apresentados como arte final.

Status atual: slice em implementação, ainda sem aceite. Já existe fluxo headless de missão, chefe e Âncora, controles analógicos, mapa e visuais blockout. CI Godot 4.7.2 e export APK do commit `28fe837` passaram na [run 43405149123](https://github.com/reinansantos9090-debug/Anime-Nexus/actions/runs/43405149123). Faltam instalação/teste de toque e tela em aparelho, telegraphs do chefe e substituição dos blockouts por modelos/animações originais. Arte final, música e FPS não foram validados.

## Marco 2 — Sistemas de produto

Persistência em três slots e migração; inventário/equipamento com custos atômicos; quest graph e diálogos localizados; companions IA; menus reais; registro de configurações; telemetria local/perfis gráficos; bestiário e colecionáveis.

## Marco 3 — Conteúdo de campanha

Construir oito mundos em lotes, oito personagens (modelos, rigs, animações e papéis IA), chefes com fases legíveis, 60 missões principais e 45+ secundárias; validar estados e desbloqueios. Conteúdo só recebe estado Implementado quando está ligado ao runtime e ao save.

## Marco 4 — Conteúdo adicional

Doze masmorras distintas, portais offline com modificadores, eventos acionados por sessão, mascotes, quatro transportes, cosméticos, colecionáveis, pós-jogo e chefe secreto.

## Marco 5 — Arte, áudio e otimização

Substituir cada provisório no manifest; criar trilhas e SFX locais; validar direção de arte com capturas do app; perfilar em aparelhos baixo/médio/alto; otimizar gargalos medidos; garantir acessibilidade e controles configuráveis.

## Marco 6 — Aceitação final

Build reproduzível, instalação/atualização, teste em modo avião, três saves e recuperação, compatibilidade de aparelhos, desempenho medido, regressão narrativa, créditos/licenças e lista de pendências. Não declarar completo enquanto houver critérios pendentes.
