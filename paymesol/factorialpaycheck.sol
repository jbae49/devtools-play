// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// new Julia's wallet address = "0x7E1D7D9462575Bcaa3018B89e3480EA925b2E85b"
contract FactorialPaycheck {

    // bytes or bytes32 
    // how much would that be different from just using a string
    // I see, should be a public mapping then can see in the left side of Remix
    // Wait, I can't loop through the mapping
    // Then I'd just just use an array? That sounds better?
    mapping(bytes32 => address) public interns;
    bytes32[] public internNames;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }


    // So if there's any updates of variables, a function can't be a view function
    // So bytes doesn't need a memory keyword but string needs why and what's the difference?
    // what was the underscore in front of the variable name? was it the case when it comes with string memory?
    function hire(string memory _name, address ethWallet) public onlyOwner {
        interns[bytes32(bytes(_name))] = ethWallet;
        internNames.push(bytes32(bytes(_name)));
    }

    function quit(string memory _name) public onlyOwner {
        delete interns[bytes32(bytes(_name))];
        delete internNames[indexOf(internNames, bytes32(bytes(_name)))];
        // I don't think I should delete the name from the array do I?
            // How to remove an element in an array without knowing its index
            // if let firstIndex = array.index(of: "A") {
            // array.remove(at: firstIndex) }
    }

    // Would this be the best option for finding an index of an array?
    // Should I use internal or private?
    function indexOf(bytes32[] memory arr, bytes32 name) private returns (uint256) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == name) {
            return i;
            }
        }
        revert("Error in indexOf");
        }


    // why would I return uint instead of int here for a price feed?
    function getETHUSDPrice() public view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return (uint(price) * 10000000000);
    }

    // all payables here are necessary?
    // wait so msg.sender is default payable or need to cast 
    function payIntern() external payable {
        // Why contract balance is not updated?
        for (uint i=0; i<internNames.length; i++) {
            // for intern who quitted its address is not valid so transaction will revert? 
            // No gas fees then would be fine but if there is, I should think of deleting element from the array
            payable(interns[internNames[i]]).transfer(msg.value);
        }
    }




    // Should we fund the contract in USD as well
    function fund() external payable {
    }

    function withdraw() external payable {
        owner.transfer(address(this).balance);
        // What if he wants to withdraw a portion of the balance of the contract
    }

    function getContractBalance() external view returns(uint) {
        return address(this).balance;
    }

    function getOwnerBalance() external view returns (uint) {
        return owner.balance;
    }

    

}
