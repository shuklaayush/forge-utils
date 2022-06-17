// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Trilean} from "./Trilean.sol";

struct IntervalUint256 {
    uint256 lo;
    uint256 hi;
}

// TODO: Move somewhere else?
function minmax(uint256 u1, uint256 u2) pure returns (uint256, uint256) {
    return (u1 < u2) ? (u1, u2) : (u2, u1);
}

// Ref: http://www.dmitry-kazakov.de/ada/intervals.htm
library IntervalUint256Lib {
    function fromVal(uint256 val)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(val, val);
    }

    function fromMeanAndTol(uint256 val, uint256 tol)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(val - tol, val + tol);
    }

    function fromMinAndTol(uint256 val, uint256 tol)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(val, val + tol);
    }

    function fromMaxAndTol(uint256 val, uint256 tol)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(val - tol, val);
    }

    function fromMeanAndTolBps(uint256 val, uint256 tolBps)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        uint256 tol = (val * tolBps) / 10_000;
        return IntervalUint256(val - tol, val + tol);
    }

    function fromMinAndTolBps(uint256 val, uint256 tolBps)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        uint256 tol = (val * tolBps) / 10_000;
        return IntervalUint256(val, val + tol);
    }

    function fromMaxAndTolBps(uint256 val, uint256 tolBps)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        uint256 tol = (val * tolBps) / 10_000;
        return IntervalUint256(val - tol, val);
    }

    function mean(IntervalUint256 memory u) internal pure returns (uint256) {
        return (u.lo + u.hi) / 2;
    }

    function size(IntervalUint256 memory u) internal pure returns (uint256) {
        return u.hi - u.lo;
    }

    // Arithmetic Operators

    function add(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo + u2, u1.hi + u2);
    }

    function sub(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo - u2, u1.hi - u2);
    }

    function subFrom(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u2 - u1.lo, u2 - u1.hi);
    }

    function mul(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo * u2, u1.hi * u2);
    }

    function div(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo / u2, u1.hi / u2);
    }

    function add(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo + u2.lo, u1.hi + u2.lo);
    }

    function sub(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo - u2.hi, u1.hi - u2.lo);
    }

    function mul(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo * u2.lo, u1.hi * u2.hi);
    }

    function div(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo / u2.hi, u1.hi / u2.lo);
    }

    function subDependent(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        return IntervalUint256(u1.lo - u2.lo, u1.hi - u2.hi);
    }

    function divDependent(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (IntervalUint256 memory)
    {
        (uint256 lo, uint256 hi) = minmax(u1.lo / u2.lo, u1.hi / u2.hi);
        return IntervalUint256(lo, hi);
    }

    // Logical Operators

    // Boolean
    // A la set theory

    function eq(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (bool)
    {
        return u1.lo == u2.lo && u1.hi == u2.hi;
    }

    function neq(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (bool)
    {
        return u1.lo != u2.lo || u1.hi != u2.hi;
    }

    // Relational Operators

    function contains(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (bool)
    {
        return u1.lo <= u2 && u2 <= u1.hi;
    }

    function contains(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (bool)
    {
        return u1.lo <= u2.lo && u2.hi <= u1.hi;
    }

    function lt(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (bool)
    {
        return u1.hi < u2;
    }

    function le(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (bool)
    {
        return u1.hi <= u2;
    }

    function gt(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (bool)
    {
        return u1.lo > u2;
    }

    function ge(IntervalUint256 memory u1, uint256 u2)
        internal
        pure
        returns (bool)
    {
        return u1.lo >= u2;
    }

    // Trilean
    // If:
    // - ∀ x ∈ [a,b] ∀ y ∈ [c,d] (x op y) => true
    // - ∀ x ∈ [a,b] ∀ y ∈ [c,d] !(x op y) => false
    // - otherwise => indeterminate

    function lt(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (Trilean)
    {
        if (u1.hi < u2.lo) {
            return Trilean.TRUE;
        } else if (u1.lo >= u2.hi) {
            return Trilean.FALSE;
        } else {
            return Trilean.INDETERMINATE;
        }
    }

    // not(gt)
    function le(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (Trilean)
    {
        if (u1.hi <= u2.lo) {
            return Trilean.TRUE;
        } else if (u1.lo > u2.hi) {
            return Trilean.FALSE;
        } else {
            return Trilean.INDETERMINATE;
        }
    }

    function gt(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (Trilean)
    {
        if (u1.lo > u2.hi) {
            return Trilean.TRUE;
        } else if (u1.hi <= u2.lo) {
            return Trilean.FALSE;
        } else {
            return Trilean.INDETERMINATE;
        }
    }

    // not(lt)
    function ge(IntervalUint256 memory u1, IntervalUint256 memory u2)
        internal
        pure
        returns (Trilean)
    {
        if (u1.lo >= u2.hi) {
            return Trilean.TRUE;
        } else if (u1.hi < u2.lo) {
            return Trilean.FALSE;
        } else {
            return Trilean.INDETERMINATE;
        }
    }
}

/*
TODO:
- How to implement logical operators on intervals? Should I compare low or high value in > etc.?
- Comments
- isIn() operator, add functions witht uint256 as first argument
*/
