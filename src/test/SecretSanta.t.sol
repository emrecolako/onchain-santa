// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
// import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";

import {MockNFT} from "./mocks/MockNFT.sol";

// Potential Tests
// - deposit() function to ensure that it correctly adds the deposited gift to the gifts array and updates the Depositors and DepositCount mappings.
// - collect() function to ensure that it correctly selects a random gift from the gifts array and transfers it to the caller's account.
// - reclaim() function to ensure that it correctly transfers all gifts that have not been collected back to their original depositors.
// - changeReclaimTime() function to ensure that it correctly updates the reclaimTimestamp variable.
// - removeGift() function to ensure that it correctly removes a gift from the gifts array and updates the Depositors and DepositCount mappings.
// - verifyTransfer() function to ensure that it correctly verifies the given merkle proof and returns the correct result.
// - transferOwnership() function to ensure that it correctly transfers ownership of the contract to the specified address.

import "../SecretSanta.sol";

contract SecretSantaTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    MockNFT depositNFT_ONE;
    MockNFT depositNFT_TWO;
    MockNFT depositNFT_THREE;
    MockNFT depositNFT_FOUR;

    MockNFT depositNFT_FIVE;
    MockNFT depositNFT_SIX;
    MockNFT depositNFT_SEVEN;
    MockNFT depositNFT_EIGHT;
    MockNFT depositNFT_NINE;
    MockNFT depositNFT_TEN;

    Utilities internal utils;
    address payable[] internal users;

    SecretSanta public secretsanta;

    address admin = address(0x0132);
    address user = address(0x01);

    function setUp() public {
        vm.label(user, "USER");
        vm.label(admin, "ADMIN");

        utils = new Utilities();
        users = utils.createUsers(9);

        depositNFT_ONE = new MockNFT("mockone", "mockone");
        depositNFT_TWO = new MockNFT("mocktwo", "mocktwo");
        depositNFT_THREE = new MockNFT("mockthree", "mockthree");
        depositNFT_FOUR = new MockNFT("mockfour", "mockfour");
        depositNFT_FIVE = new MockNFT("mockfive", "mockfive");
        depositNFT_SIX = new MockNFT("mocksix", "mocksix");
        depositNFT_SEVEN = new MockNFT("mockseven", "mockseven");
        depositNFT_EIGHT = new MockNFT("mockeight", "mockeight");
        depositNFT_NINE = new MockNFT("mocknine", "mocknine");
        depositNFT_TEN = new MockNFT("mockten", "mockten");

        vm.startPrank(address(users[0]));
        depositNFT_ONE.mint();
        vm.stopPrank();

        vm.startPrank(address(users[1]));
        depositNFT_TWO.mint();
        vm.stopPrank();

        vm.startPrank(address(users[2]));
        depositNFT_THREE.mint();
        vm.stopPrank();

        vm.startPrank(address(users[3]));
        depositNFT_FOUR.mint();
        vm.stopPrank();

        vm.startPrank(address(users[4]));
        depositNFT_FIVE.mint();
        vm.stopPrank();

        vm.startPrank(address(users[5]));
        depositNFT_SIX.mint();
        vm.stopPrank();

        vm.startPrank(address(users[6]));
        depositNFT_SEVEN.mint();
        vm.stopPrank();

        vm.startPrank(address(users[7]));
        depositNFT_EIGHT.mint();
        vm.stopPrank();

        vm.startPrank(address(users[8]));
        depositNFT_NINE.mint();
        vm.stopPrank();

        vm.prank(admin);
        secretsanta = new SecretSanta(
            1668776723,
            0xb9520b6aca90d2f73b29619bb48976f46129509f8c23266c32a28a5637603100
        );
        vm.stopPrank();
    }

    function testDeposit() public {
        address nftOneAddress = address(depositNFT_ONE);
        vm.startPrank(address(users[0]));
        console.logAddress(address(users[0]));

        depositNFT_ONE.mint();
        depositNFT_ONE.setApprovalForAll(address(secretsanta), true);

        bytes32[] memory _proof = new bytes32[](4);
        _proof[
            0
        ] = 0x6336b8bb274032aa3be701ac6a1d53b59751cb189032350fca009329bdacf405;
        _proof[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof[
            2
        ] = 0x9a2e42a5ebbb8ba90ea2dccb4a5b0760b70531b2b96b04398a80e777cc714cab;
        _proof[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        secretsanta.deposit(nftOneAddress, 1, _proof);

        vm.stopPrank();

        assertEq(depositNFT_ONE.ownerOf(1), address(secretsanta));
    }

    function testDepositCount() public {
        address nftOneAddress = address(depositNFT_ONE);
        vm.startPrank(address(users[0]));
        console.logAddress(address(users[0]));

        depositNFT_ONE.mint();
        depositNFT_ONE.setApprovalForAll(address(secretsanta), true);

        bytes32[] memory _proof = new bytes32[](4);
        _proof[
            0
        ] = 0x6336b8bb274032aa3be701ac6a1d53b59751cb189032350fca009329bdacf405;
        _proof[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof[
            2
        ] = 0x9a2e42a5ebbb8ba90ea2dccb4a5b0760b70531b2b96b04398a80e777cc714cab;
        _proof[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        secretsanta.deposit(nftOneAddress, 1, _proof);

        vm.stopPrank();

        assertEq((secretsanta.DepositCount(address(users[0]))), 1);
    }

    // function testGetDepositedGifts() public {
    //     secretsanta.getDepositedGifts();
    // }

    function testCollect() public {
        address nftOneAddress = address(depositNFT_ONE);
        address nftTwoAddress = address(depositNFT_TWO);
        address nftThreeAddress = address(depositNFT_THREE);
        address nftFourAddress = address(depositNFT_FOUR);
        address nftFiveAddress = address(depositNFT_FIVE);

        bytes32[] memory _proof_0 = new bytes32[](4);
        bytes32[] memory _proof_1 = new bytes32[](4);
        bytes32[] memory _proof_2 = new bytes32[](4);
        bytes32[] memory _proof_3 = new bytes32[](4);
        bytes32[] memory _proof_4 = new bytes32[](4);
        bytes32[] memory _proof_5 = new bytes32[](4);
        bytes32[] memory _proof_6 = new bytes32[](4);
        bytes32[] memory _proof_7 = new bytes32[](4);
        bytes32[] memory _proof_8 = new bytes32[](1);

        _proof_0[
            0
        ] = 0x6336b8bb274032aa3be701ac6a1d53b59751cb189032350fca009329bdacf405;
        _proof_0[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof_0[
            2
        ] = 0x9a2e42a5ebbb8ba90ea2dccb4a5b0760b70531b2b96b04398a80e777cc714cab;
        _proof_0[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_1[
            0
        ] = 0x972a69aadb9fb2dd5e3d4936ac6c01ebf152fc475a5f13a2ba0c5cf039d11064;
        _proof_1[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof_1[
            2
        ] = 0x9a2e42a5ebbb8ba90ea2dccb4a5b0760b70531b2b96b04398a80e777cc714cab;
        _proof_1[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_2[
            0
        ] = 0x411e41cf526f9b4828f6f061c006384b3f94d8fce89a584920eea74822442900;
        _proof_2[
            1
        ] = 0x28ada27893d936924fa9e8cfebced2bf6e7a798d7ac2e83bcccf21529736d043;
        _proof_2[
            2
        ] = 0x9a2e42a5ebbb8ba90ea2dccb4a5b0760b70531b2b96b04398a80e777cc714cab;
        _proof_2[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_3[
            0
        ] = 0x6f27acbb13347a0359ee7a8619cbc89319e9ae4034a33a3e0f5fddd5d2ff468b;
        _proof_3[
            1
        ] = 0x28ada27893d936924fa9e8cfebced2bf6e7a798d7ac2e83bcccf21529736d043;
        _proof_3[
            2
        ] = 0x9a2e42a5ebbb8ba90ea2dccb4a5b0760b70531b2b96b04398a80e777cc714cab;
        _proof_3[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_4[
            0
        ] = 0x6983349ff3d99186dbf811e90cbbc810784cc7d9d855199e459cc6f64e3a401e;
        _proof_4[
            1
        ] = 0x08e9d837d1874b31c14ba278d75a503e6e5a31653e74203255973ff6a0957581;
        _proof_4[
            2
        ] = 0x9fd6d6c685b39b8973429ce39ea7d8499ce3d7c1113b27a87d6bf18ff217e0fe;
        _proof_4[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_5[
            0
        ] = 0x5c5566ed9ca278962336d8318093681848d3b15d943f9984481273cd7a0bcdfe;
        _proof_5[
            1
        ] = 0x08e9d837d1874b31c14ba278d75a503e6e5a31653e74203255973ff6a0957581;
        _proof_5[
            2
        ] = 0x9fd6d6c685b39b8973429ce39ea7d8499ce3d7c1113b27a87d6bf18ff217e0fe;
        _proof_5[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_6[
            0
        ] = 0x2a43ee8ca7eca84d0a2062505c0547ce4ac261033cd5f0b947115bf54c96128b;
        _proof_6[
            1
        ] = 0x95a05404cc97c044a8de24224ac63846c316796de10f431c7df6f1a7d2877274;
        _proof_6[
            2
        ] = 0x9fd6d6c685b39b8973429ce39ea7d8499ce3d7c1113b27a87d6bf18ff217e0fe;
        _proof_6[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_7[
            0
        ] = 0xfde9449d45a6a0421e34e54aae26655d3e28cff5f7480c50553230f3cb4eb4cd;
        _proof_7[
            1
        ] = 0x95a05404cc97c044a8de24224ac63846c316796de10f431c7df6f1a7d2877274;
        _proof_7[
            2
        ] = 0x9fd6d6c685b39b8973429ce39ea7d8499ce3d7c1113b27a87d6bf18ff217e0fe;
        _proof_7[
            3
        ] = 0x6d37959719f00b7715c05470e76c12efcebc00fc0bbcea7d2ce9ab5f2af0bdd9;

        _proof_8[
            0
        ] = 0xa10fc32f79c4fa6370517fe72ce7e491da0aa83ab648ac9b80927b7a884967d9;

        vm.startPrank(address(users[0]));

        depositNFT_ONE.mint();
        depositNFT_ONE.setApprovalForAll(address(secretsanta), true);
        secretsanta.deposit(nftOneAddress, 1, _proof_0);
        console.logAddress(address(msg.sender));
        console.log("deposited");
        vm.stopPrank();

        vm.startPrank(address(users[1]));

        depositNFT_TWO.mint();
        depositNFT_TWO.setApprovalForAll(address(secretsanta), true);
        secretsanta.deposit(nftTwoAddress, 1, _proof_1);
        vm.stopPrank();

        vm.startPrank(address(users[2]));

        depositNFT_THREE.mint();
        depositNFT_THREE.setApprovalForAll(address(secretsanta), true);
        secretsanta.deposit(nftThreeAddress, 1, _proof_2);
        vm.stopPrank();

        vm.startPrank(address(users[3]));

        depositNFT_FOUR.mint();
        depositNFT_FOUR.setApprovalForAll(address(secretsanta), true);
        secretsanta.deposit(nftFourAddress, 1, _proof_3);
        vm.stopPrank();

        vm.startPrank(address(users[4]));

        depositNFT_FIVE.mint();
        depositNFT_FIVE.setApprovalForAll(address(secretsanta), true);
        secretsanta.deposit(nftFiveAddress, 1, _proof_4);
        vm.stopPrank();

        vm.startPrank(admin);
        secretsanta.toggleCollection();
        vm.stopPrank();

        vm.startPrank(address(users[0]));
        secretsanta.collect();
        vm.stopPrank();

        vm.startPrank(address(users[1]));
        secretsanta.collect();
        vm.stopPrank();

        vm.startPrank(address(users[2]));
        secretsanta.collect();
        vm.stopPrank();

        vm.startPrank(address(users[3]));
        secretsanta.collect();
        vm.stopPrank();
    }

    //     // function testRandom() public {
    //     //     vm.warp(block.timestamp + 1 days);
    //     //     vm.warp(block.difficulty + 1);
    //     //     uint256 rand = secretsanta._randomNumber();
    //     //     console.logUint(rand);
    //     // }

    //     // function testCollectNoContribution() public {
    //     //     address nftTwoAddress = address(depositNFT_TWO);
    //     //     vm.startPrank(address(users[3]));

    //     //     vm.warp(1641070812);
    //     //     secretsanta.collect();
    //     // }
}
