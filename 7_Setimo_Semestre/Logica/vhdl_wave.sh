#!/usr/bin/env zsh
set -euo pipefail

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
  echo "Uso: ./vhdl_wave.sh <projectDir> [ghw|vcd]"
  echo "Exemplo: ./vhdl_wave.sh projeto2"
  echo "Exemplo: ./vhdl_wave.sh projeto2 vcd"
  exit 1
fi

PROJECT_DIR="$1"
PREFERRED_FORMAT="${2:-ghw}"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$ROOT_DIR/$PROJECT_DIR"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Erro: pasta do projeto nao encontrada: $TARGET_DIR"
  exit 1
fi

cd "$TARGET_DIR"

if ! command -v surfer >/dev/null 2>&1; then
  echo "Erro: surfer nao encontrado no PATH."
  echo "Instale com: brew install surfer"
  exit 1
fi

WAVE_FILE=""
if [[ "$PREFERRED_FORMAT" == "vcd" ]]; then
  if [[ -f wave.vcd ]]; then
    WAVE_FILE="wave.vcd"
  elif [[ -f wave.ghw ]]; then
    WAVE_FILE="wave.ghw"
  fi
else
  if [[ -f wave.ghw ]]; then
    WAVE_FILE="wave.ghw"
  elif [[ -f wave.vcd ]]; then
    WAVE_FILE="wave.vcd"
  fi
fi

if [[ -z "$WAVE_FILE" ]]; then
  echo "Erro: nenhum arquivo de onda encontrado (wave.ghw ou wave.vcd)."
  echo "Rode antes: ./vhdl_run.sh $PROJECT_DIR <tbName>"
  exit 1
fi

echo "Abrindo grafico: $TARGET_DIR/$WAVE_FILE"
surfer "$WAVE_FILE"
