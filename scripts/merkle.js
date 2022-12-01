"use strict";
exports.__esModule = true;
exports.getMerkleProof = exports.getMerkleRoot = void 0;
var merkletreejs_1 = require("merkletreejs");
var ethers_1 = require("ethers");
// insert addresses for merkleTREE
var addresses = [
    "0x971a6ff4f5792f3e0288f093340fb36a826aae96",
    "0x97597002980134bea46250aa0510c9b90d87a587",
    "0x600a4446094c341693c415e6743567b9bfc8a4a8",
    "0xbad6186e92002e312078b5a1dafd5ddf63d3f731",
    "0x5283fc3a1aac4dac6b9581d3ab65f4ee2f3de7dc",
    "0xd4e4078ca3495de5b1d4db434bebc5a986197782",
    "0xf3e778f839934fc819cfa1040aabacecba01e049",
    "0x73a8ce3f662a1e66563d05606bc5a8ab71a4d924",
    "0x5bdf397bb2912859dbd8011f320a222f79a28d2e",
    "0x8d04a8c79ceb0889bdd12acdf3fa9d207ed3ff63",
    "0x28812ec6e46c3e5093de25e954a026ff99a57d53",
    "0xfa12fae65134a8f2041a68b88a253d23e7914804",
    "0x91047abf3cab8da5a9515c8750ab33b4f1560a7a",
    "0x71ede9894aeb2ff2da92d2ca4865d37d1ab77a1b",
    "0x5c7b6d004f9bea6051270b4208bf5e4e7ba9bbc9",
    "0xff07f31678e873c06938f17452cb99ed58a97e5d",
    "0x1fff1e9e963f07ac4486503e5a35e71f4e9fb9fd",
    "0xc9cb0fee73f060db66d2693d92d75c825b1afdbf",
    "0xb543f9043b387ce5b3d1f0d916e42d8ea2eba2e0",
    "0x5a876ffc6e75066f5ca870e20fca4754c1efe91f",
    "0x5f61975816ecdc761fac1e4d6359bfd4c3941e2f",
    "0x71a41083c0ba125c00901ac874017671bbf9e621",
    "0x32d8eba200e56480b96769ec160eecfa37414d8c",
    "0xdf6e32d85d17e907e0da157fab7c12788e7161da",
    "0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7",
    "0x8b4616926705fb61e9c4eeac07cd946a5d4b0760",
    "0xdaca87395f3b1bbc46f3fa187e996e03a5dcc985",
    "0xa4f6c450e515adfa8e4efa558d0d58087e7d59e3",
    "0x52202190e82597b6842c2622d51d213b3b8972c9",
    "0x3146dd9c200421a9c7d7b67bd1b75ba3e2c15310",
    "0x9c8ff314c9bc7f6e59a9d9225fb22946427edc03",
    "0x960b7a6bcd451c9968473f7bbfd9be826efd549a",
    "0xb90b34b41658ac20a0051874feee1933c3614fa7",
    "0xf1b214702bed6ec64843f55e5d566d8ffb3034dd",
    "0x4c4808459452c137fb9bf3e824d4d7ac73655f54",
    "0x5d4683ba64ee6283bb7fdb8a91252f6aab32a110",
    "0x36f379400de6c6bcdf4408b282f8b685c56adc60",
    "0x1ca15ccdd91b55cd617a48dc9eefb98cae224757",
    "0x4e1f41613c9084fdb9e34e11fae9412427480e56",
    "0x8db687aceb92c66f013e1d614137238cc698fedb",
    "0xf76c5d925b27a63a3745a6b787664a7f38fa79bd",
    "0x7deb38a22694608a58b28970320d39ee50e7bc0f",
    "0x8ed25b735a788f4f7129db736fc64f3a241137b8",
    "0x7e5935ea00b69b0ac8978f35cb079ef38217e181",
    "0x6c7c97caff156473f6c9836522ae6e1d6448abe7",
    "0x75c3b1035b1898dc96c22481f886a80adfd69c7a",
    "0x0427743df720801825a5c82e0582b1e915e0f750",
    "0xd31fc221d2b0e0321c43e9f6824b26ebfff01d7d",
    "0x6c0312933b695ca75858c2c6ec732a89ff312c85",
    "0xd754937672300ae6708a51229112de4017810934",
    "0x521f9c7505005cfa19a8e5786a9c3c9c9f5e6f42",
    "0x0C09c574E075E24eFffbe8A3A21293913a5c1BAd",
    "0x448f3219cf2a23b0527a7a0158e7264b87f635db",
    "0xbc17cd7f1a58bda5d6181618090813b3050416b5",
    "0x905b180268f2773022e1a10e204b0858b2e60dcf",
    "0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb",
    "0xa04290ff2491f55aedc47dec497d432b19347768",
    "0xd83B6F9A3E623ae4427298726aE32907B477b8CC",
    "0xe95004c7f061577df60e9e46c1e724cc75b01850",
    "0xf65d6475869f61c6dce6ac194b6a7dbe45a91c63",
    "0x0e4b8e24789630618aa90072f520711d3d9db647",
    "0xBDA937F5C5f4eFB2261b6FcD25A71A1C350FdF20",
    "0xf2470e641a551d7dbdf4b8d064cf208edfb06586",
    "0x25e3e4d34c07ff6832cdcfc060f8af6581c9cc26",
    "0x86f7692569914B5060Ef39aAb99e62eC96A6Ed45",
    "0x9d27527Ada2CF29fBDAB2973cfa243845a08Bd3F",
    "0x1aba27d6a420feb25af6cf6b80b93b7526725a71",
    "0x788defd1ae1e2299d54cf9ac3658285ab1da0900",
    "0x06F650198CFCd186d45D9B2e564DB755DBc4A8cd",
    "0xdda32aabbbb6c44efc567bac5f7c35f185338456",
    "0x3051162ED7DeF8Af730Aaf4C7cB8a10Ee19b8303",
    "0x7C139693EE611cEe9993a53D6580a99b18377C2F",
    "0xE40C6b5b2CeD59fe58750271425C31aD248e1236",
    "0x94e816F5AcD7A3754fa5515Bcc5aACC6A2a71D28",
    "0x8d3b078D9D9697a8624d4B32743B02d270334AF1",
    "0xb0e409b7b0313402A10CaA00F53BCb6858552FDA",
    "0x62674b8aCe7D939bB07bea6d32c55b74650e0eaA",
    "0x69c40e500b84660cb2ab09cB9614fa2387F95F64",
    "0x0747118c9f44c7a23365b2476dcd05e03114c747",
    "0xCa21d4228cDCc68D4e23807E5e370C07577Dd152",
    "0x5025ebac986d9a5914442c6c0496fbbe41ef1464",
    "0x329Fd5E0d9aAd262b13CA07C87d001bec716ED39",
    "0x3AcAdF037d6f2E13252031ddd44dF1400f115D58",
    "0x922dc160f2ab743312a6bb19dd5152c1d3ecca33",
    "0xc256e91617C24e6A770aAA5d4111c7Fb9478003c",
    "0x3eaf1e92e396c4fc67fffc0a181d8f1915914f10",
    "0x1308c158e60d7c4565e369df2a86ebd853eef2fb",
    "0x8713451FeAA39b0039062b515098a88569B5c78F",
    "0x2F56683f5CD026716caA74d021f4EaBa285A1449",
    "0xB5e639Cb9EdD9D969c227494eddc5994035ed80c",
    "0xf4794aeb9d243c024cf59b85b30ed94f5014168a",
    "0x7150cd8593670341121EEe513538108029298Cf7",
    "0x495Fb4483d1782e92Df66685920b857D52DB93e3",
    "0x79e176a48d79d3348f30b14328424622849bd809",
    "0x68a510ff4ed6180b033211283661914a3d342b6d",
    "0x5755Ab845dDEaB27E1cfCe00cd629B2e135Acc3d",
    "0x111fFF9a5b235F704F3cb39dBf63505BaC3210D6",
    "0x4d756257Df43D5B00242461A60C94C906eedFe67",
    "0xbd46b75289661765873c8c6d5051f20a6bfb5335",
    "0x5f828b0ABBca26878169B57B24846B2efC2BE7ED",
    "0x892848074ddeA461A15f337250Da3ce55580CA85",
    "0xaa5d0f2e6d008117b16674b0f00b6fca46e3efc4",
    "0xdd0d63220265927b29646cb7d4684d5fa6df4cb8",
    "0xA8A6CB3978e2c4EdcF5A3d0cB3400E1E5D031479",
    "0x947600aD1AD2fADF88faF7d30193D363208fC76D",
    "0xf4e9b9c8F4B550a5A659c4065BB9403361297384",
    "0x7effbc54d8066e3717230fff5d245d7c11ad4d22",
    "0x976a145bce31266d3ed460a359330dd53466db97",
    "0x494715B2a3C75DaDd24929835B658a1c19bd4552",
    "0x70ccd3ab26bf2f7086cf8df0d35ecc6672196b1c",
    "0x108578c96C61f3e5a3a12d43d42A60346a6Bfcb2",
    "0x880509ff28915fa62cdc7b07d1ea951bd5cfe882",
    "0x205a10c241ca38918d3790c89f16675cc46d10a9",
    "0x6a5d1449263c0ddde0a30bf48714ff97503597dc",
    "0xF9a423B86afbf8dB41d7f24fa56848f56684e43F",
    "0x5d2Fe91F41C4E0d7208D9a2B574B608B0154601E",
    "0x1d501437816a7aaba998063779f9c1bb3273991a",
    "0x690dbdf6bb1712f01b34e80c25553db869df8bf9",
    "0x6f13d82d5D501B2eebB94A34BbF8Bfdf20440079",
    "0x9e790c3845aDaE7E5728D71045aE91eBe653bAf2",
    "0xf9901740741474C65212DC637c2A5EBf9A931A06",
    "0x96aaf5008913c3ae12541f6ea7717c9a0dd74f4d",
    "0x99F0501F97A2ad7dC5D8C99B56ea5FfBFbB60121",
    "0xb9b2580d902811546C5C5A4a26906Af183360b7c",
    "0xccB6E4a1c42F4892cdE27A8bC2e50bbA0b43d224",
    "0x3aBEDBA3052845CE3f57818032BFA747CDED3fca",
    "0x625955AEe56Aa5b245627B2901A46b6b0DE9A3a2",
    "0xb4A4961edDedED48cA1A8c3a2Fd0D89E586446D5",
    "0x7183209867489E1047f3A7c23ea1Aed9c4E236E8",
    "0xD8E1bcCac22EBdc17a9272093757c79c594EBD0b",
    "0x29B4Ea6B1164C7cd8A3a0a1dc4ad88d1E0589124",
    "0x8443EB16A72538897092E30ABb5d077297996Cf8",
    "0x851D6f58F2e5F425dA765453054a39C93f5D940A",
    "0x68a63de8b1055d9a92a200a8c8d823eff290a314",
    "0x96889c4766e3d548f6842a6b3bb0b69d1b707b8c",
    "0x55081b12a3a73236c75bcdd49db04a85cc1496b7",
    "0x8a7376bb3BaEa9d697E078E3168189D49b9cCEeB",
    "0xE69ec4f6f033Fc27aBCd6F696e5E085AE4cb23e4",
    "0xc3f733ca98e0dad0386979eb96fb1722a1a05e69",
    "0x7f463b874ec264dc7bd8c780f5790b4fc371f11f",
    "0xd16809C0a7d82C9E7552a01Fd608fFF90EFb564f",
    "0x312BE6a98441F9F6e3F6246B13CA19701e0AC3B9",
    "0x5cD273B3A06aDe121caC1B92510687a2E16499AB",
    "0x788A73e34AA43aa69aE82a0b150bC27D37f8906F",
    "0x71d7b2adf7Be0377C1AFAAC8666e8dfB30a1956F",
    "0xccb6e4a1c42f4892cde27a8bc2e50bba0b43d224",
    "0x433697232e3b55ec39050cb7a5678a3b1347eec4",
    "0x4c208d5a0606c94cc4198720b198d379ec8a335e",
    "0x4ddeF8Fc8EEE89848b4A802CEF9FC9E72B8674A4",
    "0x5fa42f94e553F566bc2A0EB252ab36E3a432B0f5",
    "0xD94B4363c0d0FbFBeA66A64502EEF87732b86E6d",
    "0x01f9a9ac79044511b7861677dc9f70ed05d09e1f",
    "0xafe4126da89c03c4fB63A82A863083A7b675a936",
    "0x82e8129dafb2d5f06aeded321fb04628f95ef654",
    "0x0fa0ea848de8896367d147054aeb2be517fd1f56",
    "0x1e7c8525f9da0ee635036b6693a45cf57c2fc730",
    "0xe4a89c50d52d46b56aa2ebd5683ef8dd06ffb256",
    "0x4c597608A1045ac3089B4683f2787AF8f991139D",
    "0x849cff095342Cf62C6cb2807A95539C1bdBdB52E",
    "0x94f3302332229c5baaf33cc22aa01bc33661f77c",
    "0xf18E9C8378C84999D07F4b0089bA1AD80e408600",
    "0x36fE476fCec470737437bf2c90F3Aff832Fa6C36",
    "0x8f4D172Acb9D228Df38F7221927944f05DcDc26F",
    "0x02BeeD1404c69e62b76Af6DbdaE41Bd98bcA2Eab",
    "0xbbe3b63484345148d32feabe0912c308a60c879a",
    "0x87f01ce90a531f496ba2d6557d0348c5447895ce",
    "0x9f4303FD6F46f65CfC79Ef715B40A29Ced57731B",
    "0x12C8630369977eE708C8E727d8e838f74D9420C5",
    "0x0a57e26e480355510028b5310FD251df96e2274b",
    "0xDFEA6A1b2f11D12445B969d3A5812Bc93692D6aF",
    "0x3D578dc45a7838CB9010757c73A5830b89d95C05",
    "0xea61926b4c8b5f8e2bc6f85c0bd800969dc79fcf",
    "0xD6D6dFC821c9249718D06971592801C90Cc0b6F5",
    "0x6F4388602C5DD6c593bf7c9Cf3128AaA2a3E09cE",
    "0x7eefee2d0b0e23b7ce6b56a9ce9b62a599e6e9da",
    "0x34f70AF73d742631faD0d3994Ac2b63D26AF6BEe",
    "0xB9D24898b407C4DD5C55487D586FDd8E66ef76Ed",
    "0xbe7aA78bb765BE29113F50830EDf42130c8b6bc1",
    "0xc48dcc4ce6dc018a6ca60ce49c11596db6620e51",
    "0x2a8bf7cb9b8970ddae479a2d3c66459145c38d3c",
    "0x2f46e37477ca4033d74986b15f0572e9913b4858",
    "0x72A94e6c51CB06453B84c049Ce1E1312f7c05e2c",
    "0x125a111cb3163f654e999614cbe7d72e48914f55",
    "0x1FF7e338d5E582138C46044dc238543Ce555C963",
    "0x9251dec8df720c2adf3b6f46d968107cbbadf4d4"
];
var tree = new merkletreejs_1.MerkleTree(addresses.map(ethers_1.utils.keccak256), ethers_1.utils.keccak256, { sortPairs: true });
console.log('the Merkle root is:', tree.getRoot().toString('hex'));
function getMerkleRoot() {
    return tree.getRoot().toString('hex');
}
exports.getMerkleRoot = getMerkleRoot;
function getMerkleProof(address) {
    var hashedAddress = ethers_1.utils.keccak256(address);
    return tree.getHexProof(hashedAddress);
}
exports.getMerkleProof = getMerkleProof;
