var Sponsor = artifacts.require("./Sponsor.sol");
contract("Sponsor", function(accounts) {

   let sponsorInstance;
   let administrator1;
     beforeEach('should setup the contract instance', async () => {
       administrator1=accounts[0];
       sponsorInstance = await Sponsor.deployed();
     });

   it("deploys contract", async ()=> {
       const sponsorAdmin = await sponsorInstance.administrator();
       assert.call(administrator1, sponsorAdmin);
     });

     it("only admin can register as orphanage",async ()=>{
     try{
      await sponsorInstance.registerAsOrphanage("BABA",{from:accounts[4]});
      assert(false);
      }
      catch(err){
      assert(err);
      }
     });
     it("admin register",async ()=>{
       await sponsorInstance.registerAsOrphanage("HelpingHands",{from:accounts[0]});
       assert(true);
     });

      it("donate coins",async ()=> {
          await sponsorInstance.donateCoins(accounts[0],({from:accounts[1],value:web3.utils.toWei('2','ether')}));
          const donCount=await sponsorInstance.donationIndex();
          assert.equal(donCount,1,"donations made till now should be one");
      });

      it("sponsor a child",async ()=> {
      try{
       await sponsorInstance.sponsorAchild(accounts[0],0,1,({from:accounts[3],value:web3.utils.toWei('400','wei')}));
       assert(false);
      }
      catch(err){
      assert(err);
      }
      });
      it("admin register",async ()=>{
       await sponsorInstance.sponsorAchild(accounts[0],0,1,({from:accounts[7],value:web3.utils.toWei('700','wei')}));
       assert(true);
      });
});