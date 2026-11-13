# Direção de arte visual

## Linguagem visual

Fantasia anime original com leitura a 3/4 de cima: formas claras, silhuetas contrastadas, paletas por ressonância e cenários com grande composição, mas poucos elementos de ruído no plano de combate. A referência de mercado informa ritmo, densidade e legibilidade, nunca desenho/cor/ícone copiado de jogo existente.

## Personagens

Modelos estilizados 3D com rosto, cabelo e roupa modelados para leitura mobile; proportions consistentes, material de pele/cabelo/tecido próprio, peças de equipamento substituíveis e rigs compatíveis. Cabelo e tecido recebem secundária simples e barata, desligável. Pose e shape language tornam cada protagonista identificável na câmera isométrica. Face anima diálogo importante e expressões principais; não exigir captura facial de alta frequência em combate.

## Cenários

Cada mapa tem ponto de referência em silhueta, rotas legíveis, variação vertical jogável e primeiro plano que não obscurece o personagem. Texturas estilizadas em atlas quando útil, materiais compartilhados por bioma, vegetação instanciada e objetos interativos com resposta visual. Vegetação/cristais/água/céu usam animação sutil; área de batalha preserva contraste para telegraphs.

## Render e mobile

Cel/toon shading moderado (2–3 bandas com ramp), contorno seletivo em personagem/inimigo, rim light econômico; sombra principal simples e distância limitada; iluminação ambiental pré-calculada quando compatível; reflexo planar/SSR não é padrão. Partículas agrupadas e com limite por perfil; bloom só em regiões emissivas e com opção reduzir. LOD, frustum/occlusion culling e resolução adaptativa só entram após profiling real. Priorizar estabilidade de frame e legibilidade; não alegar FPS sem aparelho e captura de frame time.

## UI, acessibilidade e câmera

Landscape e proporção variável. HUD tem regiões seguras, tamanho tipográfico testado a distância do telefone, configurações de contraste, alvo assistido, escala/posição de botões, sensibilidade, redução de flashes/partículas e legendas brasileiras. Câmera isométrica fixa com zoom ajustável em pequenos passos; occluder translúcido quando árvore/estrutura cobre player. VFX usa forma e ícone além da cor para diferenciar elemento.

## Aprovação de arte

Conceito, render em editor ou arte gerada não prova qualidade do runtime. Aprovar usando screenshot/vídeo de APK instalado, com HUD, câmera, movimento e combate. Arte final tem autor/origem, licença, resolução/LOD, materiais e clipes registrados. Qualquer mesh por primitivas é `Provisório`.
