// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";

import {MockNFT} from "./mocks/MockNFT.sol";

// import {VRFCoordinatorV2Mock} from "@chainlink/mocks/VRFCoordinatorV2Mock.sol";

import "../SecretSanta.sol";

contract SecretSantaTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    MockNFT depositNFT_ONE;
    MockNFT depositNFT_TWO;

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

        vm.startPrank(address(users[0]));
        depositNFT_ONE.mint();
        vm.stopPrank();

        vm.startPrank(address(users[1]));
        depositNFT_TWO.mint();
        // depositNFT_TWO.ownerOf()
        assertEq(depositNFT_TWO.ownerOf(0), users[1]);

        vm.stopPrank();

        vm.prank(admin);
        secretsanta = new SecretSanta(
            1668776723,
            0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84
        );
        vm.stopPrank();
    }

    function testDepositTwice() public {
        address nftTwoAddress = address(depositNFT_TWO);
        vm.startPrank(address(users[1]));
        depositNFT_TWO.mint();
        depositNFT_TWO.setApprovalForAll(address(secretsanta), true);
        secretsanta.deposit(nftTwoAddress, 1);
        secretsanta.deposit(nftTwoAddress, 1);

        // assertEq(depositNFT_TWO.ownerOf(1), address(secretsanta));
        vm.stopPrank();
    }

    function testGetDepositedGifts() public {
        secretsanta.getDepositedGifts();
    }

    // function testRandom() public {
    //     vm.warp(block.timestamp + 1 days);
    //     vm.warp(block.difficulty + 1);
    //     uint256 rand = secretsanta._randomNumber();
    //     console.logUint(rand);
    // }

    function testCollect() public {
        address nftTwoAddress = address(depositNFT_TWO);
        vm.startPrank(address(users[1]));
        for (uint64 i = 1; i < 8; i++) {
            depositNFT_TWO.mint();
        }
        depositNFT_TWO.setApprovalForAll(address(secretsanta), true);

        for (uint64 i = 1; i < 8; i++) {
            secretsanta.deposit(nftTwoAddress, i);
        }
        vm.warp(1641070812);
        // uint256 giftId = secretsanta.collect();
        // console.logUint(giftId);
    }

    function testCollectNoContribution() public {
        address nftTwoAddress = address(depositNFT_TWO);
        vm.startPrank(address(users[3]));

        vm.warp(1641070812);
        secretsanta.collect();
    }
}
