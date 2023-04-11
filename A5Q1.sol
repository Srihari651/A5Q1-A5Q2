//0xfc540E03dDB505F5DDB9eb81Fe4777B51a59fdee//

pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
contract timeLockedWallet //represents the name of the contract
{
    using SafeMath for uint256;
    address public owner; //represents the owner address
    uint256 public balance; //initializes the balance
    uint256 public releaseTime; //represents the time to release the fund

    constructor (uint256 newReleaseTime) public
    {
        owner = msg.sender; //declares that the owner as msg.sender
        releaseTime = block.timestamp.add(newReleaseTime.mul(6000).mul(60).mul(24)); //sets the release time of the fund
        uint256 balance = 0;  //initially shows the balcnce as 0
    }

    function withdraw() public payable a()
    {
        uint256 amount =  balance;  //gives the balance amount
    }
    modifier a()
    {
        require(msg.sender == owner, "Not a owner"); //shows error if it is not the owner
        require(block.timestamp >= releaseTime, "Release time should exceed the set time");  //shows error if time is not exceeded from the set time
        _;
    }

    function increaseLockTime(uint256 _extratime) public b()
    {
        releaseTime = block.timestamp.add(_extratime.mul(6000).mul(60).mul(24)); //increases the the rlease time
    }
    modifier b()
    {
        require(msg.sender == owner, "Not a owner");  //shows error if it is not the owner
        _;
    }

    function decreaseLockTime(uint256 _reducetime) public c()
    {
        releaseTime = block.timestamp.sub(_reducetime.mul(6000).mul(60).mul(24));
    }
    modifier c()
    {
        require(msg.sender == owner, "Not a owner");  //shows error if it is not the owner
        _;
    }


}
