// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error upkeepNotNeeded();

contract FactorialPaycheck {

    uint public internMonthlySalaryInUSD;
    uint public fulltimeMonthlySalaryInUSD;
    uint public interval;
    uint public lastPaymentTimeStamp;

    mapping(bytes32 => address) public interns;
    bytes32[] public internNames;
    address payable public owner;

    constructor(uint _interval) {
        owner = payable(msg.sender);
        internMonthlySalaryInUSD = 2000;
        fulltimeMonthlySalaryInUSD = 5000;
        interval = _interval;
        lastPaymentTimeStamp = block.timestamp;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }


    function hire(string memory _name, address ethWallet) public onlyOwner {
        interns[bytes32(bytes(_name))] = ethWallet;
        internNames.push(bytes32(bytes(_name)));
    }

    function quit(string memory _name) public onlyOwner {
        delete interns[bytes32(bytes(_name))];
        delete internNames[indexOf(internNames, bytes32(bytes(_name)))];
    }


    function indexOf(bytes32[] memory arr, bytes32 name) private pure returns(uint256) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == name) {
            return i;
            }
        }
        revert("Error in indexOf");
        }

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

    function convertUSD2Wei(uint usd) public view returns(uint){ 
        uint ethPrice = getETHUSDPrice();
        return ((usd * 1000000000000000000) / (ethPrice/10000000000)) * 100000000; 
    }


    function payIntern() public payable {
        for (uint i=0; i<internNames.length; i++) {
            payable(interns[internNames[i]]).transfer(convertUSD2Wei(internMonthlySalaryInUSD)); 
        }
    }

    function checkUpkeep(
        bytes memory /* checkData */
    ) 
        public 
        view 
        returns(
            bool upkeepNeeded, 
            bytes memory /* performData */
        ) 
    {
        bool timePassed = ((block.timestamp - lastPaymentTimeStamp) > interval);
        bool hasBalance = address(this).balance > 0;
        bool hasInterns = internNames.length > 0;
        upkeepNeeded = (timePassed && hasBalance && hasInterns);
        return (upkeepNeeded, "0x0");
    }

    function performUpkeep(
        bytes calldata /* performData */
        ) external {
            (bool upkeepNeeded, ) = checkUpkeep("");
            if (!upkeepNeeded){
                revert upkeepNotNeeded();
            }
            payIntern();
        } 

    function payBonus(string memory welldone, uint bonusInUsd) external payable {
        address welldoneEmployee;
        welldoneEmployee = interns[bytes32(bytes(welldone))];
        uint bonusInWei;
        bonusInWei = convertUSD2Wei(bonusInUsd); 
        payable(welldoneEmployee).transfer(bonusInWei);
    }

    function fund() external payable {
    }

    function withdraw() external payable {
        owner.transfer(address(this).balance);
    }

    function getContractBalance() external view returns(uint) {
        return address(this).balance;
    }

    function getOwnerBalance() external view returns (uint) {
        return owner.balance;
    }


}
