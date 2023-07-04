// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0 <0.9.0;

import {Vm} from "forge-std/Vm.sol";
import {console2 as console} from "forge-std/console2.sol";

import {IMulticall3} from "./interfaces/IMulticall3.sol";
import {Strings} from "./libraries/Strings.sol";
import {Tabulate} from "./libraries/Tabulate.sol";

struct InitializableUint256 {
    uint256 val;
    bool initialized;
}

bytes constant MULTICALL3_BYTECODE =
    hex"6080604052600436106100f35760003560e01c80634d2301cc1161008a578063a8b0574e11610059578063a8b0574e1461022f578063bce38bd71461024a578063c3077fa91461025d578063ee82ac5e1461027057600080fd5b80634d2301cc146101ce57806372425d9d146101f657806382ad56cb1461020957806386d516e81461021c57600080fd5b80633408e470116100c65780633408e47014610173578063399542e9146101865780633e64a696146101a857806342cbb15c146101bb57600080fd5b80630f28c97d146100f8578063174dea711461011a578063252dba421461013a57806327e86d6e1461015b575b600080fd5b34801561010457600080fd5b50425b6040519081526020015b60405180910390f35b61012d61012836600461098c565b61028f565b6040516101119190610a89565b61014d61014836600461098c565b61047d565b604051610111929190610aa3565b34801561016757600080fd5b50436000190140610107565b34801561017f57600080fd5b5046610107565b610199610194366004610b0d565b6105f1565b60405161011193929190610b67565b3480156101b457600080fd5b5048610107565b3480156101c757600080fd5b5043610107565b3480156101da57600080fd5b506101076101e9366004610b8f565b6001600160a01b03163190565b34801561020257600080fd5b5044610107565b61012d61021736600461098c565b61060c565b34801561022857600080fd5b5045610107565b34801561023b57600080fd5b50604051418152602001610111565b61012d610258366004610b0d565b61078e565b61019961026b36600461098c565b610921565b34801561027c57600080fd5b5061010761028b366004610bb8565b4090565b60606000828067ffffffffffffffff8111156102ad576102ad610bd1565b6040519080825280602002602001820160405280156102f357816020015b6040805180820190915260008152606060208201528152602001906001900390816102cb5790505b5092503660005b8281101561041f57600085828151811061031657610316610be7565b6020026020010151905087878381811061033257610332610be7565b90506020028101906103449190610bfd565b60408101359586019590935061035d6020850185610b8f565b6001600160a01b0316816103746060870187610c1d565b604051610382929190610c64565b60006040518083038185875af1925050503d80600081146103bf576040519150601f19603f3d011682016040523d82523d6000602084013e6103c4565b606091505b5060208085019190915290151580845290850135176104155762461bcd60e51b6000526020600452601760245276135d5b1d1a58d85b1b0cce8818d85b1b0819985a5b1959604a1b60445260846000fd5b50506001016102fa565b508234146104745760405162461bcd60e51b815260206004820152601a60248201527f4d756c746963616c6c333a2076616c7565206d69736d6174636800000000000060448201526064015b60405180910390fd5b50505092915050565b436060828067ffffffffffffffff81111561049a5761049a610bd1565b6040519080825280602002602001820160405280156104cd57816020015b60608152602001906001900390816104b85790505b5091503660005b828110156105e75760008787838181106104f0576104f0610be7565b90506020028101906105029190610c74565b92506105116020840184610b8f565b6001600160a01b03166105276020850185610c1d565b604051610535929190610c64565b6000604051808303816000865af19150503d8060008114610572576040519150601f19603f3d011682016040523d82523d6000602084013e610577565b606091505b5086848151811061058a5761058a610be7565b60209081029190910101529050806105de5760405162461bcd60e51b8152602060048201526017602482015276135d5b1d1a58d85b1b0cce8818d85b1b0819985a5b1959604a1b604482015260640161046b565b506001016104d4565b5050509250929050565b438040606061060186868661078e565b905093509350939050565b6060818067ffffffffffffffff81111561062857610628610bd1565b60405190808252806020026020018201604052801561066e57816020015b6040805180820190915260008152606060208201528152602001906001900390816106465790505b5091503660005b8281101561047457600084828151811061069157610691610be7565b602002602001015190508686838181106106ad576106ad610be7565b90506020028101906106bf9190610c8a565b92506106ce6020840184610b8f565b6001600160a01b03166106e46040850185610c1d565b6040516106f2929190610c64565b6000604051808303816000865af19150503d806000811461072f576040519150601f19603f3d011682016040523d82523d6000602084013e610734565b606091505b5060208084019190915290151580835290840135176107855762461bcd60e51b6000526020600452601760245276135d5b1d1a58d85b1b0cce8818d85b1b0819985a5b1959604a1b60445260646000fd5b50600101610675565b6060818067ffffffffffffffff8111156107aa576107aa610bd1565b6040519080825280602002602001820160405280156107f057816020015b6040805180820190915260008152606060208201528152602001906001900390816107c85790505b5091503660005b8281101561091757600084828151811061081357610813610be7565b6020026020010151905086868381811061082f5761082f610be7565b90506020028101906108419190610c74565b92506108506020840184610b8f565b6001600160a01b03166108666020850185610c1d565b604051610874929190610c64565b6000604051808303816000865af19150503d80600081146108b1576040519150601f19603f3d011682016040523d82523d6000602084013e6108b6565b606091505b50602083015215158152871561090e57805161090e5760405162461bcd60e51b8152602060048201526017602482015276135d5b1d1a58d85b1b0cce8818d85b1b0819985a5b1959604a1b604482015260640161046b565b506001016107f7565b5050509392505050565b6000806060610932600186866105f1565b919790965090945092505050565b60008083601f84011261095257600080fd5b50813567ffffffffffffffff81111561096a57600080fd5b6020830191508360208260051b850101111561098557600080fd5b9250929050565b6000806020838503121561099f57600080fd5b823567ffffffffffffffff8111156109b657600080fd5b6109c285828601610940565b90969095509350505050565b6000815180845260005b818110156109f4576020818501810151868301820152016109d8565b81811115610a06576000602083870101525b50601f01601f19169290920160200192915050565b600082825180855260208086019550808260051b84010181860160005b84811015610a7c57858303601f1901895281518051151584528401516040858501819052610a68818601836109ce565b9a86019a9450505090830190600101610a38565b5090979650505050505050565b602081526000610a9c6020830184610a1b565b9392505050565b600060408201848352602060408185015281855180845260608601915060608160051b870101935082870160005b82811015610aff57605f19888703018452610aed8683516109ce565b95509284019290840190600101610ad1565b509398975050505050505050565b600080600060408486031215610b2257600080fd5b83358015158114610b3257600080fd5b9250602084013567ffffffffffffffff811115610b4e57600080fd5b610b5a86828701610940565b9497909650939450505050565b838152826020820152606060408201526000610b866060830184610a1b565b95945050505050565b600060208284031215610ba157600080fd5b81356001600160a01b0381168114610a9c57600080fd5b600060208284031215610bca57600080fd5b5035919050565b634e487b7160e01b600052604160045260246000fd5b634e487b7160e01b600052603260045260246000fd5b60008235607e19833603018112610c1357600080fd5b9190910192915050565b6000808335601e19843603018112610c3457600080fd5b83018035915067ffffffffffffffff821115610c4f57600080fd5b60200191503681900382131561098557600080fd5b8183823760009101908152919050565b60008235603e19833603018112610c1357600080fd5b60008235605e19833603018112610c1357600080fdfea2646970667358221220225961b7db0956f67e7f127a2db53ff5bd0fbfa13a8ac2e61b105e9d5427d8b064736f6c634300080c0033";

contract DictionaryUint256 {
    ////////////////////////////////////////////////////////////////////////////
    // State
    ////////////////////////////////////////////////////////////////////////////

    string[] public keys;
    mapping(string => InitializableUint256) private values;

    ////////////////////////////////////////////////////////////////////////////
    // Errors
    ////////////////////////////////////////////////////////////////////////////

    error InvalidKey(string key);

    ////////////////////////////////////////////////////////////////////////////
    // Constructor
    ////////////////////////////////////////////////////////////////////////////

    constructor(string[] memory _keys, uint256[] memory _vals) {
        uint256 length = _keys.length;
        for (uint256 i; i < length; ++i) {
            string memory key = _keys[i];
            keys.push(key);
            values[key] = InitializableUint256(_vals[i], true);
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Public Functions
    ////////////////////////////////////////////////////////////////////////////

    function valOf(string memory _key) public view returns (uint256 val_) {
        InitializableUint256 memory value = values[_key];
        if (!value.initialized) {
            revert InvalidKey(_key);
        }
        val_ = value.val;
    }

    function numKeys() external view returns (uint256 length_) {
        length_ = keys.length;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Debugging Functions
    ////////////////////////////////////////////////////////////////////////////

    uint256 constant NUM_LOG_COLS = 2;

    function log() external view {
        uint256 numRows = keys.length + 1;

        string[][] memory table = new string[][](numRows);
        table[0] = new string[](NUM_LOG_COLS);

        string[] memory cols = table[0];
        cols[0] = "Key";
        cols[1] = "Value";

        for (uint256 i = 1; i < numRows; ++i) {
            table[i] = new string[](NUM_LOG_COLS);
            cols = table[i];

            string memory key = keys[i - 1];
            cols[0] = key;
            cols[1] = Strings.toString(valOf(key));
        }

        Tabulate.log(table);
    }
}

contract SnapshotManager {
    ////////////////////////////////////////////////////////////////////////////
    // Constants
    ////////////////////////////////////////////////////////////////////////////

    Vm constant vm_snapshot_manager = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));
    IMulticall3 constant MULTICALL = IMulticall3(0xcA11bde05977b3631167028862bE2a173976CA11);

    ////////////////////////////////////////////////////////////////////////////
    // State
    ////////////////////////////////////////////////////////////////////////////

    string[] private keys;
    IMulticall3.Call[] private calls;

    mapping(string => uint256) public idxPlusOne;

    ////////////////////////////////////////////////////////////////////////////
    // Errors
    ////////////////////////////////////////////////////////////////////////////

    error DuplicateKey(string key);

    ////////////////////////////////////////////////////////////////////////////
    // Constructor
    ////////////////////////////////////////////////////////////////////////////

    constructor() {
        if (address(MULTICALL).code.length == 0) {
            vm_snapshot_manager.etch(address(MULTICALL), MULTICALL3_BYTECODE);
        }
    }

    function addCall(string memory _key, address _target, bytes memory _callData) public {
        uint256 idxPlusOneKey = idxPlusOne[_key];

        if (idxPlusOneKey == 0) {
            idxPlusOne[_key] = keys.length + 1;
            keys.push(_key);
            calls.push(IMulticall3.Call(_target, _callData));
        } else {
            IMulticall3.Call memory call = calls[idxPlusOneKey - 1];
            if (call.target != _target || keccak256(call.callData) != keccak256(_callData)) {
                revert DuplicateKey(_key);
            }
        }
    }

    function snap() public returns (DictionaryUint256 snap_) {
        (, bytes[] memory rdata) = MULTICALL.aggregate(calls);
        uint256 length = rdata.length;

        uint256[] memory vals = new uint256[](length);
        for (uint256 i; i < length; ++i) {
            vals[i] = abi.decode(rdata[i], (uint256));
        }

        snap_ = new DictionaryUint256(keys, vals);
    }
}

contract SnapshotComparator is SnapshotManager {
    ////////////////////////////////////////////////////////////////////////////
    // State
    ////////////////////////////////////////////////////////////////////////////

    DictionaryUint256 sCurr;
    DictionaryUint256 sPrev;

    ////////////////////////////////////////////////////////////////////////////
    // Public Functions
    ////////////////////////////////////////////////////////////////////////////

    function snapPrev() public {
        sPrev = snap();
    }

    function snapCurr() public {
        sCurr = snap();
    }

    function curr(string memory _key) public view returns (uint256 val_) {
        val_ = sCurr.valOf(_key);
    }

    function prev(string memory _key) public view returns (uint256 val_) {
        val_ = sPrev.valOf(_key);
    }

    function diff(string memory _key) public view returns (uint256 val_) {
        val_ = diff(sCurr, sPrev, _key);
    }

    function negDiff(string memory _key) public view returns (uint256 val_) {
        val_ = diff(sPrev, sCurr, _key);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Internal Functions
    ////////////////////////////////////////////////////////////////////////////

    function diff(DictionaryUint256 _snap1, DictionaryUint256 _snap2, string memory _key)
        private
        view
        returns (uint256 val_)
    {
        val_ = _snap1.valOf(_key) - _snap2.valOf(_key);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Debugging Functions
    ////////////////////////////////////////////////////////////////////////////

    uint256 constant NUM_LOG_COLS = 4;

    function log() external view {
        uint256 maxRows = sPrev.numKeys() + 1;

        string[][] memory table = new string[][](maxRows);
        table[0] = new string[](NUM_LOG_COLS);

        string[] memory cols = table[0];
        cols[0] = "Key";
        cols[1] = "Previous Value";
        cols[2] = "Current Value";
        cols[3] = "Difference";

        uint256 numRows = 1;
        for (uint256 i = 1; i < maxRows; ++i) {
            string memory key = sPrev.keys(i - 1);
            uint256 numVal1 = prev(key);
            uint256 numVal2 = curr(key);

            if (numVal1 != numVal2) {
                table[numRows] = new string[](NUM_LOG_COLS);
                cols = table[numRows];

                cols[0] = key;
                cols[1] = Strings.toString(numVal1);
                cols[2] = Strings.toString(numVal2);
                cols[3] = numVal1 > numVal2 ? Strings.toString(negDiff(key), true) : Strings.toString(diff(key));

                ++numRows;
            }
        }

        assembly {
            mstore(table, numRows)
        }

        Tabulate.log(table);
    }
}
