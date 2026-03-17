# Trabalho3

Total de arquivos de programacao neste ramo: 2

## O que cada codigo faz

- FatorialCritical.cpp: calcula fatorial em paralelo com OpenMP; cada thread calcula produto parcial e combina resultado na regiao critical.
- FatorialLock.cpp: calcula fatorial em paralelo com OpenMP usando lock explicito (omp_lock_t) para sincronizar a multiplicacao global.
