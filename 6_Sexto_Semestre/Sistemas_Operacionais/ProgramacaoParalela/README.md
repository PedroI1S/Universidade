# ProgramacaoParalela

Total de arquivos de programacao neste ramo: 4

## O que cada codigo faz

- lock.cpp: executa duas threads concorrentes (uma incrementa e outra decrementa) protegendo o contador com omp_lock_t.
- omp.cpp: aproxima o valor de pi pela serie de Leibniz usando paralelizacao com OpenMP e acumulacao atomica.
- soma_de_array.cpp: inicializa dois vetores em paralelo e calcula suas somas com acumuladores locais por thread e secao critica.
- SomarValVetor.cpp: soma dois vetores pequenos em paralelo com secao critica para evitar condicao de corrida.
