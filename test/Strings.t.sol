// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

import {Test} from "../src/Test.sol";
import {Strings} from "../src/libraries/Strings.sol";

contract StringsTest is Test {
    function testZero() public {
        assertEq(Strings.toString(0), "0");
    }

    function testPositive() public {
        assertEq(Strings.toString(20471234), "20471234");
    }

    function testNegative() public {
        assertEq(Strings.toString(1402114, true), "-1402114");
    }
}
