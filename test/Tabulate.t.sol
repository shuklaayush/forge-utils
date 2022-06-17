// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {TestPlus} from "../src/TestPlus.sol";
import {Alignment, Tabulate} from "../src/libraries/Tabulate.sol";

contract TabulateTest is TestPlus {
    function testPadLeft() public {
        assertEq(Tabulate.padLeft("123", 5), "  123");
    }

    function testPadRight() public {
        assertEq(Tabulate.padRight("123", 5), "123  ");
    }

    function testFormatRow() public {
        string[] memory row = new string[](2);
        row[0] = "test";
        row[1] = "123";

        uint256[] memory widths = new uint256[](2);
        widths[0] = 5;
        widths[1] = 5;

        Alignment[] memory alignments = Tabulate.getDefaultAlignments(2);

        assertEq(
            Tabulate.formatRow(row, widths, alignments),
            "| test  |   123 |"
        );
    }
}
