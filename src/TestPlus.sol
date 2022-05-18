// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0 <0.9.0;

import {Test} from "forge-std/Test.sol";

import {IntervalUint256, IntervalUint256Lib} from "./libraries/IntervalUint256.sol";
import {Trilean, TrileanLib} from "./libraries/Trilean.sol";

contract TestPlus is Test {
    // =====================
    // ===== Libraries =====
    // =====================

    using IntervalUint256Lib for IntervalUint256;
    using TrileanLib for Trilean;

    // ==========================
    // ===== Util Functions =====
    // ==========================

    function getAddress(string memory _name)
        internal
        pure
        returns (address addr_)
    {
        addr_ = address(uint160(uint256(keccak256(bytes(_name)))));
    }

    // ========================
    // ===== Extra Cheats =====
    // =========================

    function dealMore(
        address _token,
        address _to,
        uint256 _amount
    ) public {
        (, bytes memory rdat) = _token.staticcall(
            abi.encodeWithSignature("balanceOf(address)", _to)
        );
        uint256 balance = abi.decode(rdat, (uint256));

        deal(_token, _to, balance + _amount, true);
    }

    // =========================
    // ===== Extra Asserts =====
    // =========================

    function assertZe(uint256 a) internal {
        if (a != 0) {
            emit log("Error: a == 0 not satisfied [uint]");
            emit log_named_uint("    Value", a);
            fail();
        }
    }

    function assertContains(IntervalUint256 memory a, IntervalUint256 memory b)
        internal
    {
        if (!a.contains(b)) {
            emit log("Error: (b in a) not satisfied [IntervalUint256]");
            if (b.size() == 0) {
                emit log_named_uint("       Expected", b.lo);
            } else {
                emit log_named_uint("  Expected (lo)", b.lo);
                emit log_named_uint("           (hi)", b.hi);
            }
            if (a.size() == 0) {
                emit log_named_uint("         Actual", a.lo);
            } else {
                emit log_named_uint("    Actual (lo)", a.lo);
                emit log_named_uint("           (hi)", a.hi);
            }
            fail();
        }
    }

    function assertEq(IntervalUint256 memory a, uint256 b) internal {
        assertContains(a, IntervalUint256Lib.fromVal(b));
    }

    function assertEq(uint256 a, IntervalUint256 memory b) internal {
        assertContains(b, IntervalUint256Lib.fromVal(a));
    }

    function assertLt(IntervalUint256 memory a, IntervalUint256 memory b)
        internal
    {
        if (a.lt(b) != Trilean.TRUE) {
            emit log("Error: a < b not satisfied [IntervalUint256]");
            if (b.size() == 0) {
                emit log_named_uint("       Expected", b.lo);
            } else {
                emit log_named_uint("  Expected (lo)", b.lo);
                emit log_named_uint("           (hi)", b.hi);
            }
            if (a.size() == 0) {
                emit log_named_uint("         Actual", a.lo);
            } else {
                emit log_named_uint("    Actual (lo)", a.lo);
                emit log_named_uint("           (hi)", a.hi);
            }
            fail();
        }
    }

    function assertLt(IntervalUint256 memory a, uint256 b) internal {
        assertLt(a, IntervalUint256Lib.fromVal(b));
    }

    function assertLt(uint256 a, IntervalUint256 memory b) internal {
        assertLt(IntervalUint256Lib.fromVal(a), b);
    }

    function assertLe(IntervalUint256 memory a, IntervalUint256 memory b)
        internal
    {
        if (a.le(b) != Trilean.TRUE) {
            emit log("Error: a <= b not satisfied [IntervalUint256]");
            if (b.size() == 0) {
                emit log_named_uint("       Expected", b.lo);
            } else {
                emit log_named_uint("  Expected (lo)", b.lo);
                emit log_named_uint("           (hi)", b.hi);
            }
            if (a.size() == 0) {
                emit log_named_uint("         Actual", a.lo);
            } else {
                emit log_named_uint("    Actual (lo)", a.lo);
                emit log_named_uint("           (hi)", a.hi);
            }
            fail();
        }
    }

    function assertLe(IntervalUint256 memory a, uint256 b) internal {
        assertLe(a, IntervalUint256Lib.fromVal(b));
    }

    function assertLe(uint256 a, IntervalUint256 memory b) internal {
        assertLe(IntervalUint256Lib.fromVal(a), b);
    }

    function assertGt(IntervalUint256 memory a, IntervalUint256 memory b)
        internal
    {
        if (a.gt(b) != Trilean.TRUE) {
            emit log("Error: a > b not satisfied [IntervalUint256]");
            if (b.size() == 0) {
                emit log_named_uint("       Expected", b.lo);
            } else {
                emit log_named_uint("  Expected (lo)", b.lo);
                emit log_named_uint("           (hi)", b.hi);
            }
            if (a.size() == 0) {
                emit log_named_uint("         Actual", a.lo);
            } else {
                emit log_named_uint("    Actual (lo)", a.lo);
                emit log_named_uint("           (hi)", a.hi);
            }
            fail();
        }
    }

    function assertGt(IntervalUint256 memory a, uint256 b) internal {
        assertGt(a, IntervalUint256Lib.fromVal(b));
    }

    function assertGt(uint256 a, IntervalUint256 memory b) internal {
        assertGt(IntervalUint256Lib.fromVal(a), b);
    }

    function assertGe(IntervalUint256 memory a, IntervalUint256 memory b)
        internal
    {
        if (a.ge(b) != Trilean.TRUE) {
            emit log("Error: a >= b not satisfied [IntervalUint256]");
            if (b.size() == 0) {
                emit log_named_uint("       Expected", b.lo);
            } else {
                emit log_named_uint("  Expected (lo)", b.lo);
                emit log_named_uint("           (hi)", b.hi);
            }
            if (a.size() == 0) {
                emit log_named_uint("         Actual", a.lo);
            } else {
                emit log_named_uint("    Actual (lo)", a.lo);
                emit log_named_uint("           (hi)", a.hi);
            }
            fail();
        }
    }

    function assertGe(IntervalUint256 memory a, uint256 b) internal {
        assertGe(a, IntervalUint256Lib.fromVal(b));
    }

    function assertGe(uint256 a, IntervalUint256 memory b) internal {
        assertGe(IntervalUint256Lib.fromVal(a), b);
    }
}

/*
TODO:
- Maybe remove contains syntax
*/
