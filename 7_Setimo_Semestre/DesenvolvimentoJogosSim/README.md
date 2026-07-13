# Versoes LibGDX

Esta pasta contem 4 projetos LibGDX independentes:

- versao1: versao completa baseada no projeto atual (logo libGDX).
- versao2: esqueleto minimo executavel.
- versao3: esqueleto minimo executavel.
- versao4: esqueleto minimo executavel.

## Requisitos

- JDK 21 (ou superior).
- macOS: ao rodar no terminal, use o launcher Gradle da pasta da versao.

## Como rodar

### Versao 1

```bash
cd versao1
./gradlew lwjgl3:run
```

### Versao 2

```bash
cd versao2
./gradlew lwjgl3:run
```

### Versao 3

```bash
cd versao3
./gradlew lwjgl3:run
```

### Versao 4

```bash
cd versao4
./gradlew lwjgl3:run
```

## Build rapido (sem abrir janela)

```bash
./gradlew core:classes lwjgl3:classes
```

---

Total de arquivos de programacao neste ramo: 26

## Subpastas

- versao1: 23 arquivo(s) de programacao (jogo Bow and Arrow em libGDX)
- versoes_libgdx: 3 arquivo(s) de programacao (esqueleto base LibGDXcru)

## O que cada codigo faz

### versao1 (Bow and Arrow)

- Main.java: classe principal do jogo; gerencia as screens e o AssetManager, iniciando pela LoadingScreen.
- entities/Archer.java: arqueiro controlado pelo jogador, com animacao por TextureAtlas, som e hitbox circular.
- entities/Arrow.java: flecha disparada pelo arqueiro, com trajetoria propria e som de disparo por instancia.
- entities/Enemy.java: inimigo com animacao, movimentacao e hitbox composta para colisao com flechas.
- entities/EnemyBoss.java: inimigo chefe, variacao do Enemy com hitbox composta propria.
- entities/Particle.java: particula visual de impacto com duracao controlada por timer interno.
- entities/SpeechBubble.java: balao de fala desenhado com NinePatch e BitmapFont para mensagens no jogo.
- hitbox/Hitbox.java: interface base que define o contrato de todos os tipos de hitbox.
- hitbox/CircleHitbox.java: hitbox circular com colisao ponto-circulo e circulo-retangulo por distancia euclidiana.
- hitbox/RectangleHitbox.java: hitbox retangular simples (AABB).
- hitbox/CompoundHitbox.java: hitbox composta que agrega varias hitboxes para objetos com multiplas partes.
- hitbox/WallCollider.java: colisao com as 4 paredes do mapa usando hitboxes retangulares.
- input/GameInputProcessor.java: InputProcessor customizado que registra as teclas de movimento e acao.
- net/PlayerStatePacket.java: pacote binario (ByteBuffer) com o estado do jogador para o modo em rede.
- pools/ObjectPool.java: object pool generico para reutilizar instancias e reduzir garbage collection.
- pools/ArrowPool.java: pool de flechas com som de disparo compartilhado.
- pools/EnemyPool.java: pool de inimigos com criacao sob demanda a partir do TextureAtlas.
- pools/ParticlePool.java: pool de particulas de impacto.
- screens/LoadingScreen.java: tela de carregamento que enfileira os assets no AssetManager.
- screens/GameScreen.java: tela principal com o loop do jogo (render, camera, spawns, colisoes, HUD e audio).
- util/GameTimer.java: timer simples baseado em delta time usado pelas entidades.
- lwjgl3/Lwjgl3Launcher.java: launcher desktop (LWJGL3) do jogo.
- lwjgl3/StartupHelper.java: helper da template libGDX que relanca a JVM quando necessario (macOS/Windows).

### versoes_libgdx (LibGDXcru)

- Main.java: esqueleto base libGDX que apenas limpa a tela (ponto de partida da versao 4).
- lwjgl3/Lwjgl3Launcher.java: launcher desktop (LWJGL3) do esqueleto.
- lwjgl3/StartupHelper.java: helper da template libGDX que relanca a JVM quando necessario.
