// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

import {Test} from "../src/Test.sol";
import {IntervalUint256, IntervalUint256Utils} from "../src/libraries/IntervalUint256.sol";

contract IntervalUint256Test is Test {
    using IntervalUint256Utils for IntervalUint256;

    function testAssertEq() public {
        uint256 a = 5;
        IntervalUint256 memory b = IntervalUint256(4, 6);

        assertEq(a, b);
    }

    function testFailAssertEq() public {
        uint256 a = 5;
        IntervalUint256 memory b = IntervalUint256(6, 7);

        assertEq(a, b);
    }
}
