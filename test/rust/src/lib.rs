//! 数值验证样例 (纯 std 整数, 禁浮点)。
//! 用户自由添加 #[test] 函数; 分类约定见 test/README.md。

/// 数值正确性: 主权 LCM 总量 = 3¹¹ × 2¹⁶ (整数精确, 对照 Agda Base/Invariants)
#[test]
fn lcm_total_matches_3p11_times_2p16() {
    let three_pow_11: u64 = 3u64.pow(11); // 177147
    let two_pow_16: u64 = 1u64 << 16;     // 65536
    assert_eq!(three_pow_11.checked_mul(two_pow_16), Some(11_609_505_792));
}

/// 数值正确性: 144 × 46 = 6624 (缠绕数锚点)
#[test]
fn grand_pump_matches_144_times_46() {
    assert_eq!(144u64 * 46u64, 6624u64);
}

/// 数值精度: 定点 √3 = 173205/100000 的整数判定 |173205² − 3·100000²| < 25 万
/// (即相对误差 < 7.6e-6, 全程整数, 不用浮点)
#[test]
fn fixed_sqrt3_within_tight_bound() {
    let num: i64 = 173205;
    let den: i64 = 100000;
    let diff = (num * num - 3 * den * den).abs();
    assert!(diff < 250_000, "fixed √3 off by {}", diff);
}

/// 反例: 错误测试 — 故意断言 144×46=9999 (应为 6624), 必须被 cargo test 捕获
#[test]
fn wrong_anchor() {
    assert_eq!(144u64 * 46u64, 9999u64);
}
