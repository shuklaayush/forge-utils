// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/Vm.sol";

contract ContractTest is DSTest {
    Vm internal constant vm = Vm(HEVM_ADDRESS);

    function setUp() public {}

    function testExample() public {
        assertTrue(true);
    }
}
