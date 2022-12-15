// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
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

    Utilities internal utils;
    address payable[] internal users;

    SecretSanta public secretsanta;

    address admin = address(0x0132);
    address user = address(0x01);

    function setUp() public {
        vm.label(user, "USER");
        vm.label(admin, "ADMIN");

        utils = new Utilities();
        users = utils.createUsers(5);

        depositNFT_ONE = new MockNFT("mockone", "mockone");
        depositNFT_TWO = new MockNFT("mocktwo", "mocktwo");
        depositNFT_THREE = new MockNFT("mockthree", "mockthree");
        depositNFT_FOUR = new MockNFT("mockfour", "mockfour");

        // console.logAddress(address(users[1]));

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

        assertEq(depositNFT_TWO.ownerOf(0), users[1]);

        vm.prank(admin);
        secretsanta = new SecretSanta(
            1668776723,
            0x1e6e8488828df7be49777fbe35243b6ef266f4975fd998179d0807d2a3f504e1
        );
        vm.stopPrank();
    }

    function testDeposit() public {
        address nftTwoAddress = address(depositNFT_TWO);
        vm.startPrank(address(users[1]));
        console.logAddress(address(users[1]));

        depositNFT_TWO.mint();
        depositNFT_TWO.setApprovalForAll(address(secretsanta), true);

        bytes32[] memory _proof = new bytes32[](3);
        _proof[
            0
        ] = 0x972a69aadb9fb2dd5e3d4936ac6c01ebf152fc475a5f13a2ba0c5cf039d11064;
        _proof[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof[
            2
        ] = 0x5c5566ed9ca278962336d8318093681848d3b15d943f9984481273cd7a0bcdfe;

        secretsanta.deposit(nftTwoAddress, 1, _proof);

        vm.stopPrank();

        assertEq(depositNFT_TWO.ownerOf(1), address(secretsanta));
    }

    function testDepositCount() public {
        address nftTwoAddress = address(depositNFT_TWO);

        vm.startPrank(address(users[1]));
        console.logAddress(address(users[1]));

        depositNFT_TWO.mint();
        depositNFT_TWO.setApprovalForAll(address(secretsanta), true);

        bytes32[] memory _proof = new bytes32[](3);
        _proof[
            0
        ] = 0x972a69aadb9fb2dd5e3d4936ac6c01ebf152fc475a5f13a2ba0c5cf039d11064;
        _proof[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof[
            2
        ] = 0x5c5566ed9ca278962336d8318093681848d3b15d943f9984481273cd7a0bcdfe;

        secretsanta.deposit(nftTwoAddress, 1, _proof);

        vm.stopPrank();

        assertEq((secretsanta.DepositCount(address(users[1]))), 1);
    }

    function testCollect() public {
        address nftOneAddress = address(depositNFT_ONE);
        address nftTwoAddress = address(depositNFT_TWO);
        address nftThreeAddress = address(depositNFT_THREE);

        bytes32[] memory _proof_0 = new bytes32[](3);
        _proof_0[
            0
        ] = 0x6336b8bb274032aa3be701ac6a1d53b59751cb189032350fca009329bdacf405;
        _proof_0[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof_0[
            2
        ] = 0x5c5566ed9ca278962336d8318093681848d3b15d943f9984481273cd7a0bcdfe;

        bytes32[] memory _proof_1 = new bytes32[](3);
        _proof_1[
            0
        ] = 0x972a69aadb9fb2dd5e3d4936ac6c01ebf152fc475a5f13a2ba0c5cf039d11064;
        _proof_1[
            1
        ] = 0x0986c6f4bf8c4477d8577f391abb444f3d21608b6b68be5ae05ed26cd8dcf054;
        _proof_1[
            2
        ] = 0x5c5566ed9ca278962336d8318093681848d3b15d943f9984481273cd7a0bcdfe;

        bytes32[] memory _proof_2 = new bytes32[](3);
        _proof_2[
            0
        ] = 0x411e41cf526f9b4828f6f061c006384b3f94d8fce89a584920eea74822442900;
        _proof_2[
            1
        ] = 0x28ada27893d936924fa9e8cfebced2bf6e7a798d7ac2e83bcccf21529736d043;
        _proof_2[
            2
        ] = 0x5c5566ed9ca278962336d8318093681848d3b15d943f9984481273cd7a0bcdfe;

        vm.startPrank(address(users[0]));
        depositNFT_ONE.mint();
        depositNFT_ONE.setApprovalForAll(address(secretsanta), true);
        secretsanta.deposit(nftOneAddress, 1, _proof_0);
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

        // vm.startPrank(admin);
        // secretsanta.toggleCollection();
        // vm.stopPrank();

        // address nftThreeAddress = address(depositNFT_THREE);

        // vm.startPrank(address(users[2]));
        // depositNFT_THREE.mint();
        // depositNFT_THREE.setApprovalForAll(address(secretsanta), true);
        // secretsanta.deposit(nftThreeAddress, 1);
        // vm.stopPrank();

        // address nftFourAddress = address(depositNFT_FOUR);

        // vm.startPrank(address(users[3]));
        // depositNFT_FOUR.mint();
        // depositNFT_FOUR.setApprovalForAll(address(secretsanta), true);
        // secretsanta.deposit(nftFourAddress, 1);
        // vm.stopPrank();

        vm.startPrank(address(users[0]));
        secretsanta.collect();
        vm.stopPrank();

        vm.startPrank(address(users[1]));
        secretsanta.collect();
        vm.stopPrank();

        vm.startPrank(address(users[2]));
        secretsanta.collect();
        vm.stopPrank();

        // vm.startPrank(address(users[3]));
        // secretsanta.collect();
        // vm.stopPrank();
    }

    // function testGetDepositedGifts() public {
    //     secretsanta.getDepositedGifts();
    // }

    // function testRandom() public {
    //     vm.warp(block.timestamp + 1 days);
    //     vm.warp(block.difficulty + 1);
    //     uint256 rand = secretsanta._randomNumber();
    //     console.logUint(rand);
    // }

    // function testCollect() public {
    //     address nftTwoAddress = address(depositNFT_TWO);
    //     vm.startPrank(address(users[1]));
    //     for (uint64 i = 1; i < 8; i++) {
    //         depositNFT_TWO.mint();
    //     }
    //     depositNFT_TWO.setApprovalForAll(address(secretsanta), true);

    //     for (uint64 i = 1; i < 8; i++) {
    //         secretsanta.deposit(nftTwoAddress, i);
    //     }
    //     vm.warp(1641070812);
    // }

    // function testCollectNoContribution() public {
    //     address nftTwoAddress = address(depositNFT_TWO);
    //     vm.startPrank(address(users[3]));

    //     vm.warp(1641070812);
    //     secretsanta.collect();
    // }
}
