pragma solidity ^0.5.12;
contract Sponsor{
 enum TypesOfDonations {Education,Meals}
 //In Solidity you will store date as uint type
  struct Orphanage{
      string fullname;
      address payable orphanageAddress;
      bool isAccepting;
  }

  struct Receipt{
      uint256 index;
      address _from;
      address to;
      uint256 value;
      uint256 donatedFor;
      uint256 timeStamp;
  }

  struct donorDetails{
      address donorAddress;
      uint256 amount;
  }
  address public administrator;
  mapping(address=> Orphanage) public registeredOrphanage;
  mapping(uint=>Receipt) public donations;
  uint256 public donationIndex;
  mapping(address=>donorDetails) public DDetails;
  address[] public donator;
  event Transfer(uint256 donationIndex,address from,address to,uint256 value );


  constructor() public{
      administrator=msg.sender;
   }

     modifier onlyAdministrator{
        require(msg.sender == administrator);
        _;
    }

    //orphanage should be registered in the blockchain
    function registerAsOrphanage(string memory _fullname)  public payable onlyAdministrator{
     require(msg.sender!=registeredOrphanage[msg.sender].orphanageAddress);
     registeredOrphanage[msg.sender].fullname=_fullname;
     registeredOrphanage[msg.sender].orphanageAddress=msg.sender;
     registeredOrphanage[msg.sender].isAccepting=true;
    }

    //If the donor wishes to donate a random amount of his choice
    function donateCoins(address receivingParty) public payable{

        registeredOrphanage[receivingParty].orphanageAddress.transfer(msg.value);
         donator.push(msg.sender);
         DDetails[msg.sender].donorAddress=msg.sender;
         DDetails[msg.sender].amount=msg.value;
         donationIndex++;
    }

    //If a donor wants to sponser a child for his/her education and meals for an entire year.
    //For one child, the education cost per year is 700 wei
    //For one child, the meals cost per year is 600 wei
    function sponsorAchild(address receiver,uint _donationType,uint256 childrenCount)  public payable{
        //require(registeredOrphanage[receiver].isAccepting==true);
        require(uint(TypesOfDonations.Meals) >= _donationType);
        if(uint(TypesOfDonations.Education)==_donationType){
            uint256 educationCostPerHead=700 wei;
            require(msg.value>=(childrenCount*educationCostPerHead));
            registeredOrphanage[receiver].orphanageAddress.transfer(msg.value);
        }else if(uint(TypesOfDonations.Meals)==_donationType){
            uint256 mealsCostPerHead=600 wei;
            require(msg.value>=(childrenCount*mealsCostPerHead));
            registeredOrphanage[receiver].orphanageAddress.transfer(msg.value);
        }
         donator.push(msg.sender);
         DDetails[msg.sender].donorAddress=msg.sender;
         DDetails[msg.sender].amount=msg.value;
    }

    function donationReceipt(address _receiver,uint256 _donatedFor) public{
        require(DDetails[msg.sender].donorAddress==msg.sender);
        uint256 _amount;
        _amount=DDetails[msg.sender].amount;
        donationIndex++;
        donations[donationIndex]=Receipt(donationIndex,msg.sender,_receiver,_amount,_donatedFor,now);
        emit Transfer(donationIndex,msg.sender,_receiver,_amount);
    }
    function getDonorList() public view returns(address[] memory){
        return donator;
    }


    function getDonationReceipt(uint256 _donationIndex) public view returns(uint256,address,address,uint256,uint256,uint256)
    {
        return (donations[_donationIndex].index,donations[_donationIndex]._from,donations[_donationIndex].to,donations[_donationIndex].value,donations[_donationIndex].donatedFor,donations[_donationIndex].timeStamp);
    }

}