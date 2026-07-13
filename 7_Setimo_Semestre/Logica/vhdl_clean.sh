#!/usr/bin/env zsh
set -euo pipefail

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
  echo "Uso: ./vhdl_clean.sh <projectDir> [tbName]"
  echo "Exemplo: ./vhdl_clean.sh projeto2 alu4_tb"
  exit 1
fi

PROJECT_DIR="$1"
TB_NAME="${2:-}"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$ROOT_DIR/$PROJECT_DIR"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Erro: pasta do projeto nao encontrada: $TARGET_DIR"
  exit 1
fi

cd "$TARGET_DIR"
setopt null_glob

echo "Limpando artefatos em: $TARGET_DIR"
rm -f -- *.cf *.o e~*.o wave.vcd

if [[ -n "$TB_NAME" ]]; then
  rm -f -- "$TB_NAME"
  echo "Executavel removido: $TB_NAME"
else
  echo "Nenhum tbName informado; executaveis nao foram removidos."
  echo "Para remover tambem o executavel, use: ./vhdl_clean.sh $PROJECT_DIR <tbName>"
fi

echo "Limpeza concluida."
