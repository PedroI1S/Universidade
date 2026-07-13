#!/usr/bin/env zsh
set -euo pipefail

if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
  echo "Uso: ./vhdl_run.sh <projectDir> <tbName> [--open]"
  echo "Exemplo: ./vhdl_run.sh projeto1 teste_tb --open"
  exit 1
fi

PROJECT_DIR="$1"
TB_NAME="$2"
OPEN_WAVE="${3:-}"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$ROOT_DIR/$PROJECT_DIR"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Erro: pasta do projeto nao encontrada: $TARGET_DIR"
  exit 1
fi

cd "$TARGET_DIR"

echo "[1/3] Analisando arquivos VHDL..."
setopt local_options null_glob
pkgs=( *_pkg.vhd *_pkg.vhdl )
if (( ${#pkgs} )); then
  ghdl -a --std=08 ${pkgs}     # pacotes primeiro (dependencia das entidades)
fi
setopt extendedglob
non_pkgs=( *.vhd~*_pkg.vhd *.vhdl~*_pkg.vhdl )
if (( ${#non_pkgs} )); then
  ghdl -a --std=08 ${non_pkgs}  # demais arquivos (pacotes ja na lib, sem re-analisar)
fi

echo "[2/3] Elaborando testbench: $TB_NAME"
ghdl -e --std=08 "$TB_NAME"

echo "[3/3] Rodando simulacao e gerando wave.vcd e wave.ghw..."
ghdl -r --std=08 "$TB_NAME" --vcd=wave.vcd --wave=wave.ghw

echo "Simulacao concluida. Arquivos gerados: $TARGET_DIR/wave.vcd e $TARGET_DIR/wave.ghw"

if [[ "$OPEN_WAVE" == "--open" ]]; then
  if command -v surfer >/dev/null 2>&1; then
    echo "Abrindo waveform no Surfer (priorizando GHW)..."
    if [[ -f wave.ghw ]]; then
      surfer wave.ghw || true
    else
      surfer wave.vcd || true
    fi
  fi

  if command -v gtkwave >/dev/null 2>&1; then
    echo "Fallback disponivel: GTKWave"
  else
    echo "Se o Surfer falhar, instale fallback com: brew install gtkwave"
  fi
fi
