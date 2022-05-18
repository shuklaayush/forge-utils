// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0 <0.9.0;

enum Trilean {
    FALSE,
    INDETERMINATE,
    TRUE
}

library TrileanLib {
    error Indeterminate();

    function fromBool(bool _b) internal pure returns (Trilean t_) {
        t_ = _b ? Trilean.TRUE : Trilean.FALSE;
    }

    function toBool(Trilean _t) internal pure returns (bool b_) {
        if (_t == Trilean.TRUE) {
            b_ = true;
        } else if (_t == Trilean.FALSE) {
            b_ = false;
        } else {
            revert Indeterminate();
        }
    }

    // ============
    // ||NOT     ||
    // ||========||
    // || F || T ||
    // ||---||---||
    // || I || I ||
    // ||---||---||
    // || T || F ||
    // ============
    // 2 - t
    function not(Trilean _t) internal pure returns (Trilean t_) {
        t_ = Trilean(2 - uint8(_t));
    }

    // ====================
    // ||AND|| F | I | T ||
    // ||================||
    // || F || F | F | F ||
    // ||---||---|---|---||
    // || I || F | I | I ||
    // ||---||---|---|---||
    // || T || F | I | T ||
    // ====================
    // min
    function and(Trilean _a, Trilean _b) internal pure returns (Trilean t_) {
        t_ = _a < _b ? _a : _b;
    }

    // ====================
    // ||OR || F | I | T ||
    // ||================||
    // || F || F | I | T ||
    // ||---||---|---|---||
    // || I || I | I | T ||
    // ||---||---|---|---||
    // || T || T | T | T ||
    // ====================
    // max
    function or(Trilean _a, Trilean _b) internal pure returns (Trilean t_) {
        t_ = _a > _b ? _a : _b;
    }
}
