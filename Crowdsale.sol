pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale {

    constructor(
        uint256 rate, // in TKNbits
        address payable wallet,  //beneficiary from the sale 
        PupperCoin token, 
        uint256 opening,
        uint256 closing,
        uint cap, 
        uint goal // min goal for sale
        
    )
        MintedCrowdsale()
        Crowdsale (rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(opening, closing)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address; 
    address public token_address;
    uint goal = 100;
    uint cap = 10000;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet
    )
        public
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);  //name, symbol, and initial supply
        token_address = address(token);

        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, now, now + 24 weeks, goal, cap );
        token_sale_address = address(token_sale);
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
