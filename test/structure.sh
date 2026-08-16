#!/usr/bin/env bash
# 结构测试: Lean 数学库骨架是否镜像 src/Sovereign 的 26 个学术层。
# 红/绿纪律的红侧 —— 骨架未建时全部 FAIL。
set -u
ROOT="LeanMathematics"
LEAN="${LEAN:-lean}"
fail=0

check_dir()  { [ -d "$1" ] || { echo "MISSING DIR:  $1"; fail=1; }; }
check_file() { [ -f "$1" ] || { echo "MISSING FILE: $1"; fail=1; }; }

# 26 个学术层
LAYERS="AI Algebra Analysis Applied Arithmetic Base Coding Completeness \
Constitution Coupling Density Diagnosis Engine Format Geometry HoTT \
MetaStructure PDE Physics Problem Projection Quantum RootMath Structology \
Topology Trust"
for L in $LAYERS; do check_dir "$ROOT/$L"; done

# 根文件
check_file "lakefile.toml"
check_file "lean-toolchain"
check_file "LeanMathematics.lean"
check_file "$ROOT/All.lean"

# 学术核心模块镜像 (Agda ↔ Lean)
for f in \
  Base/Trit Base/Invariants \
  RootMath/Eisenstein \
  Algebra/GF9 Algebra/GaloisBridge \
  Arithmetic/CRTLemmas \
  Format/CRT \
  Structology/T6 Structology/A4Group Structology/A4Representations Structology/Winding \
  HoTT/T6Homotopy HoTT/ChernClass \
  MetaStructure/WuXing \
  Topology/HighDimClosure \
  Quantum/Foundation \
  Geometry/ProjectiveCore Geometry/ConformalCore \
  Coding/TritCode \
  Constitution/Boundaries \
  Coupling/LossGain Coupling/ParityViolation Coupling/SpinTwistor \
  Physics/EntropySpinLaw Physics/EntropySpinQuantize Physics/DiscreteMaxwellTime \
  Physics/RightHandedNeutrinoTheorem Physics/InvisibleOrbitCount \
  Physics/VectorFieldGeometricPhase Physics/DataAnchors; do
  check_file "$ROOT/$f.lean"
done

# 千禧问题层
for p in BSD Hilbert Hodge Kakeya Langlands NavierStokes PvsNP Riemann YangMills; do
  check_dir "$ROOT/Problem/$p"
done

# 每个存根 (无 import) 须能独立解析; 聚合器 All.lean 的 import 行须指向存在文件
imports_bad=0
for f in $(find "$ROOT" -name '*.lean' 2>/dev/null | sort); do
  if grep -q '^import ' "$f" 2>/dev/null; then
    while IFS= read -r m; do
      case "$m" in
        LeanMathematics.*)
          tf="$(echo "$m" | tr '.' '/').lean"
          [ -f "$tf" ] || { echo "MISSING IMPORT TARGET: $m (from $f)"; imports_bad=1; } ;;
        *) ;;  # 外部依赖 (Mathlib 等) 由 lake 解析, 不在结构校验内
      esac
    done < <(grep '^import ' "$f" | sed 's/^import //')
  else
    "$LEAN" "$f" >/dev/null 2>&1 || { echo "PARSE FAIL:  $f"; fail=1; }
  fi
done
[ $imports_bad -ne 0 ] && fail=1

if [ $fail -eq 0 ]; then echo "STRUCTURE OK"; else echo "STRUCTURE FAIL"; exit 1; fi
