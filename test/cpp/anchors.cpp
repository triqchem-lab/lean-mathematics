// 数值正确性样例: 对照形式化锚点 (对照 Agda Base/Invariants + math lcm_constants.h)
// 用户可仿此自由添加更多 .cpp 测试用例, 自动被 CMake glob + ctest 收集。
#include "lcm_constants.h"
#include <cstdint>
using namespace sov::math;

int main() {
  // 缠绕数锚点
  static_assert(POLAR_WINDING == 144, "POLAR_WINDING = 144");
  static_assert(TOROIDAL_WINDING == 46, "TOROIDAL_WINDING = 46");
  static_assert(GRAND_PUMP == 6624, "GRAND_PUMP = 6624");
  static_assert(GRAND_PUMP == POLAR_WINDING * TOROIDAL_WINDING, "144 * 46 = 6624");
  // 陈数锚点 C = ±2
  static_assert(CHERN_TARGET == 2, "CHERN_TARGET = 2");
  // 主权 LCM 总量 3¹¹ × 2¹⁶
  static_assert(LCM_TOTAL == 11609505792ULL, "LCM_TOTAL = 3^11 * 2^16");
  return 0;
}
