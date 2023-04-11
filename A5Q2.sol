pragma solidity ^0.8.1;
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol"; // open source for ownable contract
import "@openzeppelin/contracts/utils/math/SafeMath.sol"; //open source contract for safemath operation
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";  //open source contract for standard ERC20 tokens
contract tokenVesting is Ownable //contract name which only owner can call certain functions
{
    event released(uint256 indexed releaseToken); // event that stores the released tokens history
    event revoked(uint256 indexed remainingToken);  //event that stores the revoked tokens history
    using SafeMath for uint256;  //uint256 condideration for safemath operation
    address private beneficiary;  //declaring of beneficiary address
    uint256 private vestingStartTime; //declaring of vesting start time
    uint256 private vestingDuration;  //declaring of vesting duraction time
    uint256 private vestingCliffTime;  //declaring of vesting cliff time which should be less than total duration time
    address private tokenContract;  //declaring address of token containing contract
    uint256 private balance;  //declaring of balance type 
    IERC20 private token;  //claiming of ERC20 tokens

    constructor(
        address _beneficiary, 
        uint256 _vestingStartTime, 
        uint256 _vestingDuration, 
        uint256 _vestingCliffTime, 
        address _tokenContract) public
    {
        require(_vestingDuration > _vestingCliffTime, "duration time should be more than the clif time");  //checking that the cliff time is less than total duration time
        require(balance==token.balanceOf(address(this)));  //checking that the balance is equal to the token balance to avoid the loss of tokens before deploying the contract
        beneficiary=_beneficiary;
        vestingStartTime=_vestingStartTime;
        vestingDuration=_vestingDuration;
        vestingCliffTime=_vestingCliffTime;
        tokenContract=_tokenContract;
        token = IERC20(tokenContract);
    }

    function release(uint256 releaseToken) public a()  //function that releases the entered amount of tokens to the beneficiary address
    {
        token.transfer(beneficiary,releaseToken);  //transfer action that transfers the tokens to the beneficiary
        emit released(releaseToken);  //stores the history of the released tokens
    }
    modifier a()  //modifier that satisfies the condition before executing the function
    {
        require(block.timestamp >= vestingStartTime.add(vestingCliffTime), "Should reach the desired clifftime");  //checks that the current block time is greater than the start time to release the tokens
        _;
    }

    function calculateVestedTokens() public view returns(uint256,uint256)  //function that calculates the total balance of the contract
    {
        uint256 releaseToken;
        uint256 balance = token.balanceOf(address(this));  //current balance of the contract
        uint256 vestedTokens = token.balanceOf(address(this)).add(releaseToken); //total vested tokens is the sum of current token balance and the tokens that are released
        return(balance, vestedTokens);  //returning the balance and the total vested tokens
    }

    function revoke() public onlyOwner c()  //function that revokes the remaining tokens to the given adress
    {
        uint256 remainingToken=token.balanceOf(address(this));  //remaining tokens are the tokens left after releasing
        token.transfer(beneficiary, remainingToken);  //transfering of the remaining tokens to the beneficiary
        emit revoked(remainingToken);  //stores the history of the revoked tokens

    }
    modifier c()  //modifier that satisfies the condition before executing the function
    {
        require(msg.sender == beneficiary,"sender shouldbe the address of beneficiary");  //check condition that checks whether the function caller is the beneficiary himself
        _;
    }

    fallback() external payable  // payable fallback function to keep the amount within it
    {

    }
}